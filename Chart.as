package
{
	import flash.display.Sprite;
	import fl.controls.Label;
	import flash.utils.Timer;
    import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	public class Chart extends Sprite
	{
		private var txtArea:TextField = new TextField();
		private var msg:Array = new Array("", "", "", "", "");
		private var timer1:Timer = new Timer(3000,0), 
					timer2:Timer = new Timer(3000,0), 
					timer3:Timer = new Timer(3000,0), 
					timer4:Timer = new Timer(3000,0), 
					timer5:Timer = new Timer(3000,0);
		public var nMsg:int;
		private var allText:String;
		var format1: TextFormat = new TextFormat();
		public function Chart()
		{
			trace("constructor");
			nMsg = 0;
			//this.width = 850;
			//this.height = 100;
			txtArea.x=0;
			txtArea.y=0;
			txtArea.width = 200;
			txtArea.height = 100;
			format1.font = "Verdana";
			format1.underline = false;
			format1.align = "left";
			txtArea.selectable = false;
			txtArea.mouseEnabled = false;
			txtArea.setTextFormat(format1);
			//setMsg('12345678','01234567890123456789012345678901234567890123456789012345','ff0000');
			txtArea.text = "Label";
			//txtArea.htmlText = "";
			addChild(txtArea);
			//var a:int = 1024;
			//trace(a.toString(16))
			
		}
		
		private function _setMsg(_msgText:String)
		{
			switch(nMsg)
			{
				case 0:
					//trace("in 0")
					timer1 = new Timer(3000,1);
					msg[0] = _msgText;
					nMsg += 1;
					timer1.addEventListener("timer", timerHandler);
					timer1.start();
				break;
				case 1:
					timer2 = new Timer(3000,1);
					msg[1] = _msgText;
					nMsg += 1;
					timer2.addEventListener("timer", timerHandler);
					timer2.start();
				break;
				case 2:
					timer3 = new Timer(3000,1);
					msg[2] = _msgText;
					nMsg += 1;
					timer3.addEventListener("timer", timerHandler);
					timer3.start();
				break;
				case 3:
					timer4 = new Timer(3000,1);
					msg[3] = _msgText;
					nMsg += 1;
					timer4.addEventListener("timer", timerHandler);
					timer4.start();
				break;
				case 4:
					timer5 = new Timer(3000,1);
					msg[4] = _msgText;
					nMsg += 1;
					timer5.addEventListener("timer", timerHandler);
					timer5.start();
				break;
				case 5:
					timer1 = timer2;
					timer2 = timer3;
					timer3 = timer4;
					timer4 = timer5;
					timer5 = new Timer(3000,1);
					timer5.addEventListener("timer", timerHandler);
					timer5.start();
					msg[0] = msg[1];
					msg[1] = msg[2];
					msg[2] = msg[3];
					msg[3] = msg[4];
					msg[4] = _msgText;
				break;
			}
			allText = msg[0] + "\n\n" + msg[1] + "\n\n" + 
							  msg[2] + "\n\n" + msg[3] + "\n\n" + 
							  msg[4];
					txtArea.htmlText = allText;
		}
		
		private function timerHandler(e:TimerEvent)
		{
			if (nMsg > 0)
			{
				//trace("in handler")
				timer1 = timer2;
				timer2 = timer3;
				timer3 = timer4;
				timer4 = timer5;
				timer5 = new Timer(3000,1);
				msg[0] = msg[1];
				msg[1] = msg[2];
				msg[2] = msg[3];
				msg[3] = msg[4];
				msg[4] = "";
				nMsg -= 1;
				timer5.addEventListener("timer", timerHandler);
				timer5.start();
				allText = msg[0] + "\n\n" + msg[1] + "\n\n" + 
								  msg[2] + "\n\n" + msg[3] + "\n\n" + 
								  msg[4];
						txtArea.htmlText = allText;
			}
		}
		
		public function setMsg(nickName:String, _msg:String, color:String)
		{
			var textM:String = "<font color=\"#" + color + '">' + nickName + ":</font> " + _msg;
			if (textM.length > 50)
			{
				textM = textM.substr(0,70) + '\n' + textM.substring(70,textM.length-1);
			}
			_setMsg(textM);
		}
	}
}