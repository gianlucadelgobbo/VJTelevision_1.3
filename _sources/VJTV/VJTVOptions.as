package VJTV {
	import FLxER.panels.Palette;
	import FLxER.comp.ButtonTxt;
	import FLxER.main.Txt;
	public class VJTVOptions extends Palette {
		public function VJTVOptions(w:int,h:int,t:String,fnz:Function):void {
			super(w,h,t,"");
			var mode0:ButtonTxt = new ButtonTxt(10, 30, 90, 11, "SWITCH ON TV", fnz, 0, "");
			this.palette.addChild(mode0);
			var lab0:Txt = new Txt(15, 50, 180, 100, "You can clone the monitor from videocard settings and play VJTV in fullscreen and watch it on your TV.", Preferences.pref.ts, null);
			this.palette.addChild(lab0);
			mode0.scaleX = mode0.scaleY = 2;
		}
	}
}