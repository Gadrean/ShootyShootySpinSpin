package  {
	
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.utils.Timer;
	
	public class Enemy1 extends MovieClip {
		private static const enemyMH:int = 3; // enemy max health
		private var speed:int=4; //enemy speed
		private var random:int = Math.random() * 4;//used for deciding were to create enemies
		private const damage:uint = 1;// damage this enemy does
		private var dTimer:Timer = new Timer(1000);//damage timer how long to wiat before damaging the player
		private var target;//used to keep track of player
		private var onStage:Boolean; //used to keep make sure the enemy exists/hasnt been removed from stage
		public var eHealth:int; // enemy health variable
		
		public function Enemy1(target) {
			this.target = target;
			this.addEventListener(Event.ENTER_FRAME, move)
			this.addEventListener(Event.ENTER_FRAME, hitTest)
			dTimer.addEventListener(TimerEvent.TIMER, enemyHit)
			
			onStage = true; //the enemy exists/is on stage
			eHealth = enemyMH; //sets this enemies healht to the enemy max health variable
			
			if (random < 1) {
				spawnEnemy(Math.random()*550,-11);
			}else if (random < 2){
				spawnEnemy(Math.random()*550,411);
			}else if (random < 3){
				spawnEnemy(-11,Math.random()*400);
			}else if (random < 4){
				spawnEnemy(561,Math.random()*400);
			}
		}
		private function spawnEnemy(xPos:int, yPos:int){
			this.x = xPos;
			this.y	= yPos;
		}
		public function move(e:Event){
			if (!this.hitTestObject(target)){
			if (this.x>target.x){ this.x -= speed; } 
			if (this.x<target.x){ this.x += speed; } 
			else {this.x = this.x;}
			if (this.y>target.y){ this.y -= speed; }
			if (this.y<target.y){ this.y += speed; }
			else {this.y = this.y;}
			}
			if (!main.playGame){
				kill();
			}
		}
		function hitTest(e:Event){
			this.removeEventListener(Event.ENTER_FRAME, hitTest);
			if (this.hitTestObject(target)){
				if (main.health > 0){
					main.health -= damage;
					dTimer.start();
				} else {
					kill();
				}
			} else {this.addEventListener(Event.ENTER_FRAME, hitTest);}			
		}
		function enemyHit(evt:TimerEvent):void{
			if (main.health > 0 && this.hitTestObject(target)){
				main.health -= damage;
			}
		}
		public function kill():void{
			if(onStage && eHealth<=0){ //if this enemies health is <=0 and it exists
				onStage = false;//
				main.score += 1;//adds one to score
				main.mainGame.removeChild(this);
				main.enemies.removeAt(main.enemies.indexOf(this));
				dTimer.removeEventListener(TimerEvent.TIMER, enemyHit)
				this.removeEventListener(Event.ENTER_FRAME, hitTest);
				this.removeEventListener(Event.ENTER_FRAME, move);
			} else {
				eHealth -= 1;
			}
		}
	}
}
