﻿package VJTV.comp {	import flash.display.MovieClip;	import flash.geom.ColorTransform;	import flash.events.MouseEvent;	import flash.geom.Rectangle;	public class ButtonVolume extends MovieClip {		///////		var fnz:Function;		var myStatus;		public var slide:MovieClip;		public var path:MovieClip;		public var simb:MovieClip;		public var puls:MovieClip;		public var pulsInt:MovieClip;				public var fondoPath:MovieClip;		var alt;		var startH 		var openH		//		public function ButtonVolume() {		}		public function avvia(obj) {			this.slide.visible = false;			this.path.visible = false;			this.fondoPath.visible = false;			myStatus = false;			fnz = obj.fnz;			alt = obj.alt;			startH = this.puls.height;			openH = -(this.path.y+100);			enable();			var myCol:ColorTransform			myCol = this.simb.transform.colorTransform;			myCol.color = Preferences.pref.btnSimb;			simb.transform.colorTransform = myCol;						myCol = this.puls.transform.colorTransform;			myCol.color = Preferences.pref.btnBorder;			this.puls.transform.colorTransform = myCol;						myCol = pulsInt.transform.colorTransform;			myCol.color = Preferences.pref.btnBkg;			pulsInt.transform.colorTransform = myCol;/**/		}		public function enable() {			this.mouseChildren = false;			this.addEventListener(MouseEvent.MOUSE_DOWN,mouseDownHandler);			this.addEventListener(MouseEvent.MOUSE_OVER,mouseOverHandler);			this.addEventListener(MouseEvent.MOUSE_OUT,mouseOutHandler);			this.buttonMode=true;		}		public function disable() {			this.mouseChildren = true;			this.removeEventListener(MouseEvent.MOUSE_DOWN,mouseDownHandler);			this.removeEventListener(MouseEvent.MOUSE_OVER,mouseOverHandler);			this.removeEventListener(MouseEvent.MOUSE_OUT,mouseOutHandler);			this.buttonMode=false;		}		function sliderAct(e) {			fnz(-(this.slide.y+openH)/100)		}		public function getVal() {			return -(this.slide.y+openH)/100		}		function mouseUpHandler(e) {			if (e.target == circle || circle.contains(e.target)){				// mouse is up over circle (onRelease)				// (if circle is not a DisplayObjectContainer,				// you do not need to use the contains check)			}else{				// mouse is up outside circle (onReleaseOutside)			}			// be sure to clean up stage listener			stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);			stoppaSliderAct(e)		}		function avviaSliderAct(e) {			this.slide.startDrag(true, new Rectangle(this.path.x, this.path.y, 0, 100));			stage.addEventListener(MouseEvent.MOUSE_UP,stoppaSliderAct);			stage.addEventListener(MouseEvent.MOUSE_MOVE,sliderAct);		}		function stoppaSliderAct(e) {			//this.pulsInt.height = startH-2;			//this.puls.height = startH;			this.slide.visible = this.path.visible = this.fondoPath.visible = false;			this.slide.removeEventListener(MouseEvent.MOUSE_DOWN,avviaSliderAct);			stage.removeEventListener(MouseEvent.MOUSE_UP, stoppaSliderAct);			stage.removeEventListener(MouseEvent.MOUSE_MOVE,sliderAct);			this.slide.stopDrag();			enable();		}		function mouseDownHandler(e) {			disable()			this.slide.visible = this.fondoPath.visible = true;			this.slide.addEventListener(MouseEvent.MOUSE_DOWN,avviaSliderAct);			this.slide.buttonMode=true;			//this.pulsInt.height = 130;			//this.puls.height = 1-this.path.y+startH;						mouseOutHandler(e);		};		function mouseOverHandler(e) {			/*var myCol:ColorTransform			if (this.simb is MovieClip) {				myCol = simb.transform.colorTransform;				myCol.color = Preferences.pref.btnSimbOver;				simb.transform.colorTransform = myCol;			} else {				this.lab.textColor = Preferences.pref.btnSimbOver;			}			myCol = this.puls.transform.colorTransform;			myCol.color = Preferences.pref.btnBorderOver;			this.puls.transform.colorTransform = myCol;			myCol = pulsInt.transform.colorTransform;			myCol.color = Preferences.pref.btnBkgOver;			pulsInt.transform.colorTransform = myCol;*/			if (alt) {				Preferences.pref.myAlt.avvia(alt);			}		}		function mouseOutHandler(e) {			/*var myCol:ColorTransform			if (this.simb is MovieClip) {				myCol = simb.transform.colorTransform;				myCol.color = Preferences.pref.btnSimb;				simb.transform.colorTransform = myCol;			} else {				this.lab.textColor = Preferences.pref.btnSimb;			}			myCol = this.puls.transform.colorTransform;			myCol.color = Preferences.pref.btnBorder;			this.puls.transform.colorTransform = myCol;			myCol = pulsInt.transform.colorTransform;			myCol.color = Preferences.pref.btnBkg;			pulsInt.transform.colorTransform = myCol;*/			Preferences.pref.myAlt.stoppa();		}	}}