package VJTV.comp {
	import flash.display.Sprite;
	import fl.transitions.easing.*;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.*;
	import flash.ui.Mouse;

	import FlxerGallery.main.Rett;
	import VJTV.comp.ButtonImg;
	import VJTV.comp.ButtonSelector;
	import FlxerGallery.main.Txt;

	public class FotoSlider extends Sprite {
		//PARAMETRI
		public var myX
		public var myY
		public var myW
		public var myH
		public var myPadding = 4
		public var myThumbW = Preferences.pref.thw;
		public var myThumbH = Preferences.pref.thh;
		public var myThumbSpacer = 4
		public var myFunz
		
		public var localXml
		public var numVoci

		//ELEMENTI
		public var btnSlide;
		public var thumbMask;
		public var thumbsSprite:Sprite
		public var thumbOb:Object;
		
		public var btnGo
		public var btnGoPrev
		public var labelTxt;
	
		
		public function FotoSlider(xx, yy, ww, hh, xml, fnz) {
			this.myX = xx
			this.myY = yy
			this.myW = ww
			this.myH = hh
			
			x = this.myX
			y = this.myY
			
			this.localXml = xml;
			this.myFunz = fnz;
			
			this.footerCrea();
		}
		public function footerCrea(){
			this.btnSlide = new Rett(0,0,this.myW,this.myH,0x663399,null,0);
			this.addChild(this.btnSlide)
			this.btnSlide.mouseChildren = true;
			this.btnSlide.addEventListener(MouseEvent.MOUSE_OVER,mouseControl);
			
			this.thumbsSprite = new Sprite();
			this.addChild(this.thumbsSprite)
			this.thumbsSprite.x = this.myPadding
			this.scriviPlistThumb()
			this.thumbMask= new Rett(this.myPadding,this.myPadding,(this.myW-(myPadding*2)),(this.myH-(myPadding*2)),0x005500,null,1);
			this.addChild(this.thumbMask)
			this.thumbsSprite.mask = this.thumbMask
			
			this.btnGo  = new BtnPlay()
			this.addChild(this.btnGo)
			this.btnGo.x = this.thumbMask.x+this.thumbMask.width
			this.btnGo.y = this.thumbMask.y+(this.thumbMask.height/2)
			this.btnGo.addEventListener(MouseEvent.MOUSE_OVER,playBtnOver)
			this.btnGo.addEventListener(MouseEvent.MOUSE_DOWN,staticScroll)
			
			this.btnGoPrev  = new BtnPlay()
			this.addChild(this.btnGoPrev)
			this.btnGoPrev.rotation = 180
			this.btnGoPrev.x = this.thumbMask.x
			this.btnGoPrev.y = this.thumbMask.y+(this.thumbMask.height/2)
			this.btnGoPrev.addEventListener(MouseEvent.MOUSE_OVER,playBtnOver)
			this.btnGoPrev.addEventListener(MouseEvent.MOUSE_DOWN,staticScrollPrev)
			this.labelTxt = new Txt(0,-20,300,19,"<p>"+Preferences.pref.lab[Preferences.pref.lng].otherContents+"</p>","");
			this.addChild(this.labelTxt)
			
			
		}
		
		public function scriviPlistThumb(){
			this.thumbsSprite.y = 0
			this.thumbOb = new Object();
			this.thumbOb.img = new Array();
			var contacolonne =0
			trace("OOOOOOOOOOOOOOOOO"+this.localXml)
			this.numVoci = this.localXml.childNodes.length;
			for(var i = 0; i<numVoci; i++){
				var path = this.localXml.childNodes[i].childNodes[0].childNodes[0].toString()
				var link = this.localXml.childNodes[i].childNodes[3].childNodes[0].toString()
				var tempX = ((this.myThumbSpacer+this.myThumbW)*contacolonne)
				var tempY = this.myPadding
				this.thumbOb.img[i] =  	new ButtonSelector(tempX,tempY, caricaProg, link, "jpg", path,"<p>"+this.localXml.childNodes[i].childNodes[1].childNodes[0]+"<br />"+this.localXml.childNodes[i].childNodes[2].childNodes[0]+"</p>");
				this.thumbsSprite.addChild(this.thumbOb.img[i])
				contacolonne++;
			}
			
		}
		
		function mouseControl(event) {
			this.addEventListener(Event.ENTER_FRAME,fun);
			}

		
		/*
		public function resizza(event) {
			trace(event.target.stageWidth + "_____" + this.myW)
			trace((event.target.stageWidth/2)-(this.myW/2))
			this.x=((event.target.stageWidth/2)-(this.myW/2))
			this.y=(event.target.stageHeight-this.myH)
			}
		*/
		
		function staticScroll(event) {
			if(this.thumbsSprite.x >= -((this.thumbsSprite.width-(this.myW-1))-this.myThumbW)){
				this.thumbsSprite.x -=this.myThumbW+this.myThumbSpacer
			}else{
				thumbsSprite.x = -(thumbsSprite.width-this.myW+1)
				//this.thumbsSprite.x = (this.thumbsSprite.width - (this.myW)) * -1
			}
		}
		function staticScrollPrev(event) {
			if(this.thumbsSprite.x < (this.myThumbW*-1)){
				this.thumbsSprite.x +=this.myThumbW+this.myThumbSpacer
			}else{
				thumbsSprite.x = this.myPadding
				//this.thumbsSprite.x =0
			}
		}
		function playBtnOver(event) {
			this.removeEventListener(Event.ENTER_FRAME,fun)
			}
		
		
		function fun(event):void {
			
			var myMouse =(mouseX)
			myMouse -=(this.myW + this.myPadding)/2
			myMouse /=20
			myMouse *=-1
			
			
			if(mouseY<-10 ){
				this.removeEventListener(Event.ENTER_FRAME,fun)
				}
			if(mouseY>this.myH+this.myPadding ){
				this.removeEventListener(Event.ENTER_FRAME,fun)
				}
				
			if(this.thumbsSprite.x <= this.myPadding && this.thumbsSprite.x >= -(this.thumbsSprite.width-(this.myW-1)) ){
				thumbsSprite.x +=myMouse
				}
					
			if(thumbsSprite.x <= -(thumbsSprite.width-(this.myW-1))){
				thumbsSprite.x = -(thumbsSprite.width-this.myW+1)
				}
			if(thumbsSprite.x>=this.myPadding){
				thumbsSprite.x = this.myPadding
				}
			
		}
		
		public function caricaProg(p){
			this.myFunz(p)
		}
	}
}