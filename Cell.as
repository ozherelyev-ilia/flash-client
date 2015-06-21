package {
	import flash.geom.Point;
	import flash.display.Sprite;
	import flash.display.Shape;
	import fl.motion.Color;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.display.BitmapData;
	import flash.geom.Matrix;

	public class Cell extends Body {
		
		private var _points: Array = new Array();
		private var color: Number;
		private var _name: CellName;
		private var _mass: CellName;

		public function Cell(_x: Number, _y: Number, size: Number, color: Number = 0x0000FF, _isVir: Boolean = false, nd: Boolean = true, md: Boolean = true) {
			this.x = _x;
			this.y = _y;
			this._size = size;

			this.color = _isVir ? 0x00FF00 : color;

			var _thornCoeff: Number = 1;
			var k = 2 * Math.PI / (2*Math.floor(Math.sqrt(10 * _size)));
			for (var i: Number = 0; i < (2*Math.floor(Math.sqrt(10 * _size))); i++) {
				_thornCoeff = (i % 2) && _isVir ? 0.8 : 1;
				_points.push(new CellPoint(_size * Math.sin(i * k) * _thornCoeff, _size * Math.cos(i * k) * _thornCoeff));
			}
			rounderObject = new Shape();
			bmp = new BitmapData(2 * size, 2 * size, true, 0);
			m.translate(size, size);
			addChild(rounderObject);
			
			if (!_isVir && nd) {
				_name = new CellName(size, String(color));
				if (md){
					var textH:Number = _name.getTH();
					_name.setY(-textH/2 - 2.5)
				}
				addChild(_name);
			}
			
			if (!_isVir && md) {
				_mass = new CellName(size, String(Math.round(size)));
				var textHm:Number = _mass.getTH();
					_mass.setY(textHm/4 + 2.5)
				addChild(_mass);
			}
			
			this.cacheAsBitmap = true;
			draw();

		}

		public function hTest(a: Body): Boolean {
			var fin = true;

			a.bmp.fillRect(bmp.rect, 0);
			a.bmp.draw(a.buf, a.m);
			for (var i: Number = 0; i < _points.length; i++) {
				if (_points[i].size() > 0.4)
					if (a.bmp.hitTest(new Point(a.x - a.size, a.y - a.size), 0xFF, new Point(_points[i].sx() + this.x, _points[i].sy() + this.y))) {
						_points[i].decreaseSize();
						fin = false;
					}
					/*else{
					if(_points[i].size() < 0.99) 
						_points[i].increaseSize();
				}*/
			}
			return fin;
		}

		public function recovery(...cells: Array) {
			var fin = true;
			var l:uint = cells.length;
			for (var c:uint = 0; c < l; c++){
				for each(var a in cells[c]) {
					a.bmp.fillRect(bmp.rect, 0);
					a.bmp.draw(a.buf, a.m);
					for (var i: Number = 0; i < _points.length; i++) {
						if (_points[i].size() < 0.99)
							if (!a.bmp.hitTest(new Point(a.x - a.size, a.y - a.size), 0xFF, new Point(_points[i].ssx(10) + this.x, _points[i].ssy(10) + this.y))) {
								_points[i].increaseSize();
								fin = false;
							}
					}
				}

			}
			return fin;
		}

		public function smooth() {
			for (var i: Number = 0; i < _points.length; i++) {
				_points[i].setSize((_points[(i + _points.length - 1) % _points.length].size() + _points[(i + _points.length - 2) % _points.length].size() + _points[(i + 1) % _points.length].size() + _points[(i + 2) % _points.length].size() + 4 * _points[i].size()) / 8);
			}
		}

		public function draw() {
			drawToBuf();
			rounderObject.graphics.clear();

			rounderObject.graphics.beginFill(color);
			rounderObject.graphics.lineStyle(_size*0.2, color + 0x006600);
			rounderObject.graphics.moveTo(_points[0].sx(), _points[0].sy());

			for (var i: Number = 0; i < (2*Math.floor(Math.sqrt(10 * _size))); i++) {
				rounderObject.graphics.lineTo(_points[i].sx(), _points[i].sy());
			}
		}

		public function drawToBuf() {
			buf.graphics.clear();

			buf.graphics.beginFill(color);
			buf.graphics.lineStyle(10, color + 0x006600);
			buf.graphics.moveTo(_points[0].sx(), _points[0].sy());

			for (var i: Number = 0; i < (2*Math.floor(Math.sqrt(10 * _size))); i++) {
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