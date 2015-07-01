package  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.display.Loader;
	import flash.net.URLRequest;
	import flash.display.Bitmap;
	import flash.text.TextField;
	import flash.system.LoaderContext;
	
	public class FriendAvatar extends MovieClip {
		
		private var loader:Loader;
		public function FriendAvatar(_name:String, imageURL:String) {
			friendName.text = _name;
			var loaderContext:LoaderContext = new LoaderContext();
            loaderContext.checkPolicyFile = true;
			loader = new Loader()
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadComplete, false, 0, true);
			loader.load(new URLRequest(imageURL), loaderContext);
		}
		
		private function onLoadComplete(e:Event):void{
			var complete = new TextField();
			complete.text = loader.contentLoaderInfo.contentType;
			addChild(complete);
			var image:Bitmap = loader.contentLoaderInfo.content as Bitmap;
			image.height = this.height;
			image.width = this.width;
			addChildAt(image,1);//добавлять можно в любой контейнер
		}		
	}
	
}
