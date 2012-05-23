package com.settinghead.wenwentu.service.model;

import java.util.ArrayList;
import java.util.List;


public class ShopPredictor {

	public static List<ShopItem> getShop(String userId, String templateId) {
		return getGenericShop();
	}
	
	public static List<ShopItem> getGenericShop(){
		List<ShopItem> result = new ArrayList<ShopItem>();

		ShopItem item1 = new ShopItem();
		item1.setName("Male Tee");
		item1.setUrl("http://www.zazzle.com/api/create/at-238390271796358057?rf=238390271796358057&ax=Linkover&pd=235647948106072294&fwd=ProductPage&ed=true&tc=&ic=&standardtee=[preview]");
		item1.setImageUrl("http://file.wenwentu.com/f/shop/standardtee.jpeg");
		result.add(item1);
		
		ShopItem item2 = new ShopItem();
		item2.setName("Coffee Mug");
		item2.setUrl("http://www.zazzle.com/api/create/at-238390271796358057?rf=238390271796358057&ax=Linkover&pd=235647948106072294&fwd=ProductPage&ed=true&tc=&ic=&standardtee=[preview]");
		item2.setImageUrl("http://file.wenwentu.com/f/shop/coffeemug.jpeg");
		result.add(item2);
		
		return result;
	}

}
