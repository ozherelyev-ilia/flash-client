package {

	import flash.display.Sprite;
	import flash.display.Shape;


	public class Grid extends Sprite {


		public function Grid() {
			graphics.lineStyle(1, 0xDDDDDD);
			addGrid(900,700,45);
		}
		public function drawWithSize(size:Number){
			graphics.clear();
			graphics.lineStyle(1, 0xDDDDDD);
			addGrid(900,700,size);
		}
		function addGrid(xM: int, yM: int, size: Number): void {
			var lineX: int = (xM / size);
			var lineY: int = (yM / size);
			for(var i: int = 0; i < lineX; i++) {
				var kordX: int = i * size;
				graphics.moveTo(kordX, 0);
				graphics.lineTo(kordX, yM);
			}
			for(i = 0; i < lineY; i++) {
				var kordY: int = i * size;
				graphics.moveTo(0, kordY);
				graphics.lineTo(xM, kordY);
			}
		}
	}

}