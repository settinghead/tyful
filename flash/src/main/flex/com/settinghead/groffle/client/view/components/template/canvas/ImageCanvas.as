package com.settinghead.groffle.client.view.components.template.canvas
{
	import com.settinghead.groffle.client.model.vo.template.ImageLayer;
	import com.settinghead.groffle.client.view.components.template.TemplateEditor;
	
	import mx.events.FlexEvent;
	
	import spark.components.supportClasses.ItemRenderer;
	import spark.primitives.BitmapImage;
	
	public class ImageCanvas extends ItemRenderer
	{
		
		private var imageElement:BitmapImage;
		private var _templateEditor:TemplateEditor;
		private var _isCurrentLayer:Boolean;

		public function ImageCanvas()
		{
			super();
			this.addEventListener("creationComplete", this_creationCompleteHandler);
			this.autoDrawBackground = false;
		}

		protected function this_creationCompleteHandler(event:FlexEvent):void
		{
			populateLayer();
			if(isCurrentLayer)
				stage.focus = this;
			
		}
		
		public function get layer():ImageLayer{
			return data as ImageLayer;
		}
		public function get isCurrentLayer():Boolean{
			return _isCurrentLayer;
		}
		
		private function populateLayer():void{
			if(this.layer!=null)
			{
				
				for(var i:int=0;i<this.numChildren;i++)
					this.removeChildAt(0);
								
				imageElement = new BitmapImage();
				imageElement.source = layer.image;
				this.addElement(imageElement);
			}
		}
		
		public function set templateEditor(v:TemplateEditor):void{
			this._templateEditor = v;
		}
		
		public function get templateEditor():TemplateEditor{
			return _templateEditor;
		}
		
		
	}
}