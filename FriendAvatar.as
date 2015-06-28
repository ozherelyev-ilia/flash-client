package  {
	
	import flash.display.MovieClip;
	
	
	public class FriendAvatar extends MovieClip {
		
		
		public function FriendAvatar(_name:String, imageURL:String) {
			friendName.text = _name;
			var loader:Loader = new Loader();
			loader.contentLoaderIndo.addEventListener(Event.COMPLETE, onLoadComplete, false, 0, true);
			loader.load(new URLRequest(imageURL));
		}
		
		private function onLoadComplete(e:Event):void{
			var image:Bitmap = loader.contentLoaderIndo.content as Bitmap;
			image.height = this.height;
			image.width = this.width;
			addChild(image);//добавлять можно в любой контейнер
		}		
	}
	
}
