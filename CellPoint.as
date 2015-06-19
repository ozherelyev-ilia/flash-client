package {
	import flash.geom.Point;

	public class CellPoint extends Point {

		private var _size: Number;
		private var ox: Number;
		private var oy: Number;

		public function CellPoint(_x: Number, _y: Number, _size: Number = 1.0) {
			super(_x, _y);
			this._size = _size;

			var l = Math.sqrt(_x * _x + _y * _y);
			ox = _x / l;
			oy = _y / l;
		}

		public function sx(): Number {
			return super.x * _size;
		}
		public function sy(): Number {
			return super.y * _size;
		}
		public function ssx(n: Number = 18.0): Number {
			return (super.x + n * ox) * _size;
		}
		public function ssy(n: Number = 18.0): Number {
			return (super.y + n * oy) * _size;
		}

		public function size(): Number {
			return _size;
		}

		public function decreaseSize(n: Number = 0.01): void {
			_size -= n;
		}

		public function increaseSize(n: Number = 0.05): void {
			_size += n;
		}

		public function setSize(size: Number): void {
			_size = size;
		}
	}

}