package {
	import flash.display.Sprite;
	import flash.events.*;
	import vk.APIConnection;

	public class FriendsMenu extends Sprite {

		private var friends:Vector.<FriendAvatar> = new Vector.<FriendAvatar>();
		private var panel: Sprite = new Sprite();
		private var inviteBtn: InviteBtn = new InviteBtn();
		private var VK:APIConnection;
		
		public function FriendsMenu(VK:APIConnection, swidth: Number) {
			this.VK = VK;
			addChildAt(panel, 0);
			panel.addChild(inviteBtn);
			inviteBtn.x = 15;
			inviteBtn.addEventListener(MouseEvent.CLICK, function(){VK.callMethod("showInviteBox")});
			lb.x = 0;
			trace(rb.x);
			rb.x = swidth - rb.width;

			lb.addEventListener(MouseEvent.MOUSE_OVER, function() {
				addEventListener(Event.ENTER_FRAME, leftButtonClick);
			});
			rb.addEventListener(MouseEvent.MOUSE_OVER, function() {
				addEventListener(Event.ENTER_FRAME, rightButtonClick);
			});
			lb.addEventListener(MouseEvent.MOUSE_OUT, function() {
				removeEventListener(Event.ENTER_FRAME, leftButtonClick);
			});
			rb.addEventListener(MouseEvent.MOUSE_OUT, function() {
				removeEventListener(Event.ENTER_FRAME, rightButtonClick);
			});
		}

		private function rightButtonClick(e:Event) {
			if(panel.x > -panel.width)
				panel.x -= 10;
		}
		
		private function leftButtonClick(e:Event) {
			if(panel.x < 0)
				panel.x += 10;
		}
		
		public function addFriend(_name: String, imageURL: String) {
			var friend = new FriendAvatar(_name, imageURL);
			friend.x = 15 + (friends.length + 1) * (friend.width + 5);
			//inviteBtn.x += 5 + friend.width
			friends.push(friend);
			panel.addChild(friend);
		}
	}

}