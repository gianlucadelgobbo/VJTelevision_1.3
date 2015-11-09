package VJTV.comp{
	import fl.transitions.*;
	import fl.transitions.easing.*;
	public class MyTween {
		var myTween:Tween;
		var funz;
		public function MyTween(obj,prop:String,tipo,pStart,pEnd,dur,fnz) {
			funz=fnz;
			myTween=new Tween(obj,prop,tipo,pStart,pEnd,dur,true);
			
			myTween.addEventListener(TweenEvent.MOTION_FINISH,endFunz);
		}
		public function endFunz(event) {
			
			if (funz != null) {
				funz();
			}
		}
			
}
}