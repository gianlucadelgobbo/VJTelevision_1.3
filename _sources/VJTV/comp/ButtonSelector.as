package VJTV.comp {
	import flash.display.Sprite;
	import flash.geom.ColorTransform;
	import flash.events.MouseEvent;
	import flash.display.Loader;
	import flash.events.*;
	import flash.net.URLRequest;
	import flash.display.Shape;

	import FlxerGallery.main.DrawerFunc;
	import FlxerGallery.main.Txt;
	
	public class ButtonSelector extends Sprite {
		var w:Number;
		var h:Number;
		var fnz:Function;
		var param;
		var src:String;
		var tipo:String;
		var alt:String;
		///////
		var puls:Sprite;
		var fondo;
		var imm:Sprite;
		var myMask;
		var col;
		var immLoader
		//
		public function ButtonSelector(xx, yy, f, p, t, s, a) {
			fnz = f;
			param = p;
			tipo = t;
			src = s;
			alt = a;
			w = Preferences.pref.thw;
			h = Preferences.pref.thh;
			x = xx;
			y = yy;
			col = Preferences.pref.playlistThumbnailsOverColor;
			this.puls = new Sprite();
			DrawerFunc.drawer(this.puls, 0, 0, w, h, col, null, 1);
			this.addChild(puls);
			this.myMask = new Sprite();
			this.imm = new Sprite();
			if (Preferences.pref.playerBackground != null) {
				fondo = new Sprite();
				DrawerFunc.drawer(fondo,0,0,w,h,Preferences.pref.playerBackground,null,1);
			} else {
				fondo = new Shape();
				DrawerFunc.textureDrawer(fondo, w, h);
			}
			this.imm.addChild(fondo);
			imm.x = myMask.x = w/2;
			imm.y = myMask.y = h/2;
			fondo.x = -w/2;
			fondo.y = -h/2;
			this.addChild(imm);
			this.addChild(myMask);
			var rett = new Sprite();
			DrawerFunc.drawer(rett, -w/2, -h/2, w, h, col, null, 1);
			this.myMask.addChild(rett);
			//
			this.immLoader = new Loader();
			immLoader.contentLoaderInfo.addEventListener(Event.INIT, initHandler);
			immLoader.load(new URLRequest(src));
			
		}
		function mouseDownHandler(e) {
			fnz(param);
			//_root.bip.play();
			mouseOutHandler(e);
		}
		function mouseOverHandler(e) {
			myMask.scaleX = .92;
			myMask.scaleY = .892;
			if (alt) {
				Preferences.pref.myAlt.avvia(alt);
			}
		}
		function mouseOutHandler(e) {
			if (alt) {
				Preferences.pref.myAlt.stoppa();
			}
			//_root.altPlayer.stoppa()
			myMask.scaleX = myMask.scaleY = 1;
		}
		function resizza(tt) {
			tt.width = w;
			tt.height = h;
			if ((tt.scaleX/tt.scaleY)>(w/h)) {
				tt.scaleX = tt.scaleY;
			} else {
				tt.scaleY = tt.scaleX;
			}
		}
		function initHandler(t) {
			if (immLoader.width/immLoader.height>w/h) {
				immLoader.width = w;
				immLoader.scaleY = immLoader.scaleX;
			} else {
				immLoader.height = h;
				immLoader.scaleX = immLoader.scaleY;
			}
			immLoader.x = -immLoader.width/2
			immLoader.y = -immLoader.height/2
			this.imm.addChild(immLoader);
			this.addEventListener(MouseEvent.MOUSE_DOWN,mouseDownHandler);
			this.addEventListener(MouseEvent.MOUSE_OVER,mouseOverHandler);
			this.addEventListener(MouseEvent.MOUSE_OUT,mouseOutHandler);
			this.mouseChildren = false;
			this.buttonMode=true;
			if (Preferences.pref.btnSelLabel) {
				if (tipo == "flv" || tipo == "mp3" || tipo == "swf") {
					var tmp;
					if (tipo == "flv") {
						tmp = "VIDEO";
					} else if (tipo == "swf") {
						tmp = "FLASH MOVIE";
					} else {
						tmp = "AUDIO";
					}
					var tipoTxt = new Txt(10,h-25,w-20,19,"<p>"+tmp+"</p>","puls");
					this.addChild(tipoTxt)
					//_root.myDrawerFunc.drawer(this, "fondino", 5, h-24, w-10, 19, 0xFFFFFF, null, 50);
					//_root.myDrawerFunc.textDrawerSP(this, "tipoTxt", "<p class=\"typeLabel\">"+tmp+"</p>", 10, h-25, w-20, 19, true);
					//this.tipoTxt.alpha = 100;
				}
			}
			resizza(imm.getChildAt(1));
			this.addChild(myMask);
			this.imm.mask =this.myMask;
		}
	}
}
