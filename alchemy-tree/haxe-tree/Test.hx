import polartree.BBPolarChildTreeVO;
import polartree.BBPolarRootTreeVO;
import polartree.BBPolarTreeBuilder;
import polartree.BBPolarTreeVO;
import polartree.IImageShape;


class Test {
	
    static function main() {
		var s:IImageShape = null;
		var t:BBPolarRootTreeVO = BBPolarTreeBuilder.makeTree(s,0);
    }
}