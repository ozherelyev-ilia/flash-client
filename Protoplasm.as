package {
	import flash.geom.Point;
	import flash.display.Sprite;
	import flash.display.Shape;
	import fl.motion.Color;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.display.BitmapData;
	import flash.geom.Matrix;

	public class Protoplasm extends Cell{
		private var _size: Number;
		private var _points: Array = new Array();
		private var rounderObject: Shape = null;
		private var color: Number;
		//public var m: Matrix = new Matrix();
		//public var bmp: BitmapData;
		//public var buf: Shape = new Shape();
		private var _name: CellName;

		public function Protoplasm(_x: Number, _y: Number, size: Number, color: Number = 0x0000FF) {
			super(_x, _y, size, color, false, false)
			this.x = _x;
			this.y = _y;
			this._size = size;
			var _thornCoeff: Number = 1;
			var k = 2 * Math.PI / (2*Math.floor(Math.sqrt(10 * _size)));
			for (var i: Number = 0; i < (2*Math.floor(Math.sqrt(10 * _size))); i++) {
				_points.push(new CellPoint(_size * Math.sin(i * k), _size * Math.cos(i * k)));
			}
			rounderObject = new Shape();
			bmp = new BitmapData(2 * size, 2 * size, true, 0);
			m.translate(size, size);
			addChild(rounderObject);
			draw();

		}
	}
}