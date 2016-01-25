package game
{
	import components.asteroid.Asteroid;
	import components.asteroid.CodeName;
	import components.asteroid.CodeNameLetter;
	import components.AsteroidStage;
	import components.BaseButton;
	import components.CodeNameStage;
	import components.HandsPanel;
	import components.header.Header;
	import components.ship.Ship;
	import components.ship.ShipLazer;
	import components.Transition;
	import data.DBConnect;
	import data.Player;
	import data.PlayerStats;
	import events.GameResultEvent;
	import fl.controls.ComboBox;
	import fl.controls.List;
	import fl.controls.TextInput;
	import flash.desktop.NativeApplication;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import components.BaseComponent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.geom.Point;
	import flash.system.Worker;
	import flash.text.TextField;
	import flash.ui.Keyboard;
	import flash.utils.ByteArray;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;
	import utils.chart.LinesChart;
	import utils.Config;
	import utils.Lang;
	import utils.random;
	import utils.randomNumber;
	import utils.typingeffort.LetterMap;
	import utils.typingeffort.Letters;
	import utils.Verification;
	import utils.workers.TypingEffortWorker;
	import xml.ChartData;
	
	/**
	 * ...
	 * @author Hristo Dimitrov F43841
	 */
	
	public class Manager extends BaseComponent
	{
		private var dbConnect:DBConnect;
		
		public const STATE_INTRO:String = 'intro';
		public const STATE_SELECT_PLAYER:String = 'select_player';
		public const STATE_CREATE_PLAYER:String = 'create_player';
		public const STATE_MENU:String = 'menu';
		public const STATE_GAME:String = 'game';
		public const STATE_GAME_OVER:String = 'game_over';
		public const STATE_GAME_SCORE:String = 'game_score';
		public const STATE_SAVE_PROGRESS:String = 'save_progress';
		public const STATE_STATS:String = 'stats';
		public const STATE_EXIT:String = 'exit';
		
		private const SELECT_PLAYER_BUTTONS:Vector.<Object> = new <Object> 
					[
						{btnName: 'btnSelectPlayer', callback: selectPlayer }, 
						{btnName: 'btnCreateNewPlayer', callback: createNewPlayer }, 
						{btnName: 'btnDeletePlayer', callback: deletePlayer }
					];
		private const CREATE_PLAYER_BUTTONS:Vector.<Object> = new <Object>
					[
						{btnName: 'btnCreate', callback: createPlayer }
					];
		private const MENU_BUTTONS:Vector.<Object> = new <Object>
					[
						{btnName: 'btnPlay', callback: playGame }, 
						{btnName: 'btnStats', callback: showPlayerStats }, 
						{btnName: 'btnChooseNewPlayer', callback: chooseNewPlayer }
					];
		private const GAME_OVER_BUTTONS:Vector.<Object> = new <Object>
					[
						{btnName: 'btnPlayAgain', callback: playGame },
						{btnName: 'btnMenu', callback: showMenu }
					];
					
		private const GAME_SCORE_BUTTONS:Vector.<Object> = new <Object>
					[
						{btnName: 'btnPlayAgain', callback: playGame },
						{btnName: 'btnMenu', callback: showMenu }
					];
		
		// Lists
		public var list_players:List;
		
		//game components
		private var _ship:Ship;
		private var _shipLazer:ShipLazer;
		private var _header:Header;
		private var _handsPanel:HandsPanel;
		private var _transition:Transition;
		
		//Buttons
		private var _btnChooseNewPlayer:BaseButton;
		private var _btnDeletePlayer:BaseButton;
		private var _btnPlayAgain:BaseButton;
		private var _btnMenu:BaseButton;
		private var _btnSelectPlayer:BaseButton;
		private var _btnCreateNewPlayer:BaseButton;
		private var _btnCreate:BaseButton
		private var _btnPlay:BaseButton;
		private var _btnStats:BaseButton;
		
		// Dynamic texts 
		private var _txtNick:TextField;
		private var _txtHint:TextField;
		private var _txtFinalScore:TextField;
		
		// Inputs
		private var _txtInpNick:TextInput;
		private var _txtInpFName:TextInput;
		private var _txtInpLName:TextInput;
		private var _keyboardsList:ComboBox;
		
		//stages
		private var _codeNameStage:CodeNameStage;
		private var _asteroidStage:AsteroidStage;
		
		//player info
		private var _currentPlayer:Player;
		
		//game specifics
		private var _level:int = 1;
		private var _codeNames:Vector.<String>;
		private var _currentAsteroid:Asteroid;
		private var _levelParams:LevelParams;
		private var _lives:int;
		private var _asteroidsCount:int;
		private var _asteroidsPerLevel:int = 2;
		private var _keyBoardId:int = -1;
		private var _wordTimeStart:int;
		private var _currLetterMap:LetterMap;
		
		public function Manager()
		{
			super();
			
			addEventListener(_STATE_CHANGED, onStateChange);
			
			dbConnect = new DBConnect(); //connect to DataBase
			
			state = STATE_INTRO;
			var arr:ByteArray = new ByteArray();
			var obj:Object = { x:5, y:8 };
			arr.writeObject(obj);
			var tmp:TypingEffortWorker = new TypingEffortWorker();
			
			tmp.sendData(arr);
		}
		
		private function showMenu():void
		{
			dbConnect.savePlayerScore(_currentPlayer);

			_currentPlayer.stats = null;
			
			state = STATE_MENU
		}
		
		private function onStateChange($e:Event):void
		{
			switch (state)
			{
				case STATE_INTRO: 
					stage.addEventListener(KeyboardEvent.KEY_DOWN, onEvKeyDown);
					break;
				case STATE_SELECT_PLAYER: 
					list_players.removeAll(); // Clear list
					
					for each (var player:Player in dbConnect.allPlayers)
					{
						trace(dbConnect.allPlayers.length);
						
						list_players.addItem({label: player.playerId + '. ' + player.nick, player: player});
					}
					
					handleButtons();
					
					//dbConnect.test();
					break;
				case STATE_CREATE_PLAYER: 
					handleButtons();
					break;
				case STATE_MENU: 
					var button:BaseButton;
					var posY:Number = 0;
					
					(txtNick as TextField).text = _currentPlayer.nick;
					handleButtons();
					
					break;
				case STATE_GAME: 
					if (!_currentPlayer.stats) _currentPlayer.stats = new PlayerStats(_currentPlayer.playerId);
					if (header.txtScore)
					{
						header.txtScore.text = _currentPlayer.stats.score.toString();
					}
					
					_levelParams = new LevelParams();
					_levelParams.addEventListener(LevelParams.EVENT_LEVEL_PARAMS_SET, onLevelParamsSet);
					_level++;
					_asteroidsPerLevel++;
					
					if (_asteroidsPerLevel >= 15) _asteroidsPerLevel = 15;
					
					_levelParams.init(_level, keyBoardId);
					break;
				case STATE_GAME_OVER: 
					dbConnect.savePlayerScore(_currentPlayer);
					
					_currentPlayer.stats = null;
					_level = 1;
					_asteroidsPerLevel = 2;
					
					transition.hide();
					handleButtons();
					break;
				case STATE_GAME_SCORE:
					transition.hide();
					handleButtons();
					break;
				case STATE_SAVE_PROGRESS: 
					state = STATE_STATS;
					break;
				case STATE_STATS: 
					//dbConnect.addEventListener(dbConnect.EVENT_SCORES_LOADED, function() {
							//if (dbConnect.hasScores)
							//{
								//var tmpArr:Array = [new Array("Score")];
								//var arr:Array = [];
								//
								//trace(dbConnect.scores);
								//
								//for (var f:int = 0; f <  dbConnect.scores.length;  f++)
								//{
									//arr.push(new Array(f, dbConnect.scores[f]));
								//}
								//
								//tmpArr.push(arr);
								//
								//var chartData:ChartData = new ChartData(tmpArr);
								//var lc:LinesChart = new LinesChart(chartData.data);
								//
								//addChild(lc);
							//}
							//else
							//{
								//trace('no scores for this player yet!');
							//}
						//});
					//dbConnect.getPlayerScore(_currentPlayer.stats.playerId);
					//var chartData:ChartData = new ChartData([["aaaaaaa"], [1, 2.3], [1, 7.3], [1, 1.3], [1, 9.3]], [['bbbbbbb'], [2, 3.3], [2, 6.3], [2, 5.3], [2, 6.3]], [['vvvvvvvv'], [3, 6.3], [3, 1.3], [3, 10.3], [3, 0.3]], [['gggggggg'], [4, 16.3], [4, 11.3], [4, 13.3], [4, 1.3]]);
					var chartData:ChartData = new ChartData([1,2,3,4], ["aaaaaaa", 2.3, 3.3, 6.3, 16.3], ["bbbbbbb", 1.3, 2.3, 0.3, 10.3]);
					var lc:LinesChart = new LinesChart(chartData.data);
					
					addChild(lc);
					
					break;
				case STATE_EXIT: 
					break;
			}
		}
		
		private function onLevelParamsSet($e:Event):void
		{
			removeEventListener(LevelParams.EVENT_LEVEL_PARAMS_SET, onLevelParamsSet);
			
			var count:int = 0;
			
			lives = lives == 0 ? Config.INIT_LIVES : lives;
			
			_asteroidsCount = 0;
			
			addEventListener(GameResultEvent.GAME_RESULT, updateResultData);
			
			stage.focus = stage;
			
			asteroidStage.codeNameStage = codeNameStage;
			addEventListener(Asteroid.EVENT_ASTEROID_DESTROYED, asteroidRemoved, true);
			addEventListener(Asteroid.EVENT_ASTEROID_OUT_OF_RANGE, asteroidRemoved, true);
			
			for (var k:int = 0; k < _asteroidsPerLevel; k++)
			{
				//trace('k=', k)
				setTimeout(function()
					{
						var randomId:int = random(0, int(_levelParams.codeNames.length - (_levelParams.codeNames.length / 3)))
						var codeName:CodeName = new CodeName(_levelParams.codeNames[randomId].word, -25, -10, _levelParams.codeNames[randomId].effort);
						var asteroid:Asteroid = new Asteroid(codeName, randomNumber(0.2, 0.6));
						
						asteroid.x = randomNumber(0, Config.STAGE_WIDTH - asteroid.width - asteroid.codeNameTxt.width);
						asteroid.y = -asteroid.height;
						
						codeName.x += asteroid.x + asteroid.width;
						codeName.y += asteroid.y;
						
						asteroidStage.addChild(asteroid);
						codeNameStage.addChild(codeName);
					}, k * 1000);
			}
			
			transition.hide();
		}
		
		private function onDataLoaded($e:Event = null):void
		{
			if (dbConnect.hasRegisteredPlayers)
			{
				state = STATE_SELECT_PLAYER;
			}
			else
			{
				state = STATE_CREATE_PLAYER;
			}
		}
		
		private function handleButtons():void
		{
			//trace(state.toUpperCase() + '_BUTTONS');
			var buttonsInfo:Vector.<Object> = this[state.toUpperCase() + '_BUTTONS'];
			var btn:BaseButton;
			
			for each (var btnInfo:Object in buttonsInfo)
			{
				btn = this[btnInfo.btnName as String] as BaseButton;
				btn.callback = btnInfo.callback;
			}
		
		}
		
		private function createPlayer():void
		{
			var player:Player;
			var id:int;
			var nick:String = (txtInpNick as TextInput).text;
			var fname:String = (txtInpFName as TextInput).text;
			var lname:String = (txtInpLName as TextInput).text;
			
			if (Verification.PATTERN_NICK.test(nick))
			{
				if (Verification.PATTERN_FIRST_NAME.test(fname))
				{
					if (Verification.PATTERN_LAST_NAME.test(lname))
					{
						
						if (dbConnect.hasRegisteredPlayers)
						{
							id = dbConnect.allPlayers[dbConnect.allPlayers.length - 1].stats.playerId + 1;
						}
						else
						{
							id = 1;
						}
						
						player = new Player(nick, fname, lname, id);
						
						_currentPlayer = player;
						
						dbConnect.addEventListener(dbConnect.EVENT_PLAYER_REGSTERED, onPlayerRegistered);
						
						dbConnect.registerPlayer(player);
						
						trace('Everything is ok saving information in database!');
					}
					else
					{
						txtHint.text = Verification.HINT_LAST_NAME;
					}
				}
				else
				{
					txtHint.text = Verification.HINT_FIRST_NAME;
				}
			}
			else
			{
				txtHint.text = Verification.HINT_NICK;
			}
		}
		
		private function onPlayerRegistered($e:Event):void
		{
			dbConnect.removeEventListener(dbConnect.EVENT_PLAYER_REGSTERED, onPlayerRegistered);
			
			state = STATE_MENU;
		}
		
		private function selectPlayer():void
		{
			if (list_players.selectedItem)
			{
				_currentPlayer = (list_players.selectedItem.player as Player);
				
				state = STATE_MENU;
			}
			else
			{
				trace('Please select player!');
			}
		}
		
		private function createNewPlayer():void
		{
			state = STATE_CREATE_PLAYER;
		}
		
		private function deletePlayer():void
		{
		
		}
		
		private function playGame():void
		{
			trace('===========================================================')
			if (keyboardsList) keyBoardId = keyboardsList.selectedIndex;
			if (keyBoardId == -1)
			{
				txtHint.text = Lang.HINT_KEYBOARD;
			}
			else
			{
				transition.show(function () 
					{
						state = STATE_GAME;
					});
			}
		}
		
		private function showPlayerStats():void
		{
			
			state = STATE_STATS;
		}
		
		private function chooseNewPlayer():void
		{
			dbConnect.addEventListener(dbConnect.EVENT_DATA_LOADED, function updateList($e:Event)
				{
					
					dbConnect.removeEventListener(dbConnect.EVENT_DATA_LOADED, updateList);
					
					state = STATE_SELECT_PLAYER;
				
				});
			
			dbConnect.selectAllPlayers();
		}
		
		private function exitGame():void
		{
			NativeApplication.nativeApplication.exit();
		}
		
		private function onEvKeyDown($e:KeyboardEvent):void
		{
			if ($e.keyCode == Keyboard.SPACE && state == STATE_INTRO)
			{
				trace(dbConnect.dataLoadedMainDB);
				if (dbConnect.dataLoadedMainDB)
				{
					onDataLoaded();
				}
				else
				{
					dbConnect.addEventListener(dbConnect.EVENT_DATA_LOADED, onDataLoaded)
				}
			}
			else if (state == STATE_GAME)
			{
				var letter:String = Config.getLetterFromKey($e.keyCode);
				
				getAsteroid(letter);
			}
		}
		
		private function getAsteroid($letter:String):void
		{
			var tmpAsteroid:Asteroid;
			
			if ($letter == Config.NOT_LETTER)
			{
				return;
			}
			if (asteroidStage.numChildren == 0)
			{
				return;
			}
			
			if (!_currentAsteroid)
			{
				_wordTimeStart = getTimer();
				
				for (var i:int = 0; i < asteroidStage.numChildren; i++)
				{
					tmpAsteroid = asteroidStage.getChildAt(i) as Asteroid;
					if (tmpAsteroid.codeNameTxt.currentLetter == $letter)
					{
						if (_currentAsteroid)
						{
							if (_currentAsteroid.y < tmpAsteroid.y)
							{
								_currentAsteroid = tmpAsteroid;
							}
						}
						else
						{
							_currentAsteroid = tmpAsteroid;
						}
					}
				}
			}
			
			if (_currentAsteroid)
			{
				//trace('22222222222222', $letter)
				
				if (ship && !ship.following)
				{
					ship.follow(_currentAsteroid);
				}
				
				checkLetter($letter);
			}
		}
		
		private function checkLetter($letter:String):void
		{
			//trace('3333333333333333')
			_currLetterMap = Letters.getMap(_currentAsteroid.codeNameTxt.currentLetter.toLowerCase(), keyBoardId);
			
			if (_currentAsteroid.codeNameTxt.currentLetter == $letter)
			{
				
				shoot();
				
				_currentAsteroid.codeNameTxt.removeLetter();
				_currentAsteroid.codeNameTxt.textStyle = _currentAsteroid.codeNameTxt.TEXT_STYLE_ACTIVE;
				handsPanel.finger = Letters.getMap(_currentAsteroid.codeNameTxt.currentLetter.toLowerCase(), keyBoardId).finger;
				
			}
			else
			{
				_currentAsteroid.codeNameTxt.textStyle = _currentAsteroid.codeNameTxt.TEXT_STYLE_ERROR;
				_currentPlayer.stats.handleFingerHandErrCount(_currLetterMap);
			}
		}
		
		private function shoot():void
		{
			var asteroidMarkerPos:Point = new Point(_currentAsteroid.marker.x, _currentAsteroid.marker.y);
			var asteroidMarkerPosGlobal:Point = _currentAsteroid.localToGlobal(asteroidMarkerPos);
			var dx:Number = ship.x - asteroidMarkerPosGlobal.x;
			var dy:Number = ship.y - asteroidMarkerPosGlobal.y;
			
			shipLazer.rotation = 0;
			shipLazer.height = Math.sqrt(dx * dx + dy * dy);
			shipLazer.scaleX = 1;
			shipLazer.rotation = ship.rotation;
			
			shipLazer.gotoAndPlay(shipLazer.STATE_SHOW);
		
		}
		
		private function asteroidRemoved($e:Event):void
		{
			handsPanel.finger = handsPanel.NO_FINGER;
			
			if ($e.type == Asteroid.EVENT_ASTEROID_OUT_OF_RANGE)
			{
				lives--;
			}
			else
			{
				_currentPlayer.stats.completedWords++;
				_currentPlayer.stats.timeMain += (Math.round((((getTimer() - _wordTimeStart) / 1000) / 60) * 100) / 100);
			}
			
			
			_asteroidsCount++;
			
			ship.stopFollow();
			
			if (lives <= 0)
			{
				trace('event game over !!!!!')
				levelEnd(true);
			}
			else if (_asteroidsCount >= _asteroidsPerLevel)
			{
				trace('event game next level!!!');
				levelEnd();
			}
			
			_currentAsteroid = null;
		}
		
		private function levelEnd($gameOver:Boolean = false):void
		{
			removeEventListener(GameResultEvent.GAME_RESULT, updateResultData);
			
			if ($gameOver)
			{
				transition.show( function()
					{
						state = STATE_GAME_OVER;
						setFinalScore();
					});
			}
			else
			{
				//trace('this shoud not happen twice!')
				transition.show( function()
					{
						state = STATE_GAME_SCORE;
						setFinalScore();
					});
					
			}
			
		}
		
		private function setFinalScore():void
		{
			txtFinalScore.text = _currentPlayer.stats.score.toString();
		}
		
		private function updateResultData($e:GameResultEvent):void
		{
			_currentPlayer.stats.score += $e.win;
			_currentPlayer.stats.accuracy = $e.accuracy;
			
			trace(_currentPlayer.stats.accuracy);
			
			if (header.txtScore)
			{
				header.txtScore.text = _currentPlayer.stats.score.toString();
			}
		}
		
		public function get ship():Ship
		{
			if (!_ship)
			{
				_ship = getChildByName('player_ship') as Ship;
				
				if (_ship)
				{
					_ship.addEventListener(Event.REMOVED_FROM_STAGE, cleanUpShip);
				}
				
			}
			
			return _ship;
		}
		
		private function cleanUpShip($e:Event):void
		{
			_ship.removeEventListener(Event.REMOVED_FROM_STAGE, cleanUpShip);
			_ship = null;
		}
		
		public function get shipLazer():ShipLazer
		{
			if (!_shipLazer)
			{
				_shipLazer = getChildByName('ship_lazer') as ShipLazer;
				
				if (_shipLazer)
				{
					_shipLazer.addEventListener(Event.REMOVED_FROM_STAGE, cleanUpShipLazer);
				}
				
			}
			
			return _shipLazer;
		}
		
		private function cleanUpShipLazer($e:Event):void
		{
			_shipLazer.removeEventListener(Event.REMOVED_FROM_STAGE, cleanUpShipLazer);
			_shipLazer = null;
		}
		
		public function get btnSelectPlayer():BaseButton
		{
			if (!_btnSelectPlayer)
			{
				_btnSelectPlayer = getChildByName('btn_select_player') as BaseButton;
				
				if (_btnSelectPlayer)
				{
					_btnSelectPlayer.addEventListener(Event.REMOVED_FROM_STAGE, cleanUpBtnSelectPlayer);
				}
				
			}
			
			return _btnSelectPlayer;
		}
		
		private function cleanUpBtnSelectPlayer($e:Event):void
		{
			_btnSelectPlayer.removeEventListener(Event.REMOVED_FROM_STAGE, cleanUpBtnSelectPlayer);
			_btnSelectPlayer = null;
		}
		
		public function get btnCreateNewPlayer():BaseButton
		{
			if (!_btnCreateNewPlayer)
			{
				_btnCreateNewPlayer = getChildByName('btn_create_new_player') as BaseButton;
				
				if (_btnCreateNewPlayer)
				{
					_btnCreateNewPlayer.addEventListener(Event.REMOVED_FROM_STAGE, cleanUpBtnCreateNewPlayer);
				}
				
			}
			
			return _btnCreateNewPlayer;
		}
		
		private function cleanUpBtnCreateNewPlayer($e:Event):void
		{
			_btnCreateNewPlayer.removeEventListener(Event.REMOVED_FROM_STAGE, cleanUpBtnCreateNewPlayer);
			_btnCreateNewPlayer = null;
		}
		
		public function get btnCreate():BaseButton
		{
			if (!_btnCreate)
			{
				_btnCreate = getChildByName('btn_create') as BaseButton;
				
				if (_btnCreate)
				{
					_btnCreate.addEventListener(Event.REMOVED_FROM_STAGE, cleanUpBtnCreate);
				}
				
			}
			
			return _btnCreate;
		}
		
		private function cleanUpBtnCreate($e:Event):void
		{
			_btnCreate.removeEventListener(Event.REMOVED_FROM_STAGE, cleanUpBtnCreate);
			_btnCreate = null;
		}
		
		public function get btnPlay():BaseButton
		{
			if (!_btnPlay)
			{
				_btnPlay = getChildByName('btn_play') as BaseButton;
				
				if (_btnPlay)
				{
					_btnPlay.addEventListener(Event.REMOVED_FROM_STAGE, cleanUpBtnPlay);
				}
				
			}
			
			return _btnPlay;
		}
		
		private function cleanUpBtnPlay($e:Event):void
		{
			_btnPlay.removeEventListener(Event.REMOVED_FROM_STAGE, cleanUpBtnPlay);
			_btnPlay = null;
		}
		
		public function get btnStats():BaseButton
		{
			if (!_btnStats)
			{
				_btnStats = getChildByName('btn_stats') as BaseButton;
				
				if (_btnStats)
				{
					_btnStats.addEventListener(Event.REMOVED_FROM_STAGE, cleanUpBtnStats);
				}
				
			}
			
			return _btnStats;
		}
		
		private function cleanUpBtnStats($e:Event):void
		{
			_btnStats.removeEventListener(Event.REMOVED_FROM_STAGE, cleanUpBtnStats);
			_btnStats = null;
		}
		
		public function get btnChooseNewPlayer():BaseButton
		{
			if (!_btnChooseNewPlayer)
			{
				_btnChooseNewPlayer = getChildByName('btn_choose_new_player') as BaseButton;
				
				if (_btnChooseNewPlayer)
				{
					_btnChooseNewPlayer.addEventListener(Event.REMOVED_FROM_STAGE, cleanUpBtnChooseNewPlayer);
				}
				
			}
			
			return _btnChooseNewPlayer;
		}
		
		private function cleanUpBtnChooseNewPlayer($e:Event):void
		{
			_btnChooseNewPlayer.removeEventListener(Event.REMOVED_FROM_STAGE, cleanUpBtnChooseNewPlayer);
			_btnChooseNewPlayer = null
		}
		
		public function get btnDeletePlayer():BaseButton
		{
			if (!_btnDeletePlayer)
			{
				_btnDeletePlayer = getChildByName('btn_delete_player') as BaseButton;
				
				if (_btnDeletePlayer)
				{
					_btnDeletePlayer.addEventListener(Event.REMOVED_FROM_STAGE, cleanUpBtnDeletePlayer);
				}
				
			}
			
			return _btnDeletePlayer;
		}
		
		private function cleanUpBtnDeletePlayer($e:Event):void
		{
			_btnDeletePlayer.removeEventListener(Event.REMOVED_FROM_STAGE, cleanUpBtnDeletePlayer);
			_btnDeletePlayer = null;
		}
		
		public function get btnPlayAgain():BaseButton
		{
			if (!_btnPlayAgain)
			{
				_btnPlayAgain = getChildByName('btn_play_again') as BaseButton;
				
				if (_btnPlayAgain)
				{
					_btnPlayAgain.addEventListener(Event.REMOVED_FROM_STAGE, cleanUpBtnPlayAgain);
				}
				
			}
			
			return _btnPlayAgain;
		}
		
		private function cleanUpBtnPlayAgain($e:Event):void
		{
			_btnPlayAgain.removeEventListener(Event.REMOVED_FROM_STAGE, cleanUpBtnPlayAgain);
			_btnPlayAgain = null;
		}
		
		public function get btnMenu():BaseButton
		{
			if (!_btnMenu)
			{
				_btnMenu = getChildByName('btn_menu') as BaseButton;
				
				if (_btnMenu)
				{
					_btnMenu.addEventListener(Event.REMOVED_FROM_STAGE, cleanUpBtnMenu);
				}
				
			}
			
			return _btnMenu;
		}
		
		private function cleanUpBtnMenu($e:Event):void
		{
			_btnMenu.removeEventListener(Event.REMOVED_FROM_STAGE, cleanUpBtnPlayAgain);
			_btnMenu = null;
		}
		
		public function get txtNick():TextField 
		{
			if (!_txtNick)
			{
				_txtNick = getChildByName('txt_nick') as TextField;
				
				if (_txtNick)
				{
					_txtNick.addEventListener(Event.REMOVED_FROM_STAGE, cleanUpTxtNick);
				}
				
			}
			
			return _txtNick;
		}
		
		private function cleanUpTxtNick($e:Event):void 
		{
			_txtNick.removeEventListener(Event.REMOVED_FROM_STAGE, cleanUpTxtNick);
			_txtNick = null;
		}
		
		public function get txtHint():TextField 
		{
			if (!_txtHint)
			{
				_txtHint = getChildByName('txt_hint') as TextField;
				
				if (_txtHint)
				{
					_txtHint.addEventListener(Event.REMOVED_FROM_STAGE, cleanUpTxtHint);
				}
				
			}
			
			return _txtHint;
		}
		
		private function cleanUpTxtHint($e:Event):void 
		{
			_txtHint.removeEventListener(Event.REMOVED_FROM_STAGE, cleanUpTxtHint);
			_txtHint = null;
		}
		
		public function get txtFinalScore():TextField 
		{
			if (!_txtFinalScore)
			{
				_txtFinalScore = getChildByName('txt_final_score') as TextField;
				
				if (_txtFinalScore)
				{
					_txtFinalScore.addEventListener(Event.REMOVED_FROM_STAGE, cleanUpTxtFinalScore)
				}
				
			}
			
			return _txtFinalScore;
		}
		
		private function cleanUpTxtFinalScore($e:Event):void 
		{
			_txtFinalScore.removeEventListener(Event.REMOVED_FROM_STAGE, cleanUpTxtFinalScore);
			_txtFinalScore = null;
		}
		
		public function get txtInpNick():TextInput 
		{
			if (!_txtInpNick)
			{
				_txtInpNick = getChildByName('txt_inp_nick') as TextInput;
				
				if (_txtInpNick)
				{
					_txtInpNick.addEventListener(Event.REMOVED_FROM_STAGE, cleanUpTxtInpNick);
				}
				
			}
			
			return _txtInpNick;
		}
		
		private function cleanUpTxtInpNick($e:Event):void 
		{
			_txtInpNick.removeEventListener(Event.REMOVED_FROM_STAGE, cleanUpTxtInpNick);
			_txtInpNick = null;
		}
		
		public function get txtInpFName():TextInput 
		{
			if (!_txtInpFName)
			{
				_txtInpFName = getChildByName('txt_inp_fname') as TextInput;
				
				if (_txtInpFName)
				{
					_txtInpFName.addEventListener(Event.REMOVED_FROM_STAGE, cleanUpTxtInpFName);
				}
				
			}
			
			return _txtInpFName;
		}
		
		private function cleanUpTxtInpFName($e:Event):void 
		{
			_txtInpFName.removeEventListener(Event.REMOVED_FROM_STAGE, cleanUpTxtInpFName);
			_txtInpFName = null;
		}
		
		public function get txtInpLName():TextInput 
		{
			if (!_txtInpLName)
			{
				_txtInpLName = getChildByName('txt_inp_lname') as TextInput;
				
				if (_txtInpLName)
				{
					_txtInpLName.addEventListener(Event.REMOVED_FROM_STAGE, cleanUpInpLName);
				}
				
			}
			
			return _txtInpLName;
		}
		
		private function cleanUpInpLName($e:Event):void 
		{
			_txtInpLName.removeEventListener(Event.REMOVED_FROM_STAGE, cleanUpInpLName);
			_txtInpLName = null;
		}
		
		public function get codeNameStage():CodeNameStage 
		{
			if (!_codeNameStage)
			{
				_codeNameStage = getChildByName('code_name_stage') as CodeNameStage;
				
				if (_codeNameStage)
				{
					_codeNameStage.addEventListener(Event.REMOVED_FROM_STAGE, cleanUpCodeNameStage);
				}
				
			}
			
			return _codeNameStage;
		}
		
		private function cleanUpCodeNameStage($e:Event):void 
		{
			_codeNameStage.removeEventListener(Event.REMOVED_FROM_STAGE, cleanUpCodeNameStage);
			_codeNameStage = null;
		}
		
		public function get asteroidStage():AsteroidStage 
		{
			if (!_asteroidStage)
			{
				_asteroidStage = getChildByName('asteroid_stage') as AsteroidStage;
				
				if (_asteroidStage)
				{
					_asteroidStage.addEventListener(Event.REMOVED_FROM_STAGE, cleanUpAsteroidStage);
				}
				
			}
			
			return _asteroidStage;
		}
		
		private function cleanUpAsteroidStage($e:Event):void 
		{
			_asteroidStage.removeEventListener(Event.REMOVED_FROM_STAGE, cleanUpAsteroidStage);
			_asteroidStage = null;
		}
		
		public function get lives():int 
		{
			return _lives;
		}
		
		public function set lives($value:int):void 
		{
			_lives = $value;
			header.livesPanel.lives = lives;
		}
		
		public function get header():Header 
		{
			if (!_header)
			{
				_header = getChildByName('header_panel') as Header;
				
				if (_header)
				{
					_header.addEventListener(Event.REMOVED_FROM_STAGE, cleanUpHeader);
				}
				
			}
			
			return _header;
		}
		
		private function cleanUpHeader($e:Event):void 
		{
			_header.removeEventListener(Event.REMOVED_FROM_STAGE, cleanUpHeader);
			_header = null;
		}
		
		
		public function set keyBoardId($value:int):void 
		{
			_keyBoardId = $value;
		}
		
		public function get keyBoardId():int 
		{
			return _keyBoardId;
		}
		
		public function get keyboardsList():ComboBox 
		{
			if (!_keyboardsList)
			{
				_keyboardsList = getChildByName('keyboards_list') as ComboBox;
				
				if (_keyboardsList)
				{
					_keyboardsList.addEventListener(Event.REMOVED_FROM_STAGE, cleanUpKeyboardsList);
				}
				
			}
			
			return _keyboardsList;
		}
		
		private function cleanUpKeyboardsList($e:Event):void 
		{
			_keyboardsList.removeEventListener(Event.REMOVED_FROM_STAGE, cleanUpKeyboardsList);
			_keyboardsList = null
		}
		
		public function get handsPanel():HandsPanel 
		{
			if (!_handsPanel)
			{
				_handsPanel = getChildByName('hands_panel') as HandsPanel;
				
				if (_handsPanel)
				{
					_handsPanel.addEventListener(Event.REMOVED_FROM_STAGE, cleanUpHandsPanel);
				}
				
			}
			
			return _handsPanel;
		}
		
		private function cleanUpHandsPanel($e:Event):void 
		{
			_handsPanel.removeEventListener(Event.REMOVED_FROM_STAGE, cleanUpHandsPanel);
			_handsPanel = null;
		}
		
		public function get transition():Transition 
		{
			if (!_transition)
			{
				_transition = getChildByName('transition_panel') as Transition;
				
				if (_transition)
				{
					_transition.addEventListener(Event.REMOVED_FROM_STAGE, cleanUpTransition);
				}
				
			}
			
			return _transition;
		}
		
		private function cleanUpTransition($e:Event):void 
		{
			_transition.removeEventListener(Event.REMOVED_FROM_STAGE, cleanUpTransition);
			_transition = null;
		}
	}
}