

package 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class Menu extends MovieClip 
	{
		// game default settings
		private var showMass:int = 0;
		private var showNick:int = 1;
		private var showSkins:int = 0;
		private var isFFA:int = 1;
		private var themeNo:int = 1;
		private var nickName:String = new String("");
		private var game:Game;
		
		public function getShMass():int {return showMass;}
		public function getShNick():int {return showNick;}
		public function getShSkins():int {return showSkins;}
		public function getIsFFA():int {return isFFA;}
		public function getThemeNo():int {return themeNo;}
		public function getNickName():String {return nickName;}
		public function Menu(_game:Game)  
		{
			super();
			this.stop();
			game = _game;
			startBtn.addEventListener(MouseEvent.CLICK, startBtnHandler); // frame 1 menu
			settingsBtn.addEventListener(MouseEvent.CLICK, settingsBtnHandler); // frame 1 menu
			helpBtn.addEventListener(MouseEvent.CLICK, helpBtnHandler); // frame 1 menu
			recordsBtn.addEventListener(MouseEvent.CLICK, recordsBtnHandler); // frame 1 menu
			
		}

		private function startBtnHandler(e: MouseEvent): void 
		{
			gotoAndStop(2); // start game
			exitBtn2.addEventListener(MouseEvent.CLICK, exitBtnHandler); // frame 2 start
			ffaBtn.addEventListener(MouseEvent.CLICK, ffaBtnHandler); // frame 2 start
			teamsBtn.addEventListener(MouseEvent.CLICK, teamsBtnHandler); // frame 2 start

		}
		
		private function ffaBtnHandler(e: MouseEvent): void 
		{
			isFFA = 1;
			gotoAndStop(4); // help
			exitBtn4.addEventListener(MouseEvent.CLICK, exitBtnHandler); // frame 4
		}
		
		private function teamsBtnHandler(e: MouseEvent): void 
		{
			isFFA = 0;
			gotoAndStop(4); // help
			exitBtn4.addEventListener(MouseEvent.CLICK, exitBtnHandler); // frame 4
		}

		private function settingsBtnHandler(e: MouseEvent): void 
		{
			gotoAndStop(3); // settings
			exitBtn3.addEventListener(MouseEvent.CLICK, exitBtnHandler3); // frame 3
			nickNameFld.maxChars = 16;
			nickNameFld.text = nickName;
			showMassChb.selected = showMass > 0;
			showNickChb.selected = showNick > 0;
			showSkinsChb.selected = showSkins > 0;
			themeNoSelector.value = themeNo;
		}

		private function helpBtnHandler(e: MouseEvent): void 
		{
			gotoAndStop(4); // help
			exitBtn4.addEventListener(MouseEvent.CLICK, exitBtnHandler); // frame 4
			game.goPlay();
			stage.focus = game;
		}

		private function recordsBtnHandler(e: MouseEvent): void 
		{
			gotoAndStop(5); // settings
			exitBtn5.addEventListener(MouseEvent.CLICK, exitBtnHandler); // frame 5
		}

		public function exitBtnHandler(e: MouseEvent): void 
		{
			gotoAndStop(1); // menu
			startBtn.addEventListener(MouseEvent.CLICK, startBtnHandler); // frame 1 menu
			settingsBtn.addEventListener(MouseEvent.CLICK, settingsBtnHandler); // frame 1 menu
			helpBtn.addEventListener(MouseEvent.CLICK, helpBtnHandler); // frame 1 menu
			recordsBtn.addEventListener(MouseEvent.CLICK, recordsBtnHandler); // frame 1 menu
		}
		
		private function exitBtnHandler3(e: MouseEvent): void 
		{
			nickName = nickNameFld.text;
			themeNo = themeNoSelector.value;
			showMass = int(showMassChb.selected);
			showNick = int(showNickChb.selected);
			showSkins = int(showSkinsChb.selected);
			gotoAndStop(1); // menu
			startBtn.addEventListener(MouseEvent.CLICK, startBtnHandler); // frame 1 menu
			settingsBtn.addEventListener(MouseEvent.CLICK, settingsBtnHandler); // frame 1 menu
			helpBtn.addEventListener(MouseEvent.CLICK, helpBtnHandler); // frame 1 menu
			recordsBtn.addEventListener(MouseEvent.CLICK, recordsBtnHandler); // frame 1 menu
		}
		
		public function startNew(): void 
		{
			game.addChild(this);
			gotoAndStop(1); // menu
			startBtn.addEventListener(MouseEvent.CLICK, startBtnHandler); // frame 1 menu
			settingsBtn.addEventListener(MouseEvent.CLICK, settingsBtnHandler); // frame 1 menu
			helpBtn.addEventListener(MouseEvent.CLICK, helpBtnHandler); // frame 1 menu
			recordsBtn.addEventListener(MouseEvent.CLICK, recordsBtnHandler); // frame 1 menu
		}
	}
}

