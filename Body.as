package  {
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	
	public class Body extends Sprite {

		protected var _size: Number;
		protected var rounderObject:Shape = new Shape();
		public var bmp:BitmapData;
		public var m:Matrix = new Matrix();
		public var buf: Shape = new Shape();

		public function size() {
			return _size;
		}
	}
	
}
