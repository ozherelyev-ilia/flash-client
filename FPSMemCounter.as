// To use the class simply create a instance of it and add it to the stage.
// var MyFPSMemCounter : FPSMemCounter  = new FPSMemCounter ();
// addChild( fpsCounter );
package {
	import flash.display.Stage;
	import flash.system.System;
	import flash.events. *;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.utils.getTimer;

	public class FPSMemCounter extends TextField
	{
		private var fontSize : Number; //the font size for the field
		private var lastUpdate : Number; // the results of getTimer() from the last update
		private var frameCount : Number; //stores the count of frames passed this second
		private var currentTime : Number;
		private static const UPDATE_INTERVAL : Number = 1000; //the interval at which the frame count will be be posted

		public function FPSMemCounter (textColor : Number = 0xFFFFFF, fontSize : Number = 25) : void
		{
			this.textColor = textColor;
			this.fontSize = 12;

			//set the field to autosize from the left
			autoSize = TextFieldAutoSize.LEFT;

			//make the text unselecteable and disable mouse events
			selectable = false;
			mouseEnabled = false;

			addEventListener (Event.ADDED_TO_STAGE, setFPSUpdate);
			addEventListener (Event.REMOVED_FROM_STAGE, clearFPSUpdate);
		}

		//called when the instance is added to a Display Object
		private function setFPSUpdate (event : Event) : void
		{
			addEventListener (Event.ENTER_FRAME, updateFPS);
			frameCount = 0;
			updateText (frameCount);
			lastUpdate = getTimer ();
		}
		//called when the instance is removed from a Display Object
		private function clearFPSUpdate (event : Event) : void
		{
			removeEventListener (Event.ENTER_FRAME, updateFPS);
		}

		//update the frame counter
		private function updateFPS (event : Event) : void
		{
			//get the current time and increment the frame counter
			currentTime = getTimer ();
			frameCount ++;

			//post the frame count if more then a second has passed
			if (currentTime >= lastUpdate + UPDATE_INTERVAL)
			{
				lastUpdate = currentTime;
				updateText (frameCount);
				frameCount = 0;
			}
		}

		//update the display text
		private function updateText (frameNum : Number) : void
		{
			var mem:String = Number( System.totalMemory / 1024 / 1024 ).toFixed( 2 ) + 'Mb';
			htmlText = "<font size='" + fontSize + "'><b>FPS : </b>" + frameNum + " fps</b><b> Memory : </b>"+ mem +"</font>";
		}

	}
}