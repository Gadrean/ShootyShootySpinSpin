package  {
	import flash.events.*;
	import flash.utils.Timer;	
	import flash.display.Stage;
	import flash.ui.Keyboard;
	import flash.net.drm.AddToDeviceGroupSetting;
	
	public class main{
		static const maxHealth:int = 10;
		static const maxAmmo:int = 15;
		static const speed:int=15;
		static var frequency:uint = 1000;
		public static var ammo:int;	
		public static var health:int;
		public static var score:int;
		static var angle:Number;
		static var leftTurn:Boolean;
		static var rightTurn:Boolean;		
		static var shoot:Boolean;
		static var reload:Boolean;
		public static var playGame:Boolean;
		public static var control:Boolean = true; //if true mouse controls if false keyboard controls
		static var waveTimer:Timer = new Timer(frequency);
		static var reloadTimer:Timer = new Timer(400,1);
		public static var enemies:Array = new Array;
		public static var bullets:Array = new Array;
		static var player:Player = new Player();
		static var enemy:Enemy1;
		public static var s; //stage mention
		public static var mainGame;
		public static var playerLayer;
		public static var mainStage:Object; //allows access to timeline 
		
		public static function gameStart(timeline,main,pl){
			s = timeline;
			mainGame = main;
			playerLayer = pl;
			ammo = maxAmmo;
			health = maxHealth;
			shoot = false;
			leftTurn = false;
			rightTurn = false;
			reload = false;
			playGame = true;
			score = 0;
			frequency = 1000;
			player.x = 275;
			player.y = 200;
			player.rotation = 270;
			s.addEventListener(Event.ENTER_FRAME, game); 			// calls start function every frame
			waveTimer.addEventListener(TimerEvent.TIMER, enemySpawn);	// adds a listener to call enemies function whenever waveTimer ends
			reloadTimer.addEventListener(TimerEvent.TIMER, reloading); //calls reloading function when reloadTimer reaches 0	
			playerLayer.addChild(player);
			waveTimer.start();
			if (control){
				s.addEventListener(MouseEvent.MOUSE_MOVE, mMove);
				s.addEventListener(MouseEvent.MOUSE_DOWN, shootTrue);
				s.addEventListener(MouseEvent.MOUSE_UP, shootFalse);
				s.addEventListener(MouseEvent.RIGHT_MOUSE_DOWN, reloadMouse);
			} else {
				s.addEventListener(KeyboardEvent.KEY_DOWN, onKeyPress); // when a key is pressed, call OnKeyPress
				s.addEventListener(KeyboardEvent.KEY_UP, onKeyRelease); // when a key is released, call onKeyRelease
			}
		}
		// onKeyPress: Keeps track of when the RIGHT and LEFT keys are being pressed
		public static function onKeyPress(e:KeyboardEvent):void {
			var key:uint=e.keyCode;
			if (key == 68) {
				rightTurn=true;			
			}else if (key == 65) {
				leftTurn=true;
			}else if (key == 32) {
				shoot=true;
			}else if (key == 87) { //reload
				reload=true;
			}			  
		}

		// onKeyRelease: Keeps track of when the RIGHT and LEFT keys aren't being pressed
		static function onKeyRelease(e:KeyboardEvent):void {
			var key:uint=e.keyCode;			
			if (key == 68) {
				rightTurn=false;			
			}else if (key == 65) {
				leftTurn=false;
			}else if (key == 32) {
				shoot=false;
			} else if (key == 87) { 
				reload=false;
			}	
		}
		static function shootTrue(e:MouseEvent):void{
			shoot = true;
		}
		static function shootFalse(e:MouseEvent):void{
			shoot = false;
		}
		static function reloadMouse(e:MouseEvent):void{
			if (ammo <= 0){
				reloadTimer.start();
			}
		}
		public static function mMove(e:MouseEvent):void{
			var currentX:Number = s.mouseX;
			var currentY:Number = s.mouseY;
			var dx:Number =	currentX - player.x;
			var dy:Number = currentY - player.y;
			angle = Math.atan2(dy, dx) * 180 / Math.PI;
		}
		public static function game(evt:Event):void {
			if (playGame){
				if (control){
					player.rotation = angle;
				}
				if (leftTurn){
					player.rotation -= speed;  
				}
				if (rightTurn){
					player.rotation += speed;  
				}
				if (shoot && ammo > 0){
					var bullet:Bullet = new Bullet(player);
					bullets.push(bullet);
					mainGame.addChild(bullet);
					ammo -= 1;
				}
				if (reload && ammo <=0){
					reloadTimer.start();
				}
				if (health <= 0){
					playGame = false;
				}
			} else { //removes event listeners and instance of player if playgame isnt true
				playerLayer.removeChild(player)
				waveTimer.removeEventListener(TimerEvent.TIMER, enemySpawn);
				reloadTimer.removeEventListener(TimerEvent.TIMER, reloading); 
				s.removeEventListener(Event.ENTER_FRAME, game);
				if (control){
					s.removeEventListener(MouseEvent.MOUSE_MOVE, mMove);
					s.removeEventListener(MouseEvent.CLICK, shootTrue);
					s.removeEventListener(MouseEvent.CLICK, shootFalse);
					s.removeEventListener(MouseEvent.RIGHT_MOUSE_DOWN, reloadMouse);
				}else {
				s.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyPress); 
				s.removeEventListener(KeyboardEvent.KEY_UP, onKeyRelease);
				}
				mainStage.gotoAndStop(2);
				
			}
		}		
		static function enemySpawn(evt:TimerEvent):void { //is called everytime waveTimer ends
			if (playGame){ //if playGame is true
			enemy = new Enemy1(player); 
			enemies.push(enemy); //adds enemy variable to enemies list
			mainGame.addChild(enemy); //adds instance of Enemy1 to stage with instance name enemy
			}
		}
		static function reloading(evt:TimerEvent):void{
			ammo = maxAmmo;
		}
	}
}