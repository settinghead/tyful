package com.settinghead.wexpression.client.view.components
{
	import flash.display.Graphics;
	import flash.display.Sprite;
	
	import mx.controls.listClasses.IListItemRenderer;
	
	import spark.components.SkinnableDataContainer;
	import spark.events.IndexChangeEvent;
	import spark.layouts.BasicLayout;
	
	public class LayerStack extends SkinnableDataContainer
	{
		public function LayerStack()
		{
			super();
			this.layout = new BasicLayout();
		}
			
	}
}