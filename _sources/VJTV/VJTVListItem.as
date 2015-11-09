﻿package VJTV {	import flash.display.Sprite;	import flash.display.Loader;	import flash.events.*;	import flash.net.URLRequest;	import FLxER.main.Rett;	import FLxER.main.Txt;	import FLxER.comp.ButtonTxt	import fl.transitions.*;	import fl.transitions.easing.*;	public class VJTVListItem extends Sprite {		var myTweenOn:Tween;		var myTweenOff:Tween;		public var tit,dat,dur,aut,txt,cat,tag		var fondino,imgLoader, fnz,fnzMore,n,img,loadingProgress,myXml,streamOpen		public function VJTVListItem(yy,f,ff):void {			fnz = f;			fnzMore = ff;			y=yy;			fondino = new Rett(0, 0, 370, 100, 0x000000, -1, .5);			this.addChild(fondino);			tit = new Txt(134, -5, 115, 20, "Title", Preferences.pref.ts, "");			tit.scaleX=tit.scaleY = 2			this.addChild(tit);			dat = new Txt(137, 20, 150, 20, "dat", Preferences.pref.ts, "");			this.addChild(dat);			dur = new Txt(258, 20, 100, 20, "dur", Preferences.pref.ts, "");			this.addChild(dur);			aut = new Txt(137, 34, 150, 20, "aut", Preferences.pref.ts, "");			this.addChild(aut);			cat = new Txt(258, 34, 100, 20, "dat", Preferences.pref.ts, "");			this.addChild(cat);			txt = new Txt(137, 45, 222, 40, "dat", Preferences.pref.ts, "");			txt.wordWrap = true;			this.addChild(txt);			this.img = new Sprite();			img.x=img.y=2;			this.addChild(img);			var fond = new Rett(0, 0, 128, 96, 0xCCCCCC, -1, .5);			img.addChild(fond);			this.imgLoader = new Loader();			imgLoader.contentLoaderInfo.addEventListener(Event.INIT, initHandlerSWF);			imgLoader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, errorHandlerSWF);			imgLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, errorHandlerSWF);			img.addChild(imgLoader);			more = new ButtonTxt(0, 80, 0, 15, "MORE", showInfo, "", null);			more.x = 370-5-more.width			this.addChild(more);		}		public function showInfo(a):void {			fnzMore(myXml,n);		}		public function avviaOn(e) {			myTweenOn = new Tween(fondino,"alpha",Strong.easeIn,0,1,1,true);			myTweenOn.addEventListener(TweenEvent.MOTION_FINISH, avviaOff);		}		public function avviaOff(e) {			myTweenOff = new Tween(fondino,"alpha",Strong.easeOut,1,0,1,true);			myTweenOff.addEventListener(TweenEvent.MOTION_FINISH, avviaOn);		}		public function riempi(xml,nn):void {			n = nn;			myXml = xml;			if (myTweenOn) myTweenOn.stop(); 			if (myTweenOff) myTweenOff.stop(); 			fondino.alpha = 1;			if (n == Preferences.pref.currentMedia){				avviaOff(null)			}			/*			var myDateA = myXml.childNodes[1].childNodes[1].nodeValue.split(",");			var myDate = new Date(myDateA[0],myDateA[1],myDateA[2],myDateA[3],myDateA[4],myDateA[5]);			trace("dat "+myDate.getFullYear()+"-"+putZero(myDate.getMonth()+1)+"-"+putZero(myDate.getDate())+" "+putZero(myDate.getHours())+":"+putZero(myDate.getMinutes()));			dat.htmlText = myDate.getFullYear()+"-"+putZero(myDate.getMonth()+1)+"-"+putZero(myDate.getDate())+" "+putZero(myDate.getHours())+":"+putZero(myDate.getMinutes());			*/			/*			trace("img "+myXml.childNodes[2].childNodes[0])			trace("tit "+myXml.childNodes[1].childNodes[0])			trace("dat "+myXml.childNodes[1].childNodes[1].childNodes[0]);			trace("dur "+Preferences.pref.interfaceTrgt.myTime(myXml.childNodes[1].childNodes[2].childNodes[0]));			trace("txt "+myXml.childNodes[1].childNodes[3].childNodes[0])			trace("aut "+myXml.childNodes[1].childNodes[4].childNodes[0])			trace("cat "+myXml.childNodes[1].childNodes[5].childNodes[0])			trace("tag "+myXml.childNodes[1].childNodes[6].childNodes[0])			trace(this.tit)			*/			if (myXml.childNodes[1].childNodes.length>7) {				var ora = myXml.childNodes[1].childNodes[7].childNodes[0].toString().split(":");				ora.pop();			}			tit.htmlText = (myXml.childNodes[1].childNodes.length>7 ? ora.join(":") +" | " : "")+myXml.childNodes[1].childNodes[0]			dat.htmlText = myXml.childNodes[1].childNodes[1].childNodes[0].toString().split(" ")[0];			dur.htmlText = Preferences.pref.interfaceTrgt.myToolbar.myTime(int(parseInt(myXml.childNodes[1].childNodes[2].childNodes[0])/1000));			txt.htmlText = myXml.childNodes[1].childNodes[3].childNodes[0];			aut.htmlText = myXml.childNodes[1].childNodes[4].childNodes[0];			myXml.childNodes[1].childNodes[5].childNodes[0].attributes.href = "event:"+myXml.childNodes[1].childNodes[5].childNodes[0].attributes.href;			cat.htmlText = myXml.childNodes[1].childNodes[5].childNodes[0];			cat.addEventListener(TextEvent.LINK, linkHandler);			dur.x = 358-dur.textWidth			cat.x = 358-cat.textWidth			imgLoader.load(new URLRequest(myXml.childNodes[2].childNodes[0].toString()));			loadingProgress = true;			streamOpen = true;			//tag.htmlText = myXml.childNodes[3].childNodes[0];		}		public function linkHandler(e):void {			Preferences.pref.interfaceTrgt.chCnt.paletteHideShow(e.text);		}		public function svuota():void {			fondino.alpha = 1;			tit.htmlText = dat.htmlText = dur.htmlText = aut.htmlText = txt.htmlText = cat.htmlText = "";			if (loadingProgress) {				if (streamOpen) {					imgLoader.close();					streamOpen = false;				}			} else {				imgLoader.unload();			}		}		private function putZero(str):String {			return (str.toString().length < 2 ? "0"+str : str);		}		private function mouseDownHandler(event:Event):void {			fnz(n);		}		private function mouseOverHandler(event:Event):void {			img.alpha = .5;		}		private function mouseOutHandler(event:Event):void {			img.alpha = 1;		}		private function initHandlerSWF(event:Event):void {			streamOpen = false;			loadingProgress = false;			enable()		}		private function errorHandlerSWF(event:Event):void {			trace("error "+event)		}		public function enable() {			img.mouseChildren = false;			img.addEventListener(MouseEvent.MOUSE_DOWN,mouseDownHandler);			img.addEventListener(MouseEvent.MOUSE_OVER,mouseOverHandler);			img.addEventListener(MouseEvent.MOUSE_OUT,mouseOutHandler);			img.buttonMode=true;		}		public function disable() {			img.mouseChildren = true;			img.removeEventListener(MouseEvent.MOUSE_DOWN,mouseDownHandler);			img.removeEventListener(MouseEvent.MOUSE_OVER,mouseOverHandler);			img.removeEventListener(MouseEvent.MOUSE_OUT,mouseOutHandler);			img.buttonMode=false;			mouseOutHandler(null);		}	}}