package {
	import flash.geom.Point;
	import flash.display.Shape;
	import fl.motion.Color;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.display.BitmapData;
	import flash.geom.Matrix;

	public class Feed extends Body {

		
		private var color: Number;
		private var _points: Array = new Array();

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
		
			this.cacheAsBitmap = true;
			draw();

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

	}
}