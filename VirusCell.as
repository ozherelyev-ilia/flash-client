package  {
	
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.display.Shape;
	import flash.geom.ColorTransform;	
	
	public class VirusCell extends Sprite {

		protected var _star:Shape;
		protected var _nameLabel;
		public var CellColor:Number;
		public var IdNumber: int;
		
		public function VirusCell() {
			// constructor code
			super();
			
			_star = new Shape;
			//_star.graphics.lineStyle(3,0x0000FF);
			_star.graphics.beginFill(0x00FF00);
			_star.graphics.moveTo(-10,0);
			var angleIncrement = Math.PI / 15;//5 pointed star -> 10 point arround the circle (360 degrees or Math.PI * 2): 5 outer points, 5 inner points
			var ninety:Number = Math.PI * .5;//offset the rotation by 90 degrees so the star points up
			var _radius:int = 10;

			for(var i:int = 0; i <= 30; i++){//for each point
				var radius:Number = (i % 2 > 0 ? _radius : _radius * .8);//determine if the point is inner (half radius) or outer(full radius)
				var px:Number = Math.cos(ninety + angleIncrement * i) * radius;//compute x
				var py:Number = Math.sin(ninety + angleIncrement * i) * radius;//and y using polar to cartesian coordinate conversion
				if(i == 0) _star.graphics.moveTo(px,py);//move the 'pen' so we don't draw lines from (0,0)
				_star.graphics.lineTo(px,py);//draw each point of the star
			}
			_star.graphics.endFill();
			addChild(_star);
		}
		
		public function SetSize(radius:Number):void {
			this.height = radius*2;
			this.width = radius*2;
		}
		
	}
	
}
