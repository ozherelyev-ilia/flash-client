package {
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	public class FriendsMenu extends Sprite {

		private var friends: Vector.<FriendAvatar> = new Vector.<FriendAvatar> ();
		private var panel: Sprite = new Sprite();
		public function FriendsMenu() {
			addChild(panel);
			
			lb.x = 0;
			trace(rb.x);
			rb.x = 850 - rb.width;
			lb.addEventListener(MouseEvent.CLICK, leftButtonClick);
			rb.addEventListener(MouseEvent.CLICK, rightButtonClick);
		}

		private function leftButtonClick() {
			if (panel.x > -panel.width)
				panel.x-=10;
		}
		private function rightButtonClick() {
			if (panel.x < 0)
				panel.x+=10;
		}
		public function addFriend(_name: String, imageURL: String) {
			var friend = new FriendAvatar(_name, imageURL);
			friend.x = 15 + friends.length * (friend.width + 5);
			friends.push(friend);
			panel.addChild(friend);
		}
	}

}