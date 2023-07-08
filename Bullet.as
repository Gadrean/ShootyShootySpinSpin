package  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.display.Stage;
	
	public class Bullet extends MovieClip { // variables to be used by every bullet 
		private var speed:int=10; //amount to move bullets by 
		private var onStage:Boolean; //keeps track of whther or not the bullet exists
		
		public function Bullet(player) { //runs evertime a bullet is created
			this.x = player.x;
			this.y = player.y;
			this.rotation = player.rotation;
			onStage = true;			
			this.addEventListener(Event.ENTER_FRAME,move)
		}
		
		function deg2rad(deg:Number):Number{ 
			return deg *(Math.PI/180);
		}
		function move(e:Event){
			var dx = Math.cos(deg2rad(this.rotation)) * speed;   //used to make the bullet move where the player is facing
			var	dy = Math.sin(deg2rad(this.rotation)) * speed;
			this.y += dy; 											//moves bullet
			this.x += dx;
			for (var i=0; i < main.bullets.length; i++){ // checks if any bullet is 
				if (this.x < 0 || this.x > 550 || this.y > 400 || this.y < 0 ){ //calls kill function if bullet is past stage borders
					kill();
				} else {
					hitTest();
				}
			}
		}
		public function hitTest(){
			for (var i=0; i < main.enemies.length; i++){  //loop through the entire enemies list
				if (this.hitTestObject(main.enemies[i])) {//if touching value i in enemies list
					main.enemies[i].kill();    		   	 //calls kill function in instance of enemy that the bullet is touching (i)
					kill();							     //calls bullet kill function
				}
			}
			
		}
			
		function kill() {
			if (onStage){
				onStage = false;				
				main.mainGame.removeChild(this);			//removes bullet from stage
				main.bullets.removeAt(main.bullets.indexOf(this));								//removes bullet from the list	
				this.removeEventListener(Event.ENTER_FRAME,move);
			}
		}
	}
}
