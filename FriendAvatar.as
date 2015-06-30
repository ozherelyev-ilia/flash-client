package  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.display.Loader;
	import flash.net.URLRequest;
	import flash.display.Bitmap;
	
	public class FriendAvatar extends MovieClip {
		
		private var loader:Loader;
		public function FriendAvatar(_name:String, imageURL:String) {
			friendName.text = _name;
			loader = new Loader()
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadComplete, false, 0, true);
			loader.load(new URLRequest(imageURL));
		}
		
		private function onLoadComplete(e:Event):void{
			var image:Bitmap = loader.contentLoaderInfo.content as Bitmap;
			image.height = this.height;
			image.width = this.width;
			addChild(image);//добавлять можно в любой контейнер
		}		
	}
	
}
