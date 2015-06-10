package  {
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.display.Shape;
	import flash.geom.ColorTransform;
	
	public class Cell extends Sprite {

		protected var _circle:Shape;
		protected var _externalcircle:Shape;
		protected var _nameLabel:TextField;
		protected var _messageLabel: TextField;
		public var CellColor:Number;

		public var CellNumber: int;
		
		public function Cell() 
		{
			super();
			
			_circle = new Shape; // initializing the variable named rectangle
			var myColor = Math.round( Math.random()*0xFFFFFF );
			CellColor = myColor;
			_circle.graphics.beginFill(myColor); // choosing the colour for the fill, here it is red
			_circle.graphics.drawEllipse(-10, -10, 20,20); // (x spacing, y spacing, width, height)
			_circle.graphics.endFill(); // not always needed but I like to put it in to end the fill
			addChild(_circle); // adds the rectangle to the stage				
			
			_nameLabel = new TextField();
			_nameLabel.text = "Player";
			_nameLabel.x = -10;
			_nameLabel.y = -10;
			_nameLabel.scaleX = 0.3;
			_nameLabel.scaleY = 0.3;
			addChild(_nameLabel);
			
			_messageLabel = new TextField();
			//_messageLabel.text = "Player";
			_messageLabel.x = -10;
			_messageLabel.y = 10;
			addChild(_messageLabel);
		}
		
		public function SetSize(radius:Number):void {
			_circle.width = radius*2;
			_circle.height = radius*2;
			//_circle.x = -radius;
			//_circle.y = -radius;
		}
		
		public function SetColor(value:Number):void {
			var trans:ColorTransform = _circle.transform.colorTransform;
			trans.color = uint(value);
			_circle.transform.colorTransform = trans;
		}
		
		public function SetMessage(msg: String): void {
			_messageLabel.text = msg;
		}

	}
	
}
