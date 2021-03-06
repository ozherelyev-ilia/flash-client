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

		private var maxX: Number = 50000;
		private var maxY: Number = 50000;
		protected var _points: Array = new Array();
		protected var pointsCount: uint;
		protected var color: Number;
		protected var _name: CellName;
		private var _mass: CellName;

		private var p1: Point = new Point();
		private var p2: Point = new Point();

		private var pointsAcc: Array = new Array();
		private var tPointsAcc: Array = new Array();

		public function Cell(_x: Number, _y: Number, size: Number, color: Number = 0x0000FF, _isVir: Boolean = false, nd: Boolean = true, md: Boolean = false, nickname: String = "Cell") {
			this.x = _x;
			this.y = _y;
			this._size = size;

			this.color = _isVir ? 0x00FF00 : color;

			var _thornCoeff: Number = 1;
			pointsCount = 2 * Math.floor(Math.sqrt(20 * _size));
			var k: Number = 2 * Math.PI / pointsCount;
			for(var i: uint = 0; i < pointsCount; i++) {
				_thornCoeff = (i % 2) && _isVir ? 0.9 : 1;
				_points.push(new CellPoint(_size * Math.sin(i * k) * _thornCoeff, _size * Math.cos(i * k) * _thornCoeff));
			}
			rounderObject = new Shape();
			bmp = new BitmapData(4 * size, 4 * size, true, 0);
			m.translate(size, size);
			addChild(rounderObject);

			if(nickname == null)
				trace(_isVir);
			if(!_isVir && nd) {
				trace(nickname);
				_name = new CellName(size, nickname);
				if(md) {
					var textH: Number = _name.getTH();
					_name.setY(-textH / 2 - 2.5)
				}
				addChild(_name);
			}

			if(!_isVir && md) {
				_mass = new CellName(size, String(Math.round(size)));
				var textHm: Number = _mass.getTH();
				_mass.setY(textHm / 4 + 2.5)
				addChild(_mass);
			}

			this.cacheAsBitmap = false;
			draw();

		}
		
		public static function hitCells(a: Cell, b: Cell):void{
			//trace("1")
			var aX:Number = a.x;
			var aY:Number = a.y;
			var aSize:Number = a._size;
			
			var bX:Number = b.x;
			var bY:Number = b.y;
			var bSize:Number = b._size;
			
			var dist:Number = Math.sqrt((aX - bX)*(aX - bX) + (aY - bY)*(aY - bY));
			if (dist >= bSize + aSize){
				//return a;
				return;
			}
			bSize *= bSize;
			aSize *= aSize;
			//trace("2")
			var radius:Number;
			var apX:Number;
			var apY:Number;
			//trace("3")
			for (var i:int = 0; i < a._points.length; i += 1){
				//trace("4")
				apX = a._points[i].sx() + aX;
				//trace("4.1")
				apY = a._points[i].sy() + aY;
				//trace("4.2")
				dist = ((apX - bX)*(apX - bX) + (apY - bY)*(apY - bY))/bSize;
				//trace("4.3")
				if (dist > 1){
					continue;
				}
				//trace("5")
				radius = a._points[i].size();
				while((dist < radius*radius) && (dist < 1) && (radius > 0.7)){
					//trace("5")
					a._points[i].decreaseSize(0.05);
					radius -= 0.05;
					apX = a._points[i].sx() + aX;
					apY = a._points[i].sy() + aY;
					dist = ((apX - bX)*(apX - bX) + (apY - bY)*(apY - bY))/bSize;
					
				}
				//trace("6")
			}
			//return a;
		}


		private function checkPoint(cp: CellPoint, a: Cell, _pointsAcc: Array): Boolean {
			if(cp.size() > 0.75) {
				p1.setTo(a.x - a.csize, a.y - a.csize);
				p2.setTo(cp.sx() + x, cp.sy() + y);
				if(a.bmp.hitTest(p1, 0xFF, p2)) {
					cp.decreaseSize(0.01);
					_pointsAcc.push(cp);
					return false;
				}
			}
			/*else {
				cp.setSize(1);
			}*/
			return true;
		}

		private function checkBound(cp: CellPoint, game: Game, _pointsAcc: Array): Boolean {
			if((cp.sx()*1.421 + this.x < game.clb) ||
				(cp.sx()*1.421 + this.x > game.crb) ||
				(cp.sy()*1.421 + this.y < game.ctb) ||
				(cp.sy()*1.421 + this.y > game.cbb)) {
				cp.decreaseSize(0.01);
				_pointsAcc.push(cp);
				return false;
			}
			return true;
		}

		public function hbTest(game: Game) {
			var cX:Number = this.x;
			var cY:Number = this.y;
			var cSize:Number = this._size;

			if (cX + cSize < game.crb && cX - cSize > game.clb && cY - cSize > game.ctb && cY + cSize < game.cbb){
				return;
			}
			//trace("lol2")
			//trace((cX > game.crb || cX < game.clb || cY < game.ctb || cY > game.cbb))
			if (cX > game.crb  || cX < game.clb || cY < game.ctb || cY > game.cbb){
				return;
			}
			//trace("lol1")
			var pX;
			var pY;
			for (var i:int = 0; i < this._points.length; i += 1){
				pX = this._points[i].sx() + cX;
				pY = this._points[i].sy() + cY;
				while((pX > game.crb || pX < game.clb || pY < game.ctb || pY > game.cbb) && (this._points[i].size() > 0.55)){
					//trace("lol")
					this._points[i].decreaseSize(0.05);
					pX = this._points[i].sx() + cX;
					pY = this._points[i].sy() + cY;
				}
			}

		}

		public function hTest(a: Cell): Boolean {
			var fin: Boolean = true;

			a.bmp.fillRect(a.bmp.rect, 0);
			a.bmp.draw(a.buf, a.m);

			if(pointsAcc.length == 0) {
				for(var i: uint = 0; i < pointsCount; i++) {
					var cp: CellPoint = _points[i];
					fin = checkPoint(cp, a, pointsAcc) && fin;
				}
			} else {
				while(pointsAcc.length != 0) {
					cp = pointsAcc.pop();
					fin = checkPoint(cp, a, tPointsAcc) && fin;
				}
				var tArr: Array = pointsAcc;
				pointsAcc = tPointsAcc;
				tPointsAcc = tArr;
			}
			return fin;
		}

		public override function set csize(_size: Number) {
			if(2 * _size > bmp.width) {
				bmp = new BitmapData(4 * _size, 4 * _size, true, 0);
			}
			m.translate(_size - this._size, _size - this._size);
			this._size = _size;
			rounderObject.height = 2*_size;
			rounderObject.width = 2*_size;
			if (_name!= null)
				_name.setSize(_size);
		}

		public function recovery() {
			for(var i: uint = 0; i < pointsCount; i++) {
				_points[i].setSize(1);
				draw();
			}
			/*var fin:Boolean = true;
			var tfin:Boolean = false;
			var l: uint = cells.length;
			for(var i: uint = 0; i < pointsCount; i++) {
				if((_points[i].ssx(10) + this.x > game.clb) &&
					(_points[i].ssx(10) + this.x < game.crb) &&
					(_points[i].ssy(10) + this.y > game.ctb) &&
					(_points[i].ssy(10) + this.y < game.cbb)) {
					if(_points[i].size() < 0.99) {
						for(var c: uint = 0; c < l; c++) {
							for each(var a in cells[c]) {
								a.bmp.fillRect(a.bmp.rect, 0);
								a.bmp.draw(a.buf, a.m);
								if(a.bmp.hitTest(new Point(a.x - a.csize, a.y - a.csize), 0xFF, new Point(_points[i].ssx(10) + this.x, _points[i].ssy(10) + this.y))) {
									tfin = true;
									break;
								}
							}
						}
						if(!tfin) {
							_points[i].increaseSize();
							continue;
						} else {
							fin = tfin;
						}
						tfin = false;
					}
				}
			}
			return fin;
		*/
		}

		public function smooth() {
			for(var i: uint = 0; i < pointsCount; i++) {
				_points[i].setSize((_points[(i + pointsCount - 1) % pointsCount].size() + _points[(i + pointsCount - 2) % pointsCount].size() + _points[(i + 1) % pointsCount].size() + _points[(i + 2) % pointsCount].size() + 4 * _points[i].size()) / 8);
			}
		}

		public function draw() {
			//drawToBuf();
			rounderObject.graphics.clear();
			rounderObject.graphics.beginFill(color);
			rounderObject.graphics.lineStyle(3, color + 0x006600);
			rounderObject.graphics.moveTo(_points[0].sx(), _points[0].sy());

			for(var i: uint = 0; i < pointsCount; i++) {
				rounderObject.graphics.lineTo(_points[i].sx(), _points[i].sy());
			}
		}

		public function drawToBuf() {
			buf.graphics.clear();

			buf.graphics.beginFill(color);
			buf.graphics.lineStyle(3, color + 0x006600);
			buf.graphics.moveTo(_points[0].sx(), _points[0].sy());

			for(var i: uint = 0; i < pointsCount; i++) {
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
