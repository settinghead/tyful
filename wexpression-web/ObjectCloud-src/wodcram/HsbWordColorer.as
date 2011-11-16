package wordcram {
/*
Copyright 2010 Daniel Bernier

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/

import processing.core.PApplet;
import processing.core.PConstants;

abstract 
internal class HsbWordColorer implements WordColorer {
	private var host:PApplet;
	private var range:int;
	
	HsbWordColorer(var host:PApplet) {
		this(host, 255);
	}
	HsbWordColorer(var host:PApplet, var range:int) {
		this.host = host;
		this.range = range;
	}
	
	public function colorFor(word:Word):int {
		host.pushStyle();
		host.colorMode(PConstants.HSB, range);
		var color:int= getColorFor(word);
		host.popStyle();
		return color;
	}
	
	abstract function getColorFor(word:Word):int ;
}
}