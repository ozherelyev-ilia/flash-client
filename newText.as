package 
{

	import flash.display.MovieClip;
	import CellName;
	import flash.text.TextField;
    import flash.text.TextFieldAutoSize;
    import flash.display.Sprite;

	public class newText extends MovieClip 
	{
			private var text1: CellName;
		public function newText()
		{
			super();
			text1 = new CellName(300, "ABCDEFG");
			addChild(text1);
			text1.x = 100;
			text1.y = 100;
		}
		
	}

}