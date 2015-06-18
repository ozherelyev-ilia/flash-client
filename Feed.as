package {
	import flash.geom.Point;
	import flash.display.Sprite;
	import flash.display.Shape;
	import fl.motion.Color;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.display.BitmapData;
	import flash.geom.Matrix;

	public class Feed extends Sprite {

		private var _size: Number;
		private var _points: Array = new Array();
		private var rounderObject: Shape = null;
		private var color: Number;
		public var m: Matrix = new Matrix();
		public var bmp: BitmapData;
		public var buf: Shape = new Shape();

		public function size() {
			return _size;
		}
		public function Feed(_x: Number, _y: Number, id: int) {
			this.x = _x;
			this.y = _y;
			this._size = 3;
			var size:Number = 3;
			switch(id){
			case 0:
				this.color = 0xFF3333;	
				break;
			case 1:
				this.color = 0x0033FF;
				break;
			case 2:
				this.color = 0xCC00CC;
				break;
			case 3:
				this.color = 0x660066;
				break;
			case 4:
				this.color = 0x0099FF;
				break;
			case 5:
				this.color = 0xCC3333;
				break;
			case 6:
				this.color = 0x996600;
				break;
			case 7:
				this.color = 0x9933CC;
				break;
			case 8:
				this.color = 0x66FF00;
				break;
			case 9:
				this.color = 0xFFFF33;
				break;
		}
			/*var k = 2 * Math.PI / Math.floor(Math.sqrt(20*_size));
			for (var i: Number = 0; i < Math.floor(Math.sqrt(20*_size)); i++) {
				_points.push(new CellPoint(_size * Math.sin(i * k), _size * Math.cos(i * k)));
			}*/
		
			

			rounderObject = new Shape();
			bmp = new BitmapData(2 * size, 2 * size, true, 0);
			m.translate(size, size);

			addChild(rounderObject);
			draw();

		}

		public function smooth() {
			for (var i: Number = 0; i < _points.length; i++) {
				_points[i].setSize((_points[(i + _points.length - 1) % _points.length].size() + _points[(i + _points.length - 2) % _points.length].size() + _points[(i + 1) % _points.length].size() + _points[(i + 2) % _points.length].size() + 4 * _points[i].size()) / 8);
			}
		}

		public function draw() {
			//drawToBuf();
			rounderObject.graphics.clear();

			rounderObject.graphics.beginFill(color);
			rounderObject.graphics.lineStyle(1, color + 0x001100);
			/*rounderObject.graphics.moveTo(_points[0].sx(), _points[0].sy());

			for (var i: Number = 0; i < Math.floor(Math.sqrt(20 * _size)); i++) {
				rounderObject.graphics.lineTo(_points[i].sx(), _points[i].sy());
			}*/
			rounderObject.graphics.drawCircle(0,0,_size);
		}

		public function drawToBuf() {
			buf.graphics.clear();

			buf.graphics.beginFill(color);
			buf.graphics.lineStyle(10, color + 0x006600);
			buf.graphics.moveTo(_points[0].sx(), _points[0].sy());

			for (var i: Number = 0; i < Math.floor(Math.sqrt(20 * _size)); i++) {
				buf.graphics.lineTo(_points[i].sx(), _points[i].sy());
			}
		}

		public function isDragable(): void {
			addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			addEventListener(MouseEvent.MOUSE_UP, mouseReleasedHandler);
		}

		function mouseDownHandler(e: MouseEvent): void {
			this.y += 25;
			startDrag();
		}

		//Эта функция вызывается, когда пользователь отпускает мышь
		function mouseReleasedHandler(e: MouseEvent): void {
			stopDrag();
		}

	}
}