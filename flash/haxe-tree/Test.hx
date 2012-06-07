import com.settinghead.groffle.client.model.algo.tree.BBPolarChildTreeVO;
import com.settinghead.groffle.client.model.algo.tree.BBPolarRootTreeVO;
import com.settinghead.groffle.client.model.algo.tree.BBPolarTreeBuilder;
import com.settinghead.groffle.client.model.algo.tree.BBPolarTreeVO;
import com.settinghead.groffle.client.model.algo.tree.IImageShape;
import com.settinghead.groffle.client.model.algo.tree.BitmapShapeVO;
import flash.external.ExternalInterface;
import flash.display.BitmapData;


class Test {
	
    static function main() {
		var bmpd:BitmapData = new BitmapData(100,300, true, 0x00000000);
		var s:BitmapShapeVO = new BitmapShapeVO(bmpd);
		var t:BBPolarRootTreeVO = BBPolarTreeBuilder.makeTree(s,0);
			
		ExternalInterface.call( "console.log" , t.toString());
			
    }
}