package {

	import flash.display.Sprite;
	import flash.display.Shape;


	public class Grid extends Sprite {


		public function Grid() {
			addGrid(900,700,30);
		}

		function addGrid(xM: int, yM: int, size: int): void {
			var lineX: int = (xM / size);
			var lineY: int = (yM / size);
			for(var i: int = 0; i < lineX; i++) {
				var kordX: int = i * size;
				var shape: Shape = new Shape();
				shape.graphics.lineStyle(1, 0xDDDDDD);
				shape.graphics.moveTo(kordX, 0);
				shape.graphics.lineTo(kordX, yM);
				addChild(shape);
			}
			for(var i: int = 0; i < lineY; i++) {
				var kordY: int = i * size;
				var shape: Shape = new Shape();
				shape.graphics.lineStyle(1, 0xDDDDDD);
				shape.graphics.moveTo(0, kordY);
				shape.graphics.lineTo(xM, kordY);
				addChild(shape);
			}
		}
	}

}