package VJTV.comp{
	
	import fl.transitions.easing.*;
    import flash.display.*;
	import flash.events.*;
	import flash.utils.*;
	import flash.net.*;
	import flash.net.SharedObject;
	import flash.net.URLRequest;
	import flash.events.Event;
	
	
	import FlxerGallery.main.Rett;
	//import Footer.MyTween;
	
	public class MyLoader extends Sprite {
		public var myUrlLoader;
		public var FileLdr
		public var fileP
		public var imgMode
		public var w
		public var h
		public var rettMask
		public var endFunz
		public var funzBtn
		public var parametro
		public function MyLoader(xx,yy,ww,hh,filePath,modeImg,fnzBtn=null,par=null,endFnz=null) {
			imgMode= modeImg;
			funzBtn = fnzBtn;
			parametro = par
			endFunz = endFnz;
			fileP = filePath;
			x=xx;
			y=yy;
			w = ww;
			h = hh;
			avvia(filePath)
		}
		public function avvia(filePath){
			try{
				removeChild(FileLdr.content)
			}
			catch(e:*){
			}
			FileLdr = new Loader();
			myUrlLoader = new URLRequest(filePath);
			FileLdr.load(myUrlLoader);
			FileLdr.contentLoaderInfo.addEventListener("complete", myUrlListener); 
			FileLdr.contentLoaderInfo.addEventListener("ioError", myUrlListener);
		}
		
		public function myUrlListener(event){
			if (event.type == "complete") {
				this.addChild(FileLdr.content);
				//FileLdr.content.alpha=0
				//Pref.myTween["tween"+Pref.contaTween] = new MyTween(FileLdr.content,"alpha",Regular.easeInOut,FileLdr.content.alpha,1,0.5,null)
				//Pref.contaTween++
				if(endFunz!=null){
					endFunz();
				}
				if(imgMode=="mask"){
					maskFunction()
				}
				if(imgMode=="scale"){
					scaleFunction()
				}
				if(funzBtn!=null){
					btnFunction()
				}
			}else{
				if(endFunz!=null){
					endFunz();
				}
			}
		}
		
		public function maskFunction(){
			this.rettMask = new Rett(0,0,w,h,0xeb008b,null,1)
			this.addChild(this.rettMask)
			this.mask = this.rettMask
		}
		
		public function scaleFunction(){
			if(this.FileLdr.content.width > w || this.FileLdr.content.height > h){
				var risW = (this.FileLdr.content.width - w)
				var risH = (this.FileLdr.content.height - h)
					if (risW >= risH){
						this.FileLdr.content.width = w
						this.FileLdr.content.scaleY = this.FileLdr.content.scaleX
					}else{
						this.FileLdr.content.height = h
						this.FileLdr.content.scaleX = this.FileLdr.content.scaleY
					}
				this.FileLdr.content.x= (w - this.FileLdr.content.width)/2 
				this.FileLdr.content.y= (h - this.FileLdr.content.height)/2 
				this.rettMask = new Rett(this.FileLdr.content.x,this.FileLdr.content.y,this.FileLdr.content.width,this.FileLdr.content.height,0xeb008b,null,1)
				this.addChild(this.rettMask)
				this.mask = this.rettMask
			}
		}
		
		public function btnFunction(){
			this.mouseChildren = false;
			this.addEventListener(MouseEvent.MOUSE_OVER,mouseOverHandler);
			this.addEventListener(MouseEvent.MOUSE_OUT,mouseOutHandler);
			this.addEventListener(MouseEvent.MOUSE_DOWN,mouseDownHandler);
			this.buttonMode=true;
		}
			
		public function mouseUpAcivation(f:Function) {
			this.addEventListener(MouseEvent.MOUSE_UP,mouseUpHandler);
			function mouseUpHandler(event):void {
				
			}
		}
		function mouseOverHandler(event):void {
			
		}
		
		function mouseOutHandler(event):void {
			
		}
		function mouseDownHandler(event):void {
			mouseOutHandler(event);
			if(parametro!=null){
				funzBtn(parametro)
			}else{
				funzBtn()
			}
		}
	}
}