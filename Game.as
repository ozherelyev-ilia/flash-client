﻿package {
	import playerio.*;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.display.Shape;
	import flash.events.MouseEvent;
	import flash.utils.setInterval;
	import flash.display.Shader;
	import flash.geom.Point;
	import flash.geom.Matrix;
	import flash.display.StageScaleMode;
	import flash.geom.Rectangle;
	import flash.events.KeyboardEvent;
	import flash.utils.getTimer;
	import flash.utils.Timer;

	public class Game extends Sprite {
		//---------------------------------------
		// PUBLIC VARIABLES
		//---------------------------------------
		public var gameID: String = "cells-3ikqgf3ioke4whklsuqwqa";
		public var userID: String;
		public var connection: Connection;
		//---------------------------------------
		// PRIVATE VARIABLES
		//---------------------------------------
		private var _background: Sprite; // Спрайт для фона (пока не используется)
		private var _display: Sprite; // Спрайт для клеток игроков и вирусов
		private var _enviroment: Sprite; // Спрайт для кормовых точек
		//private var _circle: Shape;
		//private var _cell:Cell;

		//private var _players: Vector.<String> = new Vector.<String>(); //Список игроков
		private var currentPlayer: Player;
		private var players: Vector.<Player> = new Vector.<Player> ();
		private var _cells: Vector.<Cell> = new Vector.<Cell> (); // Список клеток всех игроков
		private var _throws: Vector.<CellChild> = new Vector.<CellChild> (); // Список отщепленных кормовых частиц с клетки
		private var _viruses: Vector.<VirusCell> = new Vector.<VirusCell> (); // Список вирусов
		private var _feed: Vector.<Vector.<Feed>> = new Vector.<Vector.<Feed>> ();
		private var _feedPtr: Vector.<int> = new Vector.<int> ();
		private var renderedCells:Object = new Object();
		private var waitingCells:Object = new Object();
		
		private var isMouseDown: Boolean = false;
		private var messageString: String = "";

		private var avgPing: Number = 0;
		private var rcntUpdt: Number = 0;
		private var messages:Vector.<Message> = new Vector.<Message>();
		private var wtime:int = 0;
		
		private var lastX:Number = 0;
		private var lastY:Number = 0;
		private var xArea:int = 274;
		private var yArea:int = 214;
		
		private var fsu:int = 0;
		//---------------------------------------
		// CONSTRUCTOR
		//---------------------------------------

		/**
		 * @constructor
		 */
		public function Game() {
			super();

			if (stage == null) {
				trace("null");
			} else {
				trace(stage.name);
			}
			(stage == null) ? addEventListener(Event.ADDED_TO_STAGE, init) : init(null);
			stage.addEventListener(MouseEvent.CLICK, mclick);
			//stage.addEventListener(MouseEvent., msclick);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, buttonPressed);
			stage.addEventListener(MouseEvent.MOUSE_UP, buttonReleased);

			stage.addEventListener(KeyboardEvent.KEY_DOWN, displayKeyDown);
		}

		function mclick(e: MouseEvent) {

			//trace(_players);
			/*
			var l:int = _viruses.length;
			
			for ( var i:int = 0; i < l; i++ ) 
			{ 
				_viruses[i].SetSize(40);
			}
			*/
		}

		function buttonPressed(event: MouseEvent) {
			isMouseDown = true;
		}

		function buttonReleased(event: MouseEvent) {
			isMouseDown = false;

			if (messageString != "" || messageString != " ") {
				trace(messageString);
				connection.send("playerSaying", messageString);
				messageString = "";
			}
		}

		function displayKeyDown(e: KeyboardEvent) {

			if (!isMouseDown) {
				if (connection != null) {
					if (e.keyCode == 32) connection.send("split"); //отправка на сервер сообщения о нажатии пробела
					if (e.keyCode == 87) connection.send("throwpart", _display.mouseX, _display.mouseY); // отправка на сервер сообщения о нажатии на "w"
				}
			} else {
				if (messageString.length < 50) messageString += String.fromCharCode(e.charCode);
			}

		}

		private function init(event: Event): void {
			if (event != null) {
				removeEventListener(Event.ADDED_TO_STAGE, init);
			}

			for (var i: int = 0; i < 10; i++) {
				_feed[i] = new Vector.<Feed>();
				_feedPtr[i] = 0;
			}

			_enviroment = new Sprite(); // Спрайт для кормовых точек
			addChild(_enviroment);
			_display = new Sprite(); // Спрайт для клеток игроков и вирусов
			addChild(_display);
			_background = new Sprite(); // Спрайт для фона (пока не используется) 
			addChild(_background);

			userID = "User" + Math.floor(Math.random() * 1000).toString(); //генерация Айди для текущего игрока
			// TODO предусмотреть чтобы он не повторялся с другими игроками

			// соединение с сервером
			// gameID - идентификатор хостинг-сервера. Не трогать
			// userID - ID текущего игрока, запустившего данное приложение 
			// handleConnect - обработчик успешного соединения с сервером
			// handleError - обработчик ошибки соединения
			PlayerIO.connect(stage, gameID, "public", userID, "", null, handleConnect, handleError);
		}

		/**
		 * @private
		 */
		// При успешном соединении:
		private function handleConnect(client: Client): void {
			trace("Connected to server!");

			// Устанавливаем подключение к локальному серверу для отладки
			//client.multiplayer.developmentServer = "localhost:8184"; //Если закомментить эту строчку, то будет подключение на удаленный сервер

			// Создаем или подключаемся к игровой комнате "test"
			client.multiplayer.createJoinRoom(
				"test", // Идентификатор комнаты. Если устаноить null то идентификатор будет присвоен случайный
				"MyCode", // Тип игры запускаемый на сервере (привязка к серверному коду)
				true, // Должна ли конмата видима в списке комнат? (client.multiplayer.listRooms)
				{}, // Какие-либо данные. Эти данные будут возвращены в список комнат. Значения могут быть изменены на сервере.
				{}, // Какие-либо данные пользователя.
				handleJoin, // Указатель на метод который будет вызван при успешном подключении к комнате.
				handleError // Указатель на метод который будет вызван в случаее ошибки подключения
			);

			// создаем новую клетку
			//var cell = new Cell();
			//cell.x = _display.width / 2;
			//cell.y = _display.height / 2;
			//_cells.push(cell);


		}

		// отправка на сервер сообщения с текущими координатами мыши
		// срабатывает как ответ на запрос "mouseRequest" с сервера, который поступает каждые 30 мс
		function sendMouseXY(m: Message) {
			if (connection != null) {
				connection.send("currentMouse", lastX+(_display.mouseX-360)/640*xArea, lastY+(_display.mouseY-180)/360*yArea);
			}
			//trace("mouse");

		}

		/**
		 * @private
		 */
		private function handleJoin(connection: Connection): void {

			if (connection != null) this.connection = connection;

			/*connection.addMessageHandler("eatenPoints", gotEatenPoints); // Добавление обработчика сообщения о съеденных точках кормежки
			connection.addMessageHandler("eatenThrows", gotEatenThrows); // Добавление обработчика сообщения о съеденных отщепенцев клеток
			connection.addMessageHandler("updateNutrits", gotNuts); // Добавление обработчика сообщения с новыми точками кормежки
			connection.addMessageHandler("score", gotScore); // Добавление обработчика сообщения текущего счёта игрока
			connection.addMessageHandler("newPlayer", newPlayerJoined); // Добавление обработчика сообщения о присоединении нового игрока
			connection.addMessageHandler("playerLeft", playerLeft); // Добавление обработчика сообщения о уходе какого-либо игрока
			*/
			connection.addMessageHandler("mouseRequest", sendMouseXY); // Добавление обработчика сообщения-запроса текущих координат мыши

			connection.addMessageHandler("currentState", update);
			//this.connection.addMessageHandler("*", messageHandler); // Добавление обработчика прочих сообщений

			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}

		private function onEnterFrame(e: Event) {
			if(fsu!=0){
				while (fsu > 5){
					fsu--;
					messages.shift();
				}
				var msg:Message = messages.shift();
				fsu--;
				drawWorld(msg);
			}
			addChild(ping);
			ping.text = String(fsu);
		}
		
		private function drawWorld(m:Message){
			this.removeChildren();
			xArea = m.getInt(2);
			yArea = m.getInt(3);
			var curX: Number = m.getNumber(0);
			var curY: Number = m.getNumber(1);
			lastX = curX;
			lastY = curY;
			for (var i: int = 0; i < 10; i++) {
				_feedPtr[i] = 0;
			}

			for (i = 0; i < m.length; i += 4) {
				var id = m.getInt(i);
				var _x = (m.getNumber(i + 1)-curX + xArea/2)/xArea*640;
				var _y = (m.getNumber(i + 2)-curY + yArea/2)/yArea*360;
				var size = 3*m.getNumber(i + 3);
				if (id < 10) {
					var feed: Feed;
					if (_feedPtr[id] == _feed[id].length) {
						feed = new Feed(_x, _y, id);
						_feed[id].push(feed);
					} else {
						feed = _feed[id][_feedPtr[id]];
						feed.x = _x;
						feed.y = _y;
					}
					addChildAt(feed, 0);
					_feedPtr[id] += 1;
				} else if (id == 13) {
					var virus: Cell = new Cell(_x, _y, size, 0x00FF00, true);
					addChild(virus);
				} else if (id > 1000) {
					var cell:Cell = waitingCells[String(id)]
					if (cell == undefined){
					 cell = new Cell(_x,
						_y,
						size,
						id);
					} else {
						cell.x = _x;
						cell.y = _y;
						//cell.height = size*2;
						//cell.width = size*2;
					}
					renderedCells[String(id)] = cell;
					this.addChild(cell);
				}
			}
			waitingCells = renderedCells;
			renderedCells = new Object();
		}
		//В сообщении передается массив в котором последовательно идут: 1) айди объекта, 2) X, 3) Y, 4) радиус, далее айди следующего объекта и т.д. 
		//Айди следующие: 
		//0-9 - корм
		//11 - частица клетки
		//13 - вирус
		//Всё что от 1001 и более - клетка (1000 + номер игрока, это чтобы различать игроков)
		private function update(m: Message): void {
			messages.push(m);
			fsu++;
			/*
			
			if (m != null) {
				
			}
			rcntUpdt = getTimer();
			m = lastM;
			lastM = m;*/
		}

		// присоединение нового игрока
		private function newPlayerJoined(m: Message) {
			// в сообщение ID присоединившегося игрока
			//_players.push(m.getString(0));
			var player = new Player(m.getString(0));
			//players.push(player);
			if (m.getString(0) == userID) {
				currentPlayer = player;
			} else {
				players.push(player);
			}

			_display.addChild(player.Cells[0]);
		}

		// уход одного из игроков
		private function playerLeft(m: Message) {
			// в сообщение ID ушедшего игрока

			var player = findPlayerById(m.getString(0));

			if (player != null) {
				var ind: int = players.indexOf(player);
				if (ind != -1) players.splice(ind, 1);
			}

		}

		// функция удаления объектов со спрайтов по имени
		function removeChildWithRef(childName: String, parentObj: * ) {
			var t = parentObj.getChildByName(childName);
			if (t == null) {
				trace("??");
				return;
			}
			parentObj.removeChild(t);
			t = null;
		}

		function findThrowByName(throwName: String): CellChild {
			var curThrow = _display.getChildByName(throwName);
			return curThrow;
		}

		function findPlayerById(playerId: String): Player {
			var index: int = -1;
			for (var i: uint = 0; i < players.length; i++) {
				if (players[i].Id == playerId) {
					index = i;
					return players[i];
				}
			}
			return null;
		}

		function findVirusByName(virusName: String): VirusCell {
			var virus = _enviroment.getChildByName(virusName);
			return virus;
		}

		// получение с сервера новых точек кормежки
		private function gotNuts(m: Message) {
			// в сообщение массив элементов, в которых последовательно идут: 
			// 1) X-координата точки кормежки
			// 2) Y-координата точки кормежки
			// 3) Id точки кормежки
			// и далее по новой для следующей точки
			trace("pointGot", m.length);

			var i: int;
			for (i = 0; i < (m.length); i += 3) {
				var pointx = m.getInt(i);
				var pointy = m.getInt(i + 1);
				var pointid = m.getString(i + 2);

				var nutriPoint = new Shape();
				var myColor = Math.round(Math.random() * 0xFFFFFF);
				nutriPoint.graphics.beginFill(myColor);
				nutriPoint.graphics.drawRect(pointx - 1, pointy - 1, 2, 2);
				//nutriPoint.graphics.drawEllipse(pointx, pointy, 2, 2);
				nutriPoint.graphics.endFill();
				nutriPoint.name = pointid;
				//trace("name is: ", nutriPoint.name);
				_enviroment.addChild(nutriPoint);
			}

			//trace(m);
		}


		private var _r: Number;
		// в сообщении 1) счёт игрока 2) номер текущей его клетки 3) радиус этой клетки
		private function gotScore(m: Message) {
			//
			var index = m.getInt(1);
			_r = m.getNumber(2);
			//currentPlayer.Cells[index].SetSize(_r);
		}

		// получение съеденной точки
		private function gotEatenPoints(m: Message) {
			// в сообщении id съеденной точки
			trace("pointEaten", m.getString(0));
			// находим точку по айди и удаляем
			removeChildWithRef(m.getString(0), _enviroment);
		}

		// получение съеденных отщепленных частей клетки
		private function gotEatenThrows(m: Message) {
			// в сообщении айди отщепенца
			trace("throwEaten");
			// находим его по названию и удаляем
			removeChildWithRef("throw" + m.getString(0), _display);
		}


		private function messageHandler(m: Message) {
			// получение позиции клетки в текущий момент времени
			if (m.type == "ncellposition") {
				// в сообщении 1) айди игрока 2) номер текущей клетки 3) X-позиция этой клетки 4) Y-позиция этой клетки

				// если это твой айди, то
				if (m.getString(0) == userID) {

					// коэффициент масштабирования
					// он должен быть не постоянным, а зависеть от размера клетки/клеток игрока - чем больше, тем меньше коэффициэнт
					var sclK: int = 3;

					for (var i: int = 0; i < m.length; i += 4) {

						var index = m.getInt(i + 1);
						var xx = m.getNumber(i + 2);
						var yy = m.getNumber(i + 3);

						var curCell: Cell = currentPlayer.FindCellByNumber(index);

						if (curCell != null) {
							curCell.x = xx;
							curCell.y = yy;
						}

						//currentPlayer.Cells[index].x = xx;
						//currentPlayer.Cells[index].y = yy;
						//_cells[index].x = xx;
						//_cells[index].y = yy;
					}

					// масштабирование сего безобразия
					var mat: Matrix = new Matrix();
					mat.translate(-currentPlayer.Cells[0].x + stage.stageWidth / (2 * sclK), -currentPlayer.Cells[0].y + stage.stageHeight / (2 * sclK));
					mat.scale(sclK, sclK);
					//mat.translate(_cell.x,_cell.y);
					_enviroment.transform.matrix = mat;
					_display.transform.matrix = mat;
					_background.transform.matrix = mat;

				} else {
					//trace(m.getString(0));
					//trace(players[0].Id, currentPlayer.Id);
					var otherplayer = findPlayerById(m.getString(0));
					if (otherplayer == null) {
						trace("PLAYER IS NOT DETECTED");
						return;
					}
					for (var i: int = 0; i < m.length; i += 4) {

						var index = m.getInt(i + 1);
						var xx = m.getNumber(i + 2);
						var yy = m.getNumber(i + 3);

						var curCell: Cell = otherplayer.FindCellByNumber(index);
						if (curCell != null) {
							curCell.x = xx;
							curCell.y = yy;
						}

						/*otherplayer.Cells[index].x = xx;
						otherplayer.Cells[index].y = yy;*/
						//_cells[index].x = xx;
						//_cells[index].y = yy;
					}
				}

			}

			// получение позиции всех отщепенцев в текущий момент времени
			if (m.type == "childMove") {

				for (var i: int = 0; i < m.length; i += 3) {

					var index = m.getString(i);
					var xx = m.getNumber(i + 1);
					var yy = m.getNumber(i + 2);

					var curthrow = findThrowByName("throw" + index);
					curthrow.x = xx;
					curthrow.y = yy;
					/*_throws[index-1].x = xx;
					_throws[index-1].y = yy;*/
				}

			}

			// обработчик события появления новой клетки у игрока (т.е. либо он нажал пробел, либо столкнулся с вирусом)
			if (m.type == "newCell") {

				/*if (m.getString(0) == userID) {
					//var newcell: Cell = new Cell();
					newcell.CellNumber = m.getInt(1);
					currentPlayer.AddCell(newcell);
					newcell.SetColor(currentPlayer.Cells[0].CellColor);
					//_cells.push(newcell);
					_display.addChild(newcell);
					trace(m);
				} else {
					var otherPlayer: Player = findPlayerById(m.getString(0));
					var newcell: Cell = new Cell();
					newcell.CellNumber = m.getInt(1);
					otherPlayer.AddCell(newcell);
					newcell.SetColor(otherPlayer.Cells[0].CellColor);
					_display.addChild(newcell);
				}*/

			}

			// обработчик события появления нового отщепенца, т.е. когда игрок нажал на "w"
			/*if (m.type == "newThrow") {

				var curPlayer: Player;
				if (m.getString(0) == userID) {
					curPlayer = currentPlayer;
				} else {
					curPlayer = findPlayerById(m.getString(0));
				}

				if (curPlayer == null) return;

				var newthrow: CellChild = new CellChild();
				newthrow.x = curPlayer.Cells[0].x;
				newthrow.y = curPlayer.Cells[0].y;
				newthrow.SetColor(curPlayer.Cells[0].CellColor);
				newthrow.name = "throw" + m.getString(1);
				_display.addChild(newthrow);
				_throws.push(newthrow);

			}
*/
			// появление нового вируса
			if (m.type == "updateViruses") {

				for (var i: int = 0; i < m.length; i += 4) {

					var index = m.getString(i);
					var xx = m.getNumber(i + 1);
					var yy = m.getNumber(i + 2);
					var virrad = m.getNumber(i + 3);

					var virus = new VirusCell();
					virus.x = xx;
					virus.y = yy;
					virus.name = "virus" + index;
					virus.SetSize(virrad);
					_enviroment.addChild(virus);
					_viruses.push(virus);

					//trace(virus.x, virus.y, virus.name);

				}
			}

			// удаление вируса
			if (m.type == "removeVirus") {
				removeChildWithRef("virus" + m.getString(0), _enviroment);
			}

			// изменить размер вируса
			if (m.type == "resizeVirus") {
				var virus = findVirusByName("virus" + m.getString(0));
				virus.SetSize(m.getInt(1));
			}

			/*	//получить всех игроков комнаты
			if (m.type == "playersList") {
				for (var i: int = 0; i < m.length; i++) {
					var newPlayer = new Player(m.getString(i));
					var celNum: uint = m.getNumber(i + 1);
					for (var j: uint = 0; j < 2 * celNum; j++) {
						if (j != 0) newPlayer.AddCell(new Cell());
						newPlayer.Cells[j].SetColor(newPlayer.Cells[0].CellColor);
						newPlayer.Cells[j].CellNumber = (m.getNumber(i + 2 + j));
						newPlayer.Cells[j].SetSize(m.getNumber(i + 3 + j));
						_display.addChild(newPlayer.Cells[j]);
					}
					i = i + 1 + 2 * celNum;
					if (newPlayer.Id != userID) players.push(newPlayer);
				}
				trace("playerList");
			}
*/
			if (m.type == "removeCell") {
				var cplayer: Player;

				if (m.getString(0) != userID) {
					cplayer = findPlayerById(m.getString(0));
				} else {
					cplayer = currentPlayer;
				}

				//trace(cplayer.Cells[1].CellNumber, cplayer.Cells[2].CellNumber, cplayer.Cells[3].CellNumber, "<-----");
				if (cplayer != null) {
					var cellForRemove = cplayer.FindCellByNumber(m.getInt(1));
					//trace(m.getInt(1), "<<----", cellForRemove);
					if (cellForRemove != null) _display.removeChild(cellForRemove);
				}
			}

			if (m.type == "resizeCell") {
				var cplayer: Player;
				if (m.getString(0) != userID) {
					cplayer = findPlayerById(m.getString(0));
				} else {
					cplayer = currentPlayer;
				}
				if (cplayer != null) {
					var cellForResize = cplayer.FindCellByNumber(m.getInt(1));
					if (cellForResize != null) cellForResize.SetSize(m.getNumber(2));
				}
			}

			// получение позиции данного вируса в текущий момент
			if (m.type == "virusMove") {

				var index = m.getString(0);
				var xx = m.getNumber(1);
				var yy = m.getNumber(2);

				var curVirus = findVirusByName("virus" + index);

				if (curVirus != null) {
					curVirus.x = xx;
					curVirus.y = yy;
				}

			}
			/*
			if (m.type == "saying") {
				var cplayer: Player;
				if (m.getString(0) != userID) {
					cplayer = findPlayerById(m.getString(0));
				} else {
					cplayer = currentPlayer;
				}
				if (cplayer != null) {
					cplayer.Cells[0].SetMessage(m.getString(1));

					if (cplayer.MessageTimer.running) {
						cplayer.MessageTimer.reset();
					} else {
						cplayer.MessageTimer.start();
					}

				}
			}*/
		}



		/**
		 * @private
		 */
		private function handleError(error: PlayerIOError): void {

		}

	}

}