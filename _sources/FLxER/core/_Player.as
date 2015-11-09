/* STRUTTURA CLIP 
	effects
	cnt
		bkg
			SHAPE
		cnt w/2 h/2
			myVideo -w/2 -h/2
			swfLoader -w/2 -h/2
			imgLoader0 -w/2 -h/2
			imgLoader1 -w/2 -h/2
	cntMask w/2 h/2
		trgtMask -w/2 -h/2
		baseMask
			SHAPE -w/2 -h/2
*/
package FLxER.core {
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.display.MovieClip;
	import flash.display.Loader;
	import flash.media.Video;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundMixer;
	import flash.media.SoundTransform;
	import flash.media.SoundLoaderContext;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.events.*;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.display.AVM1Movie;
	import flash.net.LocalConnection;
	import fl.transitions.*;
	import fl.transitions.easing.*;
	import flash.system.LoaderContext;
	import flash.system.Security;
	import flash.geom.ColorTransform;
	
	import FLxER.core.ColorMatrix;
    import flash.filters.ColorMatrixFilter;
	import flash.display.StageQuality;
	import flash.text.TextFormat;
	import flash.utils.*;
	import flash.xml.XMLDocument;

	//import flash.utils.*;
	public class Player extends Sprite {
		var ch:Number;
		var w:Number;
		var h:Number;
		public var xx:Number;
		public var yy:Number;
		public var zz:Number;
		public var myStopStatus:Boolean;
		public var oldTipo:String;
		var newFlv:Boolean;
		public var myDuration:Number;
		var myWidth:Number;
		var myHeight:Number;
		public var imgToShow:Loader;
		public var imgToRemove:Loader;
		public var myTweenA:Tween;
		public var myTweenS:Tween;
		public var song:SoundChannel;
		public var sliderVal:Number;
		var myTxt:String;
		var intTime:Number;
		var myFont:String;
		var txtKS:TextFormat;
		
		// CLIPS CONTAINERS
		public var bkg:Sprite;
		public var cnt:Sprite;
		public var vid:Sprite;
		public var myVideo:Video;
		//public var swfLoader;
		public var imgLoader0:Loader;
		public var imgLoader1:Loader;
		public var cntMask:Sprite;
		public var baseMask:Sprite;
		public var trgtMask:Sprite;
		public var oldMask:Sprite;
		// END CLIPS CONTAINERS

		// OBJECTS
		var NC:NetConnection;
		public var NS:NetStream;
		var customClient:Object;
		public var swfLoader:Loader;
		var wipesLoader:Loader;
		var swfSound:SoundMixer;
		var transformSound:SoundTransform;
		var flvSound:SoundMixer;
		public var mp3Sound:Sound;
		var CFT:Object;
		var CMT:Object;
		
		// END OBJECTS

		var seqInt:uint;
		var seqPos:Number;
		var seqPattern:Array;
		var masterSeq:Boolean;
		var seqStatus:Boolean;
		var needToRedrawMask:Boolean;
		public function Player(a:uint, ww:uint, hh:uint):void {
			seqPos = -1;
			ch = a;
			w = ww;
			h = hh;
			myStopStatus = false;
			
			// PLAYER CLIPS

			this.cnt = new Sprite();
			this.addChild(cnt);		
			//
			this.bkg = new Sprite();
			trace("cazzo")
            bkg.graphics.beginFill(0xFFFFFF);
            bkg.graphics.drawRect(0, 0, w, h);
            bkg.graphics.endFill();
            this.cnt.addChild(bkg);
			bkg.visible = false;
			//
			this.vid = new Sprite();
            this.cnt.addChild(vid);
			//
			this.cntMask = new Sprite();
			this.addChild(cntMask);
			
			baseMask = new Sprite();
            baseMask.graphics.beginFill(0xFFFFFF);
            baseMask.graphics.drawRect(-w/2, -h/2, w, h);
            baseMask.graphics.endFill();
            this.cntMask.addChild(baseMask);
			needToRedrawMask = false;

			trgtMask = new Sprite();

			vid.x = cntMask.x = w/2;
			vid.y = cntMask.y = h/2;
			this.cnt.mask = this.cntMask;

			// END PLAYER CLIPS
			
			this.NC = new NetConnection();
			NC.addEventListener(NetStatusEvent.NET_STATUS, NCHandler);
			NC.connect(null);

			this.swfLoader = new Loader();
			swfLoader.contentLoaderInfo.addEventListener(Event.INIT, initHandlerSWF);
			swfLoader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, errorHandlerSWF);
			swfLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, errorHandlerSWF);

			this.wipesLoader = new Loader();
			wipesLoader.contentLoaderInfo.addEventListener(Event.INIT, initHandlerWipes);
            wipesLoader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, errorHandlerWipes);
            wipesLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, errorHandlerWipes);
			/*
			this.flvSound = new SoundMixer();
			this.swfSound = new SoundMixer();
			swfChannel = swfSound.play();
			transformSound = swfChannel.soundTransform;
            transformSound.volume = 0;
            swfChannel.soundTransform = transformSound;
			*/
			this.transformSound = new SoundTransform();

			this.bkg.transform.colorTransform = new ColorTransform(1, 1, 1, 1, -255, -255, -255, 1);
			this.myFont = Preferences.pref.myFont;
			this.txtKS = new TextFormat();
			this.txtKS.font = this.myFont;
			this.txtKS.size = 48;
			this.txtKS.color = 0x00000;
			this.txtKS.align = "center";
		}
		public function resizer(ww:uint,hh:uint):void {
			Preferences.pref.w = w = ww;
			Preferences.pref.h = h = hh;
			vid.x = cntMask.x = w/2;
			vid.y = cntMask.y = h/2;
			if (this.cntMask.contains(wipesLoader)) {
				resizerSwf(wipesLoader)
			//} else if (drawMask.numChildren == 0){
			} else if (this.cntMask.contains(baseMask)){
				trace(":::::::::::::::::::::::::::::::::::::::::::::::")
				baseMask.graphics.clear();
				baseMask.graphics.beginFill(0xFFFFFF);
				baseMask.graphics.drawRect(-w/2, -h/2, w, h);
				baseMask.graphics.endFill();
			}
			bkg.graphics.clear();
			bkg.graphics.beginFill(0xFFFFFF);
			bkg.graphics.drawRect(0, 0, w, h);
			bkg.graphics.endFill();
			if (oldTipo == "swf") {
				resizerSwf(swfLoader)
			} else if (oldTipo == "flv") {
				resizerFlv()
			} else if (oldTipo == "jpg") {
				resizerSwf(imgToShow);
			}
		}
		// SWF LOADER
		public function changeFps(myAction:Array):void {
			stage.frameRate = myAction[3];
		}
		public function loadMedia(myAction:Array):void {
			if ((myAction[3].slice(-3,myAction[3].length)).toLowerCase()=="swf" ) {
				if (oldTipo != null) {
					this["RESET"+oldTipo]();
				}
				oldTipo = myAction[4];
				myTxt = myAction[6];
				intTime = parseInt(myAction[7])
				sliderVal = parseFloat(myAction[5])/100;
				swfLoader.load(new URLRequest(myAction[3]));
			} else {
				loadImg(myAction)
			}
		}
		private function resizerSwf(t:Loader):void {
			if (Preferences.pref.resizza_onoff) {			
				if (w/h < t.contentLoaderInfo.width/t.contentLoaderInfo.height) {
					t.scaleX = w/t.contentLoaderInfo.width;
					t.scaleY = t.scaleX;
				} else {
					t.scaleY = h/t.contentLoaderInfo.height;
					t.scaleX = t.scaleY;
				}
			} else  {
				t.scaleY = t.scaleX = 1;
			}
			if (Preferences.pref.centra_onoff) {			
				t.x = -(t.contentLoaderInfo.width*t.scaleX)/2;
				t.y = -(t.contentLoaderInfo.height*t.scaleY)/2;
			} else {
				t.x = -w/2;
				t.y = -h/2;
			}
		}
		private function initHandlerSWF(event:Event):void {
			//this.swfLoader = new MovieClip();
			//swfLoader = this.swfLoader;
			myWidth = this.swfLoader.contentLoaderInfo.width;
			myHeight = this.swfLoader.contentLoaderInfo.height;
			trace(this.swfLoader.contentLoaderInfo.width)
			trace(this.swfLoader.contentLoaderInfo.height)
			if(this.swfLoader.content is AVM1Movie) {
				if (myStopStatus) {
					STOP(null);
				}
			}
			if (!this.vid.contains(swfLoader)) {
				//swfLoader.x = -w/2;
				//swfLoader.y = -h/2;
				this.vid.addChild(swfLoader);
			}
			if (myTxt) {
				swfLoader.content.startReader(myTxt, intTime);
				setFont()
				swfLoader.content.lab.x = -400+200;
				swfLoader.content.lab.y = 100;
				swfLoader.content.lab.width = 1200;
				swfLoader.content.lab.height = 100;
				ALIGNtxt([null,null,null,txtKS.align]);
			}
			resizerSwf(swfLoader)
			Preferences.pref.interfaceTrgt.initHandlerSWF(swfLoader, ch);
			setVolAct(sliderVal);
		}
		private function errorHandlerSWF(event:Event):void {
			Preferences.pref.interfaceTrgt.errorHandlerSWF(event, ch);
		}
		private function RESETswf():void {
			//this.swfLoader.close();
			if (this.vid.contains(swfLoader)) {
				this.swfLoader.unloadAndStop();
				this.vid.removeChild(swfLoader);
			}
		}
		public function SCRATCHswf(myAction:Array):void {
			//trgt.gotoAndPlay(int(((trgt.totalFrames-1)*(parseFloat(myAction[3])/800))+1));
			if(swfLoader.content is MovieClip) {
				var tmp
				if (myStopStatus) {
					tmp = "gotoAndStop";
				} else {
					tmp = "gotoAndPlay";
				}
				swfLoader.content[tmp](int(((swfLoader.totalFrames-1)*parseFloat(myAction[3]))+1));
			}
		}
		private function REWINDswf():void {
			if(swfLoader.content is MovieClip) {
				var act;
				if (myStopStatus) {
					act = "gotoAndStop";
				} else {
					act = "gotoAndPlay";
				}
				recursiveSwfActParam(swfLoader.content, act, 1);
			}
		}
		private function FORWARDswf():void {
			if(swfLoader.content is MovieClip) {
				var act;
				if (myStopStatus) {
					act = "gotoAndStop";
				} else {
					act = "gotoAndPlay";
				}
				recursiveSwfActParam(swfLoader, act, int(swfLoader.currentFrame+((swfLoader.totalFrames-swfLoader.currentFrame)/2)));
			}
		}
		private function STOPswf():void {
			if(swfLoader.content is MovieClip) {
				recursiveSwfAct(swfLoader.content, "stop");
			}
		}
		private function PLAYswf():void {
			if(swfLoader.content is MovieClip) {
				recursiveSwfAct(swfLoader.content, "play");
			}
		}
		private function recursiveSwfAct(trgt:Sprite, act:String) {
			trgt[act]();
			for (var a=0;a<trgt.numChildren;a++) {
				if (trgt.getChildAt(a) is MovieClip) {
					trgt.getChildAt(a)[act]();
					recursiveSwfAct(trgt.getChildAt(a), act);
				}
			}
		}
		private function recursiveSwfActParam(trgt:Sprite, act:String, p:uint) {
			trgt[act](p);
			var item;
			for (item in trgt) {
				if (trgt[item].totalFrames) {
					trgt[item][act](p);
					recursiveSwfActParam(trgt[item], act, p);
				}
			}
		}
		// END SWF LOADER

		// VIDEO LOADER
		public function loadFlv(myAction:Array):void {
			trace("loadFlv "+myAction[3])
			if (oldTipo != null && oldTipo != "flv") {
				this["RESET"+oldTipo]();
			}
			oldTipo = "flv";
			newFlv = true;
			this.NS.play(myAction[3]);
			this.NS.pause();
			setVolAct(parseFloat(myAction[5])/100);
		}
		public function NCHandler(event:NetStatusEvent):void {
			switch (event.info.code) {
				case "NetConnection.Connect.Success" :
					connectStream();
					break;
			}
		}
		public function connectStream():void {
			NS = new NetStream(NC);
			NS.bufferTime = 2;
			customClient = new Object();
			customClient.onMetaData = onMetaData;
			//customClient.onCuePoint = onCuePoint;
			//customClient.onPlayStatus = onPlayStatus;
			NS.client = customClient;
			NS.addEventListener(NetStatusEvent.NET_STATUS, NSHandler);
		}
		public function NSHandler(event:NetStatusEvent):void {
			//trace(event.info.code)
			if (event.info.code == "NetStream.Play.Stop") {
				if (Preferences.pref.myLoop) {
					NS.seek(0);
				}
			}
			if (event.info.code == "NetStream.Play.Start") {
				if (this.myStopStatus) {
					NS.pause();
					//NS.seek(0);
				}
			}
			// SOLO SUPERPLAYER //
			if (event.info.code == "NetStream.Play.StreamNotFound" || event.info.code == "NetStream.Play.FileStructureInvalid"|| event.info.code == "NetStream.Play.NoSupportedTrackFound") {
				Preferences.pref.interfaceTrgt.errorHandlerFLV(event, ch)
			} else {
				Preferences.pref.interfaceTrgt.initHandlerFLV(event, ch)
			}
		}
		private function resizerFlv():void {
			if (myVideo) {			
				if (Preferences.pref.resizza_onoff) {			
					if (w/h < myWidth/myHeight) {
						myVideo.width = w;
						myVideo.scaleY = myVideo.scaleX;
					} else {
						myVideo.height = h;
						myVideo.scaleX = myVideo.scaleY;
					}
				} else {
					myVideo.width = myWidth;
					myVideo.height = myHeight;
				}
				if (Preferences.pref.centra_onoff) {			
					myVideo.x = -myVideo.width/2;
					myVideo.y = -myVideo.height/2;
				} else {
					myVideo.x = -w/2;
					myVideo.y = -h/2;
				}
			}
		}
		public function onMetaData(info:Object):void {
			if (newFlv) {
				trace("metadata: duration=" + info.duration + " width=" + info.width + " height=" + info.height + " framerate=" + info.framerate)
				if (!this.myStopStatus) {
					this.NS.resume();
				}
				myDuration = info.duration;
				myWidth = info.width;
				myHeight = info.height;
				//
				if (myVideo is Video) {
					this.myVideo.clear();
				} else {
					this.myVideo = new Video(info.width , info.height);
					this.myVideo.smoothing = true;
					this.myVideo.attachNetStream(NS);
				}
				if (!this.vid.contains(this.myVideo)) {
					this.vid.addChild(myVideo);
				}
				resizerFlv()
				newFlv = false
				Preferences.pref.interfaceTrgt.onMetaDataFLV(info, ch)
			}
		}
		private function REWINDflv():void {
			NS.seek(0);
		}
		private function FORWARDflv():void {
			var tmp2 = int((NS.time)+(myDuration/10));
			if (tmp2>myDuration) {
				tmp2 = myDuration;
			}
			NS.seek(tmp2);
		}
		public function SCRATCHflv(myAction:Array):void {
			trace("SCRATCHflv 1 "+myAction[3])
			trace("SCRATCHflv 2 "+myDuration)
			NS.seek((myDuration*parseFloat(myAction[3])));
		}
		private function STOPflv():void {
			NS.pause();
		}
		private function PLAYflv():void {
			NS.resume();
		}
		private function RESETflv():void {
			this.NS.close();
			if (this.myVideo is Video) {
				if (this.vid.contains(this.myVideo)) {
					this.myVideo.clear();
					this.vid.removeChild(myVideo);
				}
			}
		}
		// END VIDEO LOADER
		
		// IMAGES LOADER
		public function loadImg(myAction:Array):void {
			if (oldTipo != null && oldTipo != "jpg") {
				this["RESET"+oldTipo]();
			}
			oldTipo = "jpg";
			/* SOLO SUPERPLAYER 
			loadPicAction = myAction;
			var contextTmp = false;
			if (Preferences.pref.policyFile) {
				Security.loadPolicyFile(Preferences.pref.policyFile);
				contextTmp = true;
			}
			var context = new LoaderContext(contextTmp);*/
			if (this.imgLoader0 == null) {
				this.imgLoader0 = new Loader();
			}
			if (this.imgLoader1 == null) {
				this.imgLoader1 = new Loader();				
			}
			//imgLoader0.alpha = imgLoader1.alpha = 0;
			this.vid.addChild(imgLoader0)
			this.vid.addChild(imgLoader1)
			if (this.imgLoader0.content == null) {
				imgLoader0.contentLoaderInfo.addEventListener(Event.INIT, initHandlerJPG);
				imgLoader0.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, errorHandlerJPG);
				imgLoader0.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, errorHandlerJPG);
				imgToShow = this.imgLoader0;
				imgLoader0.load(new URLRequest(myAction[3])/*, context*/);
			} else {
				imgLoader1.contentLoaderInfo.addEventListener(Event.INIT, initHandlerJPG);
				imgLoader1.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, errorHandlerJPG);
				imgLoader1.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, errorHandlerJPG);
				imgToShow = this.imgLoader1;
				imgLoader1.load(new URLRequest(myAction[3])/*, context*/);
			}
		}
		private function initHandlerJPG(event:Event):void {
			myWidth = this.imgToShow.contentLoaderInfo.width;
			myHeight = this.imgToShow.contentLoaderInfo.height;
			resizerSwf(imgToShow);
			if (imgToRemove != null) {
				resizerSwf(imgToRemove);
				myFadeOff();
			} else {
				myFadeOn();
			}
			Preferences.pref.interfaceTrgt.initHandlerJPG(imgToShow,ch);
        }
		private function errorHandlerJPG(event:Event):void {
			Preferences.pref.interfaceTrgt.errorHandlerJPG(event,ch);
		}
		private function myFadeOff():void {
			myFadeOn()
			myTweenS=new Tween(imgToRemove,"alpha",Strong.easeIn,1,0,.5,true);
			myTweenS.useSeconds = true;
			myTweenS.addEventListener(TweenEvent.MOTION_FINISH, myFadeOffFinish);
        }
		private function myFadeOffFinish(event:Event):void {
			imgToRemove.unload()
			myTweenS.removeEventListener(TweenEvent.MOTION_FINISH, myFadeOffFinish);
        }
		private function myFadeOn():void {
			// SOLO SUPERPLAYER //
			// parent.resizer();
			myTweenA = new Tween(imgToShow,"alpha",Strong.easeIn,0,1,1,true);
			myTweenA.useSeconds = true;
			myTweenA.addEventListener(TweenEvent.MOTION_FINISH, myFadeOnFinish);
        }
		private function myFadeOnFinish(event:Event):void {
			// SOLO SUPERPLAYER //
			Preferences.pref.interfaceTrgt.initHandlerJPG(imgToShow, ch);
			imgToRemove = imgToShow;
			myTweenA.removeEventListener(TweenEvent.MOTION_FINISH, myFadeOnFinish);
        }
		private function RESETjpg():void {
			imgToRemove = null;
			imgToShow = null;
			if (imgLoader0) {
				imgLoader0.unload();
			}
			if (imgLoader1) {
				imgLoader1.unload();
			}
			if (myTweenA) {
				myTweenA.stop()
				myTweenA.removeEventListener(TweenEvent.MOTION_FINISH, myFadeOnFinish);
			}
			if (myTweenS) {
				myTweenS.stop()
				myTweenS.removeEventListener(TweenEvent.MOTION_FINISH, myFadeOffFinish);
			}
			if (imgLoader0 is Loader) {
				if (this.vid.contains(imgLoader0)) {
					this.vid.removeChild(imgLoader0);
	//				imgLoader0 = null;
				}
			}
			if (imgLoader1 is Loader) {
				if (this.vid.contains(imgLoader1)) {
					this.vid.removeChild(imgLoader1);
	//				imgLoader1 = null;
				}
			}
		}
		// SOLO SUPERPLAYER //
		public function STOPjpg():void {
		}
		public function PLAYjpg():void {
			parent.load_foto()
		}
		public function REWINDjpg():void {
			//this.myStopStatus = true;
			parent.load_prev_foto()
		}
		public function FORWARDjpg():void {
			//this.myStopStatus = true;
			parent.load_foto()
		}
		// END IMAGES LOADER

		// MP3 LOADER
		public function loadMp3(myAction:Array):void {
			trace("loadMp3loadMp3loadMp3loadMp3loadMp3loadMp3loadMp3loadMp3loadMp3loadMp3loadMp3loadMp3loadMp3loadMp3loadMp3")
			if (oldTipo != null) {
				this["RESET"+oldTipo]();
			}
			oldTipo = "mp3";
			/*if (this.parent == _level0.monitor.mon) {
				this.mp3Sound.loadSound(myAction[3], false);
				//this.mp3Sound.setVolume(parseFloat(myAction[5]));
			}*/
			var slc = new SoundLoaderContext(1, false); 
			this.mp3Sound = new Sound();
			mp3Sound.addEventListener(Event.COMPLETE, soundCompleteHandler);
			mp3Sound.addEventListener(flash.events.ProgressEvent.PROGRESS, soundProgressHandler);
			mp3Sound.addEventListener(SecurityErrorEvent.SECURITY_ERROR, errorHandlerMP3);
			mp3Sound.addEventListener(IOErrorEvent.IO_ERROR, errorHandlerMP3);
			this.mp3Sound.load(new URLRequest(myAction[3]),slc);
			song = mp3Sound.play(0,1, transformSound);
			song.addEventListener(Event.SOUND_COMPLETE, soundCompleteHandler2);
			setVolAct(parseFloat(myAction[5])/100);
			// SOLO SUPERPLAYER //
			Preferences.pref.interfaceTrgt.initHandlerMP3(ch)
			if (myAction[6]) {
				this.imgLoader0 = new Loader();
				imgLoader0.x = -w/2;
				imgLoader0.y = -h/2;
				imgToShow = this.imgLoader0;
				//imgLoader0.alpha = 0;
				this.vid.addChild(imgLoader0)
				imgLoader0.contentLoaderInfo.addEventListener(Event.INIT, initHandlerJPG);
				imgLoader0.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, errorHandlerJPG);
				imgLoader0.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, errorHandlerJPG);
				imgLoader0.load(new URLRequest(myAction[6]));
			}
		}
		private function errorHandlerMP3(event:Event):void {
			Preferences.pref.interfaceTrgt.errorHandlerMP3(event, ch)
		}
		private function soundProgressHandler(event:Event):void {
			trace("bella"+mp3Sound.bytesLoaded)
		}
		private function soundCompleteHandler(event:Event):void {
		}
		private function soundCompleteHandler2(event:Event):void {
            transformSound.volume = sliderVal;
			song = mp3Sound.play(0,1, transformSound);
			song.addEventListener(Event.SOUND_COMPLETE, soundCompleteHandler2);
		}
		public function setVol(myAction:Array):void {
			trace("setVol "+myAction)
			setVolAct(parseFloat(myAction[3])/100)
		}
		private function setVolAct(v:Number):void {
			sliderVal = transformSound.volume = v;
			if (oldTipo == "flv") {
			trace("setVol "+v)
				NS.soundTransform = transformSound;
			} else if (oldTipo == "swf") {
				swfLoader.parent.soundTransform = transformSound;
			} else if (oldTipo == "mp3") {
				song.soundTransform = transformSound;
			}
		};
		private function RESETmp3():void {
			trace("mp3Reset")
			this.song.stop();
			RESETjpg();
		}
		private function REWINDmp3():void {
			song.stop();
			soundCompleteHandler2(null);
		}
		private function FORWARDmp3():void {
			song.stop();
			song = mp3Sound.play(song.position+((mp3Sound.length-song.position)/10));
			song.addEventListener(Event.SOUND_COMPLETE, soundCompleteHandler2);
		}
		public function SCRATCHmp3(myAction:Array):void {
			var tmp = (((mp3Sound.length)*(parseFloat(myAction[3])/800)))/1000;
			song.stop();
			song = mp3Sound.play(parseFloat(myAction[3])*mp3Sound.length);
			song.addEventListener(Event.SOUND_COMPLETE, soundCompleteHandler2);
		}
		private function STOPmp3():void {
			song.stop();
		}
		private function PLAYmp3():void {
			song = mp3Sound.play(song.position);
			song.addEventListener(Event.SOUND_COMPLETE, soundCompleteHandler2);
		}
		// END MP3 LOADER

		// WIPES LOADER
		public function changeWipe(myAction:Array):void {
			this.cntMask.graphics.clear();
			if (this.cntMask.contains(baseMask)) {
				this.cntMask.removeChild(baseMask);
			}
			this.wipesLoader.load(new URLRequest(myAction[3]))
		}
		public function restoreMask():void {
			if (oldMask) {
				this.cntMask.addChild(oldMask);
			}
		}
		public function clearMask(myAction:Array):void {
			if (!this.cntMask.contains(baseMask)) {
				this.cntMask.addChild(baseMask);
			}
			if (this.cntMask.contains(trgtMask)) {
				this.cntMask.removeChild(trgtMask);
			}
			needToRedrawMask = true;
			baseMask.graphics.clear();
		}
		private function initHandlerWipes(event:Event):void {
			//this.trgtMask = null;
			if (!this.cntMask.contains(trgtMask)) {
				this.cntMask.addChild(trgtMask);
			}
			this.trgtMask.addChild(wipesLoader);
			resizerSwf(wipesLoader)
		}
		private function errorHandlerWipes(event:Event):void {
			redrawWipe(null);
			Preferences.pref.interfaceTrgt.errorHandlerWipes(event, ch);
		}
		public function redrawWipe(myAction:Array):void {
			if (trgtMask) {
				if (this.cntMask.contains(trgtMask)) {
					this.wipesLoader.unload();
					this.cntMask.removeChild(trgtMask);
				}
			}
			if (!this.cntMask.contains(baseMask)) {
				this.cntMask.addChild(baseMask);
			}
			this.alpha = 1;
			if (needToRedrawMask) {
				baseMask.graphics.clear();
				baseMask.graphics.beginFill(0xFFFFFF);
				baseMask.graphics.drawRect(-w/2, -h/2, w, h);
				baseMask.graphics.endFill();
				needToRedrawMask = false;
			}
			/**/
		}
		public function slideWipe(myAction:Array):void {
			trace("setVol"+myAction[3])
			setVol(myAction[3]);
			if (oldTipo == "mp3") {
			}
			if (myAction[4] == "WIPE NONE (MIX)") {
				this.cntMask.scaleX = 1;
				this.cntMask.scaleY = 1;
				this.alpha = myAction[3]/100;
			} else if (myAction[4] == "HORIZONTAL") {
				this.cntMask.scaleX = myAction[3]/100;
				this.cntMask.scaleY = 1;
				this.alpha = 1;
			} else if (myAction[4] == "VERTICAL") {
				this.cntMask.scaleX = 1;
				this.cntMask.scaleY = myAction[3]/100;
				this.alpha = 1;
			} else {
				this.cntMask.scaleX = myAction[3]/100;
				this.cntMask.scaleY = myAction[3]/100;
				this.alpha = 1;
			}
		}
		public function useMap(myAction) {
			trace("useMapuseMapuseMapuseMapuseMapuseMapuseMap\n"+myAction[3]);
			clearMask(myAction);
			var xmlMap:XMLDocument = new XMLDocument();
			xmlMap.ignoreWhite = true;
			xmlMap.parseXML(myAction[3]);
			for (var a=0;a<xmlMap.childNodes[0].childNodes[0].childNodes.length;a++) {
				var forma = xmlMap.childNodes[0].childNodes[0].childNodes[a].attributes.d.substring(1).split("Q");
				forma[0] = forma[0].split(";");
				
				baseMask.graphics.beginFill(0x0000FF,1);
				baseMask.graphics.moveTo(forma[0][0],forma[0][1]);
				for (var b=1;b<forma.length;b++) {
					forma[b] = forma[b].split(";");
					baseMask.graphics.curveTo(forma[b][0],forma[b][1],(forma[b][2] ? forma[b][2] : forma[b][0]),(forma[b][3] ? forma[b][3] : forma[b][1]));
					trace(a+"-"+b+" "+forma[b][0]+" "+forma[b][1]+" "+forma[b][2]+" "+forma[b][3])
				}
				baseMask.graphics.curveTo(forma[0][0],forma[0][1],(forma[0][2] ? forma[0][2] : forma[0][0]),(forma[0][3] ? forma[0][3] : forma[0][1]));
				baseMask.graphics.endFill();
			}
		}
		// END WIPES LOADER
		
		// COLORS
		public function colorizing(myAction:Array):void {
			trace(myAction)
			this[myAction[3]].transform.colorTransform = new ColorTransform(1, 1, 1, 1, myAction[4], myAction[5], myAction[6], 1);
			//this[myAction[4]][myAction[5]] = myAction[6];
			//this.mySetTrasform(myAction);
		}
		public function bkgOnOff(myAction:Array):void {
			if (myAction[3] == "true") {
				bkg.visible = true;
			} else {
				bkg.visible = false;
			}
		}
		// END COLORS

		// SEQUENCER
		public function PLAY(myAction:Array):void {
			if (oldTipo) {
				this.cacheAsBitmap = this.myStopStatus=false;
				this["PLAY"+oldTipo]();
			}
		}
		public function STOP(myAction:Array):void {
			trace("STOPSTOPSTOPSTOPSTOPSTOPSTOPSTOPSTOPSTOPSTOPSTOPSTOPSTOPSTOPSTOPSTOPSTOPSTOPSTOPSTOPSTOPSTOPSTOPSTOPSTOPSTOP")
			if (oldTipo) {
				this.cacheAsBitmap = this.myStopStatus=true;
				this["STOP"+oldTipo]();
			}
		}
		public function REWIND(myAction:Array):void {
			if (oldTipo) {
				this["REWIND"+oldTipo]();
			}
		}
		public function FORWARD(myAction:Array):void {
			if (oldTipo) {
				this["FORWARD"+oldTipo]();
			}
		}
		public function HIDE(myAction:Array):void {
			this.visible = false;
		}
		public function SHOW(myAction:Array):void {
			this.visible = true;
		}
		// END SEQUENCER

		// END TRASFORM
		public function chMove(myAction:Array):void {
			this.x = myAction[3];
			this.y = myAction[4];
			vid.x = myAction[5];
			vid.y = myAction[6];
		}
		public function chScale(myAction:Array):void {
			vid.scaleX = myAction[3];
			vid.scaleY = myAction[4];
		}
		public function chRotate(myAction:Array):void {
			//this.cnt.mask = null;
			cntMask.rotationX = cnt.rotationX = myAction[3];
			cntMask.rotationY = cnt.rotationY = myAction[4];
			cntMask.rotationZ = cnt.rotationZ = myAction[5];
			//this.cnt.mask = this.cntMask;
		}
		public function mRotate(myAction:Array):void {
			vid.rotationX = myAction[3];
			vid.rotationY = myAction[4];
			vid.rotationZ = myAction[5];
		}
		public function myReset(myAction:Array):void {
			trace("myReset");
				this.x = 0;
				this.y = 0;
			/*if (!Preferences.pref.myTreDengine.isOn) {
				this.cntMask.scaleX = 1;
				this.cntMask.scaleY = 1;
			}*/
			trace("myReset");
			vid.x = w/2;
			vid.y = h/2;
			vid.rotation = 0;
			vid.scaleX = Preferences.pref.monObj.dScaleX;
			vid.scaleY = Preferences.pref.monObj.dScaleY;
			trace("myReset");
//			bkg.scaleX = 100/(Preferences.pref.monObj.dScaleX*100);
//			bkg.scaleY = 100/(Preferences.pref.monObj.dScaleY*100);
		}
		public function chFlipH(myAction:Array):void {
			if (myAction[3] == "true") {
				this.x = w;
				this.scaleX = -1;
			} else {
				this.x = 0;
				this.scaleX = 1;
			}
		}
		public function chFlipV(myAction:Array):void {
			if (myAction[3] == "true") {
				this.y = h;
				this.scaleY = -1;
			} else {
				this.y = 0;
				this.scaleY = 1;
			}
		}
		// END TRASFORM
		public function changeBlend(myAction:Array):void {
			this.blendMode = myAction[3];
		}
		public function setMatrix(myAction:Array):void {
			var mat:ColorMatrix=new ColorMatrix();
			mat.adjustHue(Number(myAction[7]));
			mat.adjustSaturation(Number(myAction[8]));
			mat.adjustContrast(Number(myAction[9]));
			mat.adjustBrightness(Number(myAction[10]));
	//		mat.setAlpha(alpha.value / 100);
			if (myAction[11]!= "undefined") {
				mat.threshold(Number(myAction[11]));
			}
			mat.setChannels(Number(myAction[3]),Number(myAction[4]),Number(myAction[5]),Number(myAction[6]));
			var cm:ColorMatrixFilter=new ColorMatrixFilter(mat.matrix);
			this.filters = new Array(cm);
		}
		public function eject(myAction:Array):void {
			if (oldTipo) {
				this["RESET"+oldTipo]();
			}
			oldTipo = undefined;
		}
		public function placeObjectIn3D(myAction:Array):void {
			trace("this.vid.alpha "+this.vid.alpha)
			trace("this.vid.x "+this.vid.x)
			trace("this.vid.y "+this.vid.y)
			trace("this.vid.scale "+this.vid.scaleY)
			trace("this.scalemask "+this.cntMask.scaleY)
			trace("\\this.alpha "+myAction[3])
			trace("\\this.x "+myAction[4])
			trace("\\this.y "+myAction[5])
			trace("\\this.scale "+myAction[6])
			trace("\\this.scalemask "+myAction[7])
			this.vid.alpha = myAction[3];
			this.vid.x = myAction[4];
			this.vid.y = myAction[5];
			this.vid.scaleX = this.vid.scaleY=myAction[6];
			//this.cntMask.scaleX = this.cntMask.scaleY = this.bkg.scaleX = this.bkg.scaleY=myAction[7];
			trace("this.vid.alpha "+this.vid.alpha)
			trace("this.vid.x "+this.vid.x)
			trace("this.vid.y "+this.vid.y)
			trace("this.vid.scale "+this.vid.scaleY)
			trace("this.scalemask "+this.cntMask.scaleY)
		}
		public function mySwapDepth(myAction:Array):void {
			parent.setChildIndex(this,parseFloat(myAction[3]));
		}
		public function myHQ(myAction:Array):void {
			stage.quality = StageQuality[myAction[3]];
		}
		public function ALIGNtxt(myAction:Array):void {
			trace(myAction[3])
			trace(txtKS)
			trace(swfLoader.content.lab)
			if (myTxt) {
				this.txtKS.align = myAction[3];
				if (this.txtKS.align == "right") {
					swfLoader.content.lab.x = -(swfLoader.content.lab.width-Preferences.pref.w/2);
				} else if (this.txtKS.align == "left") {
					swfLoader.content.lab.x = 0;
				} else {
					//swfLoader.content.lab.x = -(swfLoader.content.lab.width/2)+(Preferences.pref.w/4);
					swfLoader.content.lab.x = -400;
				}
				swfLoader.content.lab.defaultTextFormat = this.txtKS
			}
		}
		public function FONTtxt(myAction:Array):void {
			this.myFont = myAction[3]
			setFont()			
		}
		private function setFont():void {
			trace("setFontsetFontsetFontsetFont "+Preferences.pref.ts.font)
			trace("setFontsetFontsetFontsetFont "+this.myFont)
			/*
			*/
			if (this.myFont == "hooge 05_55") {
				this.txtKS.font = Preferences.pref.th.font;
				swfLoader.content.lab.embedFonts = true;
			} else if (this.myFont == "standard 07_53" || this.myFont == "standard 0753_8pt_st") {
				this.txtKS.font = Preferences.pref.ts.font;
				swfLoader.content.lab.embedFonts = true;
			} else {
				this.txtKS.font = this.myFont;
				swfLoader.content.lab.embedFonts = false;
			}
			swfLoader.content.lab.defaultTextFormat = this.txtKS
			//swfLoader.content.lab.setTextFormat(Preferences.pref.th);
			//swfLoader.content.lab.setNewTextFormat(this.txtKS);
		}
		private function RESETtxt():void {
			RESETswf();
		}
		private function FORWARDtxt():void {
			swfLoader.forwardTxt();
		}
		private function REWINDtxt():void {
			swfLoader.rewindTxt();
		}
		private function STOPtxt():void {
			swfLoader.stopTxt();
		}
		private function PLAYtxt():void {
			swfLoader.playTxt();
		}
		//
		function seqUpdater(myAction:Array):void {
			if (!seqPattern) {
				seqPattern = new Array("NULL","NULL","NULL","NULL","NULL","NULL","NULL","NULL","NULL","NULL","NULL","NULL","NULL","NULL","NULL","NULL");
			}
			clearInterval(seqInt);
			seqAct();
			seqInt = setInterval(seqAct, myAction[3]);
		}
		function setSeqPattern(myAction:Array):void {
			seqPattern = myAction.splice(3, 16);
			//trace(seqPattern);
		}
		function seqAct():void {
			if (seqPos>14) {
				seqPos = 0;
			} else {
				seqPos++;
			}
			if (masterSeq) {
				for (var a=0;a<Preferences.pref.nCh;a++) {
					if (Preferences.pref.monitorTrgt.levels["ch_"+a].seqStatus && Preferences.pref.monitorTrgt.levels["ch_"+a].seqPattern[seqPos]!="NULL") Preferences.pref.monitorTrgt.levels["ch_"+a][Preferences.pref.monitorTrgt.levels["ch_"+a].seqPattern[seqPos]](null);
				}
			} else {
				if (seqPattern[seqPos]!="NULL") this[seqPattern[seqPos]](null);
			}

			//trace(seqPos+": "+seqPattern[seqPos])
			if (seqPattern[seqPos]!="NULL") {
				this[seqPattern[seqPos]](null);
			}
		}
		function seqManager(myAction:Array):void {
			seqStatus = myAction[3];
		}
		function setMasterTap(myAction:Array):void {
			masterSeq = myAction[3];
		}
		function removeSeq(myAction:Array):void {
			clearInterval(seqInt);
		}
	}
}