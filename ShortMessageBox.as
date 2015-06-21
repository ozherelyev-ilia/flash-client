package  {
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	
	public class ShortMessageBox extends Sprite{

		private var textFields:Vector.<TextField> = new Vector.<TextField>(10,true);
		private var _messages:Vector.<String> = new Vector.<String>(10,true);
		private var _format:TextFormat = new TextFormat();
		
		public function get messages():Vector.<String>{
			return _messages;
		}
		public function ShortMessageBox() {
			_messages[1] = "Привет";
			_messages[2] = "Я тебя съем";
			_messages[3] = "Не ешь меня";
			_messages[4] = "Догони меня";
			_messages[5] = "Кококо";
			_messages[6] = "Трололо";
			_messages[7] = "Поцелуй меня в рибосому";
			_messages[8] = "Боишься?";
			_messages[9] = "Тебе от меня не скрыться!";
			
			_messages[0] = "Отмена";
				
			_format.font = "Verdana";
			_format.color = 0x000000;
			
			for (var i:uint = 0; i < 10; i++){
				textFields[i] = new TextField();
				textFields[i].selectable = false;
				textFields[i].setTextFormat(_format);
				textFields[i].text = String(i) + "." + _messages[i];
				textFields[i].y = (i-1)*textFields[i].textHeight;
				textFields[i].autoSize = TextFieldAutoSize.LEFT;
				addChild(textFields[i]);
			}
			textFields[0].y = textFields.length * textFields[0].textHeight;
				
		}

	}
	
}
