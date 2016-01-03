package utils.typingeffort
{
	/**
	 * ...
	 * @author Hristo Dimitrov F43841
	 */
	
	public final class Letters 
	{
		public static const QWERTY:int = 0;
		public static const DVORAK:int = 1;
		public static const COLEMARK:int = 2;
		public static const HALLINGSTAD:int = 3;
		
		//QWERTY
		private static const a_0:LetterMap = new LetterMap('a', 0, 'L', 0.0, 1);
		private static const b_0:LetterMap = new LetterMap('b', 3, 'L', 3.5, 2);
		private static const c_0:LetterMap = new LetterMap('c', 2, 'L', 2.0, 2);
		private static const d_0:LetterMap = new LetterMap('d', 2, 'L', 0.0, 1);
		private static const e_0:LetterMap = new LetterMap('e', 2, 'L', 2.0, 0);
		private static const f_0:LetterMap = new LetterMap('f', 3, 'L', 0.0, 1);
		private static const g_0:LetterMap = new LetterMap('g', 3, 'L', 2.0, 1);
		private static const h_0:LetterMap = new LetterMap('h', 6, 'R', 2.0, 1);
		private static const i_0:LetterMap = new LetterMap('i', 7, 'R', 2.0, 0);
		private static const j_0:LetterMap = new LetterMap('j', 6, 'R', 0.0, 1);
		private static const k_0:LetterMap = new LetterMap('k', 7, 'R', 0.0, 1);
		private static const l_0:LetterMap = new LetterMap('l', 8, 'R', 0.0, 1);
		private static const m_0:LetterMap = new LetterMap('m', 6, 'R', 2.0, 2);
		private static const n_0:LetterMap = new LetterMap('n', 6, 'R', 2.0, 2);
		private static const o_0:LetterMap = new LetterMap('o', 8, 'R', 2.0, 0);
		private static const p_0:LetterMap = new LetterMap('p', 9, 'R', 2.0, 0);
		private static const q_0:LetterMap = new LetterMap('q', 0, 'L', 2.0, 0);
		private static const r_0:LetterMap = new LetterMap('r', 3, 'L', 2.0, 0);
		private static const s_0:LetterMap = new LetterMap('s', 1, 'L', 0.0, 1);
		private static const t_0:LetterMap = new LetterMap('t', 3, 'L', 2.5, 0);
		private static const u_0:LetterMap = new LetterMap('u', 6, 'R', 2.0, 0);
		private static const v_0:LetterMap = new LetterMap('v', 3, 'L', 2.0, 2);
		private static const w_0:LetterMap = new LetterMap('w', 1, 'L', 2.0, 0);
		private static const x_0:LetterMap = new LetterMap('x', 1, 'L', 2.0, 2);
		private static const y_0:LetterMap = new LetterMap('y', 6, 'R', 3.0, 0);
		private static const z_0:LetterMap = new LetterMap('z', 0, 'L', 2.0, 2);
		
		public static const maps_0:Vector.<LetterMap> = new <LetterMap>[a_0, b_0, c_0, d_0, e_0, f_0, g_0, h_0, i_0, j_0, k_0, l_0, m_0, n_0, o_0, p_0, q_0, r_0, s_0, t_0, u_0, v_0, w_0, x_0, y_0, z_0];
		
		//DVORAK
		private static const a_1:LetterMap = new LetterMap('a', 0, 'L', 0.0, 1);
		private static const b_1:LetterMap = new LetterMap('b', 3, 'L', 3.5, 2);
		private static const c_1:LetterMap = new LetterMap('c', 2, 'L', 2.0, 2);
		private static const d_1:LetterMap = new LetterMap('d', 2, 'L', 0.0, 1);
		private static const e_1:LetterMap = new LetterMap('e', 2, 'L', 2.0, 0);
		private static const f_1:LetterMap = new LetterMap('f', 3, 'L', 0.0, 1);
		private static const g_1:LetterMap = new LetterMap('g', 3, 'L', 2.0, 1);
		private static const h_1:LetterMap = new LetterMap('h', 6, 'R', 2.0, 1);
		private static const i_1:LetterMap = new LetterMap('i', 7, 'R', 2.0, 0);
		private static const j_1:LetterMap = new LetterMap('j', 6, 'R', 0.0, 1);
		private static const k_1:LetterMap = new LetterMap('k', 7, 'R', 0.0, 1);
		private static const l_1:LetterMap = new LetterMap('l', 8, 'R', 0.0, 1);
		private static const m_1:LetterMap = new LetterMap('m', 6, 'R', 2.0, 2);
		private static const n_1:LetterMap = new LetterMap('n', 6, 'R', 2.0, 2);
		private static const o_1:LetterMap = new LetterMap('o', 8, 'R', 2.0, 0);
		private static const p_1:LetterMap = new LetterMap('p', 9, 'R', 2.0, 0);
		private static const q_1:LetterMap = new LetterMap('q', 0, 'L', 2.0, 0);
		private static const r_1:LetterMap = new LetterMap('r', 3, 'L', 2.0, 0);
		private static const s_1:LetterMap = new LetterMap('s', 1, 'L', 0.0, 1);
		private static const t_1:LetterMap = new LetterMap('t', 3, 'L', 2.5, 0);
		private static const u_1:LetterMap = new LetterMap('u', 6, 'R', 2.0, 0);
		private static const v_1:LetterMap = new LetterMap('v', 3, 'L', 2.0, 2);
		private static const w_1:LetterMap = new LetterMap('w', 1, 'L', 2.0, 0);
		private static const x_1:LetterMap = new LetterMap('x', 1, 'L', 2.0, 2);
		private static const y_1:LetterMap = new LetterMap('y', 6, 'R', 3.0, 0);
		private static const z_1:LetterMap = new LetterMap('z', 0, 'L', 2.0, 2);
		
		public static const maps_1:Vector.<LetterMap> = new <LetterMap>[a_1, b_1, c_1, d_1, e_1, f_1, g_1, h_1, i_1, j_1, k_1, l_1, m_1, n_1, o_1, p_1, q_1, r_1, s_1, t_1, u_1, v_1, w_1, x_1, y_1, z_1];
		
		//COLLEMARK
		private static const a_2:LetterMap = new LetterMap('a', 0, 'L', 0.0, 1);
		private static const b_2:LetterMap = new LetterMap('b', 3, 'L', 3.5, 2);
		private static const c_2:LetterMap = new LetterMap('c', 2, 'L', 2.0, 2);
		private static const d_2:LetterMap = new LetterMap('d', 2, 'L', 0.0, 1);
		private static const e_2:LetterMap = new LetterMap('e', 2, 'L', 2.0, 0);
		private static const f_2:LetterMap = new LetterMap('f', 3, 'L', 0.0, 1);
		private static const g_2:LetterMap = new LetterMap('g', 3, 'L', 2.0, 1);
		private static const h_2:LetterMap = new LetterMap('h', 6, 'R', 2.0, 1);
		private static const i_2:LetterMap = new LetterMap('i', 7, 'R', 2.0, 0);
		private static const j_2:LetterMap = new LetterMap('j', 6, 'R', 0.0, 1);
		private static const k_2:LetterMap = new LetterMap('k', 7, 'R', 0.0, 1);
		private static const l_2:LetterMap = new LetterMap('l', 8, 'R', 0.0, 1);
		private static const m_2:LetterMap = new LetterMap('m', 6, 'R', 2.0, 2);
		private static const n_2:LetterMap = new LetterMap('n', 6, 'R', 2.0, 2);
		private static const o_2:LetterMap = new LetterMap('o', 8, 'R', 2.0, 0);
		private static const p_2:LetterMap = new LetterMap('p', 9, 'R', 2.0, 0);
		private static const q_2:LetterMap = new LetterMap('q', 0, 'L', 2.0, 0);
		private static const r_2:LetterMap = new LetterMap('r', 3, 'L', 2.0, 0);
		private static const s_2:LetterMap = new LetterMap('s', 1, 'L', 0.0, 1);
		private static const t_2:LetterMap = new LetterMap('t', 3, 'L', 2.5, 0);
		private static const u_2:LetterMap = new LetterMap('u', 6, 'R', 2.0, 0);
		private static const v_2:LetterMap = new LetterMap('v', 3, 'L', 2.0, 2);
		private static const w_2:LetterMap = new LetterMap('w', 1, 'L', 2.0, 0);
		private static const x_2:LetterMap = new LetterMap('x', 1, 'L', 2.0, 2);
		private static const y_2:LetterMap = new LetterMap('y', 6, 'R', 3.0, 0);
		private static const z_2:LetterMap = new LetterMap('z', 0, 'L', 2.0, 2);
		
		public static const maps_2:Vector.<LetterMap> = new <LetterMap>[a_2, b_2, c_2, d_2, e_2, f_2, g_2, h_2, i_2, j_2, k_2, l_2, m_2, n_2, o_2, p_2, q_2, r_2, s_2, t_2, u_2, v_2, w_2, x_2, y_2, z_2];
		
		//HALLINGSTAD
		private static const a_3:LetterMap = new LetterMap('a', 0, 'L', 0.0, 1);
		private static const b_3:LetterMap = new LetterMap('b', 3, 'L', 3.5, 2);
		private static const c_3:LetterMap = new LetterMap('c', 2, 'L', 2.0, 2);
		private static const d_3:LetterMap = new LetterMap('d', 2, 'L', 0.0, 1);
		private static const e_3:LetterMap = new LetterMap('e', 2, 'L', 2.0, 0);
		private static const f_3:LetterMap = new LetterMap('f', 3, 'L', 0.0, 1);
		private static const g_3:LetterMap = new LetterMap('g', 3, 'L', 2.0, 1);
		private static const h_3:LetterMap = new LetterMap('h', 6, 'R', 2.0, 1);
		private static const i_3:LetterMap = new LetterMap('i', 7, 'R', 2.0, 0);
		private static const j_3:LetterMap = new LetterMap('j', 6, 'R', 0.0, 1);
		private static const k_3:LetterMap = new LetterMap('k', 7, 'R', 0.0, 1);
		private static const l_3:LetterMap = new LetterMap('l', 8, 'R', 0.0, 1);
		private static const m_3:LetterMap = new LetterMap('m', 6, 'R', 2.0, 2);
		private static const n_3:LetterMap = new LetterMap('n', 6, 'R', 2.0, 2);
		private static const o_3:LetterMap = new LetterMap('o', 8, 'R', 2.0, 0);
		private static const p_3:LetterMap = new LetterMap('p', 9, 'R', 2.0, 0);
		private static const q_3:LetterMap = new LetterMap('q', 0, 'L', 2.0, 0);
		private static const r_3:LetterMap = new LetterMap('r', 3, 'L', 2.0, 0);
		private static const s_3:LetterMap = new LetterMap('s', 1, 'L', 0.0, 1);
		private static const t_3:LetterMap = new LetterMap('t', 3, 'L', 2.5, 0);
		private static const u_3:LetterMap = new LetterMap('u', 6, 'R', 2.0, 0);
		private static const v_3:LetterMap = new LetterMap('v', 3, 'L', 2.0, 2);
		private static const w_3:LetterMap = new LetterMap('w', 1, 'L', 2.0, 0);
		private static const x_3:LetterMap = new LetterMap('x', 1, 'L', 2.0, 2);
		private static const y_3:LetterMap = new LetterMap('y', 6, 'R', 3.0, 0);
		private static const z_3:LetterMap = new LetterMap('z', 0, 'L', 2.0, 2);
		
		public static const maps_3:Vector.<LetterMap> = new <LetterMap>[a_3, b_3, c_3, d_3, e_3, f_3, g_3, h_3, i_3, j_3, k_3, l_3, m_3, n_3, o_3, p_3, q_3, r_3, s_3, t_3, u_3, v_3, w_3, x_3, y_3, z_3];
		
		public static function getMap($letter:String, $mapID:int):LetterMap 
		{
			switch($mapID)
			{
				case QWERTY:
					return maps_0[$letter.charCodeAt(0) - 97];
					break;
				case DVORAK:
					return maps_1[$letter.charCodeAt(0) - 97];
					break;
				case COLEMARK:
					return maps_2[$letter.charCodeAt(0) - 97];
					break;
				case HALLINGSTAD:
					return maps_3[$letter.charCodeAt(0) - 97];
					break;
			}
			
			return null;
		}
		
	}

}