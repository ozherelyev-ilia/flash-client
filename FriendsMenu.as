package {
	import flash.display.Sprite;

	public class FriendsMenu {

		private var friends: Vector. < FriendAvatar > = new Vector. < FriendAvatar > ();
		private var panel: Sprite = new Sprite();
		public function FriendsMenu() {
			addChild(panel);
			lb.addEventListener(MouseEvent.Click, leftButtonClick);
			rb.addEventListener(MouseEvent.Click, rightButtonClick);
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