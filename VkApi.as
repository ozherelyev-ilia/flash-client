package  {
	
    import flash.events.*;
    import vk.APIConnection;
    import vk.events.*;
	import flash.display.Sprite;
	import fl.controls.TextArea;
	
	
	public class VkApi extends Sprite {
		
		public var api_id:Number;
        public var viewer_id:Number;
        public var sid:String;
        public var secret:String;
		public var result_tf:TextArea;
		public var frCount:uint;
		public var frMenu;
		private var VK:APIConnection;
		public function VkApi(stage)
        {
			result_tf = new TextArea();
            // получаем flashVars
            var flashVars:Object = stage.loaderInfo.parameters as Object;
            // присваиваем переменным значения из flashVars
            api_id = flashVars['api_id'];
            viewer_id = flashVars['viewer_id'];
            sid = flashVars['sid'];
            secret = flashVars['secret'];
 
            // для тестирования локально, вводим свои данные здесь и раскоменчиваем код
            //flashVars['api_id'] = 4955916;
            //flashVars['viewer_id'] = 3053762;
            //flashVars['sid'] = 'd9772e883d472b3d2be01b783efeb022b02c3e0163eb626c7c3bfb4dfc567f7978b3f14375415aae4a84f';
            //flashVars['secret'] = '0226527c31';
            
 
            // инициализация
            VK = new APIConnection(flashVars);
            // выполняем запрос getProfiles, в качестве параметра uids используем id пользователя, просматривающего приложения, в параметре fields указываем photo_big - большая фотография пользователя
			VK.api('friends.getAppUsers', {}, friendsLoaded, onError);
			//VK.api('getProfiles', { uids: flashVars['viewer_id'],fields:'photo_big' }, onProfileLoaded, onError);	
			frMenu = new FriendsMenu(VK, stage.stageWidth);
			//addChild(result_tf);
			addChild(frMenu);
			//result_tf.width = stage.stageWidth;
			//result_tf.y = stage.stageHeight/2;
        }
 
        // данные получены
        private function onProfileLoaded(data: Object):void
        {
            // обрабатываем полученный ответ
            //result_tf.text = data[0]['uid'] + ' ' + data[0]['first_name'] + ' ' + data[0]['last_name'] + ' ' + data[0]['photo_big'];
			for (var i:int = 0; i < data.length; ++i)
				frMenu.addFriend(data[i].first_name, data[i].photo_100.replace(/\\/,""));
		}
 
        // если произошла ошибка
        private function onError(data: Object):void
        {
            result_tf.text = data.error_msg;
        }
		
		 private function friendsLoaded(data: Object):void
        {
            // обрабатываем полученный ответ
            frCount = data.length;// узнаем количество друзей
            // выводим количество друзей в поле result_tf
            result_tf.appendText('\nКоличество друзей: ' + frCount + "\n");
 
            // выводим список друзей в поле result_tf
			var frList:String = new String();
            for (var i=0; i<frCount; i++)
            {
                //result_tf.appendText(data[i].uid + ' ' + data[i].first_name + ' ' + data[i].last_name + ' ' + data[i].photo_50 +"\n");
				//frMenu.addFriend(data[i].first_name, data[i].photo_50);
				frList = frList + data[i] + ',';
			}
			frList = frList.substr(0,frList.length-1);
			VK.api('getProfiles', { uids: frList,fields:'first_name,last_name,photo_100' }, onProfileLoaded, onError);	
        }
 
	}
	
}
