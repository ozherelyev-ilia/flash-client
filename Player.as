package  {
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	
	public class Player {

		public var Id: String;
		public var Cells: Vector.<Cell> = new Vector.<Cell> (); // Список клеток игрока
		public var MessageTimer: Timer = new Timer(5000,1);
		
		public function Player(playerId: String) {
			
			super();
			var cell = new Cell();
			cell.CellNumber = 0;
			AddCell(cell);
			Id = playerId;
			
			MessageTimer.addEventListener(TimerEvent.TIMER, timerHandler);
			MessageTimer.addEventListener(TimerEvent.TIMER_COMPLETE, completeHandler);
			
		}
		
		public function AddCell(cell:Cell):void {
			Cells.push(cell);
		}
		
		public function FindCellByNumber(num: int): Cell {
			for (var i: uint = 0; i < Cells.length; i++) {
				if (Cells[i].CellNumber == num) return Cells[i];
			}
			return null;
		}
		
		private function timerHandler(e:TimerEvent):void{
            
        }

        private function completeHandler(e:TimerEvent):void {
            Cells[0].SetMessage("");
        }
		
	}
	
}
