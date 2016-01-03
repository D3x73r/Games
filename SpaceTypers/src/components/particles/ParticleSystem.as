package components.particles
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import utils.Config;
	import utils.random;
	import utils.randomNumber;
	
	/**
	 * ...
	 * @author Hristo Dimitrov F43841
	 */
	
	public class ParticleSystem extends MovieClip
	{
		private var _particles:Vector.<Particle>;
		private const _PARTICLES_SPEED:int = 3;
		
		public function ParticleSystem()
		{
			var particle:Particle;
			var randDelta:Number;
			_particles = new <Particle>[];
			
			for (var i:int = 0; i < 50; i++ )
			{
				particle = new Particle();
				particle.size = randomNumber(0.3, 1);
				particle.width *= particle.size;
				particle.height *= particle.size;
				particle.alpha *= particle.size;
				particle.x = random(0, Config.STAGE_WIDTH);
				particle.y = random(0, Config.STAGE_HEIGHT);
				particle.isFalling = random(1, 15) == 1;
				particle.state = particle.isFalling ? particle.STATE_FALLING : particle.STATE_NORMAL;
				addChild(particle);
				
				_particles.push(particle);
			}
			
			stage.addEventListener(Event.ENTER_FRAME, moveParticles);
		}
		
		private function moveParticles($e:Event):void
		{
			for each(var particle:Particle in _particles)
			{
				if (particle.y - particle.height > stage.stageHeight)
				{
					
					particle.size = randomNumber(0.3, 1);
					particle.isFalling = random(1, 15) == 1;
					particle.width = 5 * particle.size;
					particle.height = 5 * particle.size;
					particle.alpha = particle.size;
					particle.x = randomNumber(0, stage.stageWidth);
					particle.y = 0;
					particle.state = particle.isFalling ? particle.STATE_FALLING : particle.STATE_NORMAL;
				}
				else
				{
					particle.y += _PARTICLES_SPEED * particle.size + (particle.isFalling ? 80 : 0) ;
				}
			}
		}
	}
}