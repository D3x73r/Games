package utils.typingeffort
{
	/**
	 * ...
	 * @author Hristo Dimitrov F43841
	 */
	
	public final class Letters 
	{	
		//qwerty
		private static const a0:LetterMap = new LetterMap('a', 0, 'L', 0.0, 2);
		private static const b0:LetterMap = new LetterMap('b', 3, 'L', 3.5, 3);
		private static const c0:LetterMap = new LetterMap('c', 2, 'L', 2.0, 3);
		private static const d0:LetterMap = new LetterMap('d', 2, 'L', 0.0, 2);
		private static const e0:LetterMap = new LetterMap('e', 2, 'L', 2.0, 1);
		private static const f0:LetterMap = new LetterMap('f', 3, 'L', 0.0, 2);
		private static const g0:LetterMap = new LetterMap('g', 3, 'L', 2.0, 2);
		private static const h0:LetterMap = new LetterMap('h', 6, 'R', 2.0, 2);
		private static const i0:LetterMap = new LetterMap('i', 7, 'R', 2.0, 1);
		private static const j0:LetterMap = new LetterMap('j', 6, 'R', 0.0, 2);
		private static const k0:LetterMap = new LetterMap('k', 7, 'R', 0.0, 2);
		private static const l0:LetterMap = new LetterMap('l', 8, 'R', 0.0, 2);
		private static const m0:LetterMap = new LetterMap('m', 6, 'R', 2.0, 3);
		private static const n0:LetterMap = new LetterMap('n', 6, 'R', 2.0, 3);
		private static const o0:LetterMap = new LetterMap('o', 8, 'R', 2.0, 1);
		private static const p0:LetterMap = new LetterMap('p', 9, 'R', 2.0, 1);
		private static const q0:LetterMap = new LetterMap('q', 0, 'L', 2.0, 1);
		private static const r0:LetterMap = new LetterMap('r', 3, 'L', 2.0, 1);
		private static const s0:LetterMap = new LetterMap('s', 1, 'L', 0.0, 2);
		private static const t0:LetterMap = new LetterMap('t', 3, 'L', 2.5, 1);
		private static const u0:LetterMap = new LetterMap('u', 6, 'R', 2.0, 1);
		private static const v0:LetterMap = new LetterMap('v', 3, 'L', 2.0, 3);
		private static const w0:LetterMap = new LetterMap('w', 1, 'L', 2.0, 1);
		private static const x0:LetterMap = new LetterMap('x', 1, 'L', 2.0, 3);
		private static const y0:LetterMap = new LetterMap('y', 6, 'R', 3.0, 1);
		private static const z0:LetterMap = new LetterMap('z', 0, 'L', 2.0, 3);
		
		//dvorak
		private static const a1:LetterMap = new LetterMap('a', 0, 'L', 0.0, 2);
		private static const b1:LetterMap = new LetterMap('b', 6, 'R', 3.5, 3);
		private static const c1:LetterMap = new LetterMap('c', 7, 'R', 2.0, 1);
		private static const d1:LetterMap = new LetterMap('d', 6, 'R', 0.0, 2);
		private static const e1:LetterMap = new LetterMap('e', 2, 'L', 2.0, 2);
		private static const f1:LetterMap = new LetterMap('f', 6, 'R', 0.0, 1);
		private static const g1:LetterMap = new LetterMap('g', 6, 'R', 2.0, 1);
		private static const h1:LetterMap = new LetterMap('h', 6, 'R', 2.0, 2);
		private static const i1:LetterMap = new LetterMap('i', 3, 'L', 2.0, 2);
		private static const j1:LetterMap = new LetterMap('j', 2, 'L', 0.0, 3);
		private static const k1:LetterMap = new LetterMap('k', 3, 'L', 0.0, 3);
		private static const l1:LetterMap = new LetterMap('l', 9, 'R', 0.0, 1);
		private static const m1:LetterMap = new LetterMap('m', 6, 'R', 2.0, 3);
		private static const n1:LetterMap = new LetterMap('n', 8, 'R', 2.0, 2);
		private static const o1:LetterMap = new LetterMap('o', 1, 'L', 2.0, 2);
		private static const p1:LetterMap = new LetterMap('p', 3, 'L', 2.0, 1);
		private static const q1:LetterMap = new LetterMap('q', 1, 'L', 2.0, 3);
		private static const r1:LetterMap = new LetterMap('r', 8, 'R', 2.0, 1);
		private static const s1:LetterMap = new LetterMap('s', 9, 'R', 0.0, 2);
		private static const t1:LetterMap = new LetterMap('t', 7, 'R', 2.5, 2);
		private static const u1:LetterMap = new LetterMap('u', 3, 'L', 2.0, 2);
		private static const v1:LetterMap = new LetterMap('v', 8, 'R', 2.0, 3);
		private static const w1:LetterMap = new LetterMap('w', 7, 'R', 2.0, 3);
		private static const x1:LetterMap = new LetterMap('x', 3, 'L', 2.0, 3);
		private static const y1:LetterMap = new LetterMap('y', 3, 'L', 3.0, 1);
		private static const z1:LetterMap = new LetterMap('z', 9, 'R', 2.0, 3);
		
		//colemak
		private static const a2:LetterMap = new LetterMap('a', 0, 'L', 0.0, 2);
		private static const b2:LetterMap = new LetterMap('b', 3, 'L', 3.5, 3);
		private static const c2:LetterMap = new LetterMap('c', 2, 'L', 2.0, 3);
		private static const d2:LetterMap = new LetterMap('d', 3, 'L', 2.0, 2);
		private static const e2:LetterMap = new LetterMap('e', 7, 'L', 0.0, 2);
		private static const f2:LetterMap = new LetterMap('f', 2, 'L', 2.0, 1);
		private static const g2:LetterMap = new LetterMap('g', 3, 'L', 2.5, 1);
		private static const h2:LetterMap = new LetterMap('h', 6, 'R', 2.0, 2);
		private static const i2:LetterMap = new LetterMap('i', 8, 'R', 0.0, 2);
		private static const j2:LetterMap = new LetterMap('j', 6, 'R', 3.0, 1);
		private static const k2:LetterMap = new LetterMap('k', 6, 'R', 2.0, 3);
		private static const l2:LetterMap = new LetterMap('l', 6, 'R', 2.0, 1);
		private static const m2:LetterMap = new LetterMap('m', 6, 'R', 2.0, 1);
		private static const n2:LetterMap = new LetterMap('n', 6, 'R', 0.0, 2);
		private static const o2:LetterMap = new LetterMap('o', 9, 'R', 0.0, 2);
		private static const p2:LetterMap = new LetterMap('p', 3, 'L', 2.0, 1);
		private static const q2:LetterMap = new LetterMap('q', 0, 'L', 2.0, 1);
		private static const r2:LetterMap = new LetterMap('r', 1, 'L', 0.0, 2);
		private static const s2:LetterMap = new LetterMap('s', 2, 'L', 0.0, 2);
		private static const t2:LetterMap = new LetterMap('t', 3, 'L', 0, 2);
		private static const u2:LetterMap = new LetterMap('u', 7, 'R', 2.0, 1);
		private static const v2:LetterMap = new LetterMap('v', 3, 'L', 2.0, 3);
		private static const w2:LetterMap = new LetterMap('w', 1, 'L', 2.0, 1);
		private static const x2:LetterMap = new LetterMap('x', 1, 'L', 2.0, 3);
		private static const y2:LetterMap = new LetterMap('y', 8, 'R', 2.0, 1);
		private static const z2:LetterMap = new LetterMap('z', 0, 'L', 2.0, 3);
		
		
		public static const MAPS_QWERTY:Vector.<LetterMap> = new <LetterMap>[a0, b0, c0, d0, e0, f0, g0, h0, i0, j0, k0, l0, m0, n0, o0, p0, q0, r0, s0, t0, u0, v0, w0, x0, y0, z0];
		public static const MAPS_DVORAK:Vector.<LetterMap> = new <LetterMap>[a1, b1, c1, d1, e1, f1, g1, h1, i1, j1, k1, l1, m1, n1, o1, p1, q1, r1, s1, t1, u1, v1, w1, x1, y1, z1];
		public static const MAPS_COLEMAK:Vector.<LetterMap> = new <LetterMap>[a2, b2, c2, d2, e2, f2, g2, h2, i2, j2, k2, l2, m2, n2, o2, p2, q2, r2, s2, t2, u2, v2, w2, x2, y2, z2];
		public static const ALL_MAPS:Vector.<Vector.<LetterMap>> = new <Vector.<LetterMap>>[MAPS_QWERTY, MAPS_DVORAK, MAPS_COLEMAK];
	
		public static function getMap($letter:String, $mapId:int):LetterMap { 
			return ALL_MAPS[$mapId][$letter.charCodeAt(0) - 97];
		}
	}

}