package  {
	
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.display.Shape;
	import flash.geom.ColorTransform;
	
	public class CellChild extends Sprite {

		
		protected var _circle:Shape;
		protected var _externalcircle:Shape;
		public var CellColor:Number;
		
		public function CellChild() {
			super();
			
			_circle = new Shape; // initializing the variable named rectangle
			var myColor = Math.round( Math.random()*0xFFFFFF );
			CellColor = myColor;
			_circle.graphics.beginFill(myColor); // choosing the colour for the fill, here it is red
			_circle.graphics.drawEllipse(-10, -10, 15,15); // (x spacing, y spacing, width, height)
			_circle.graphics.endFill(); // not always needed but I like to put it in to end the fill
			addChild(_circle); // adds the rectangle to the stage				
			
		}
		
		public function SetColor(value:Number):void {
			var trans:ColorTransform = _circle.transform.colorTransform;
			trans.color = uint(value);
			_circle.transform.colorTransform = trans;
		}

	}
	
}
