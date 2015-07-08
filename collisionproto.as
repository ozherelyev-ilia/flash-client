package {

	import flash.display.MovieClip;
	import Cell;
	import Feed;
	import flash.events.Event;


	public class collisionproto extends MovieClip {

		private var first: Cell, second: Cell, f1: Feed;

		public function collisionproto() {
			trace("kokoko");

			first = new Cell(100, 200, 150);
			second = new Cell(250, 200, 50, 0xFF0000, true);
			f1 = new Feed(10, 10, 0);
			stage.addChild(first);
			stage.addChild(second);
			stage.addChild(f1);
			this.addEventListener(Event.ENTER_FRAME, hitTest);
			first.isDragable();
		}

		private function hitTest(e: Event): void {
			first.recovery();
			second.recovery();
			do {
				var ahtb: Boolean = first.hTest(second);
				var bhta: Boolean = second.hTest(first);
			} while (!(ahtb && bhta));
			first.smooth();
			second.smooth();
			first.draw();
			second.draw();
		}
	}

}