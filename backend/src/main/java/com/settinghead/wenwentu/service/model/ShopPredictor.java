package com.settinghead.wenwentu.service.model;

import java.util.ArrayList;
import java.util.List;


public class ShopPredictor {

	public static List<ShopItem> getShop(String userId, String templateId) {
		return getGenericShop();
	}
	
	private static final String IMAGE_URL_PREFIX = "https://www.groffle.me/f/shop/";
	
	public static List<ShopItem> getGenericShop(){
		List<ShopItem> result = new ArrayList<ShopItem>();

		result.add(zazzleProduct("Male T-Shirt", "235647948106072294","standardtee.jpeg"));
		result.add(zazzleProduct("Iphone 4 Case", "176148784658126770","iphone4case.png"));
		result.add(zazzleProduct("Coffee Mug", "168748918263067029","coffeemug.jpeg"));
		result.add(zazzleProduct("Women's T-Shirt", "235250899573207988","femaletee.jpeg"));
		
		return result;
	}
	
	private static ShopItem zazzleProduct(String name, String prod_id, String imageFileName){
		ShopItem item3 = new ShopItem();
		item3.setName(name);
		item3.setUrl("http://www.zazzle.com/api/create/at-238390271796358057?rf=238390271796358057&ax=Linkover&pd="+prod_id+"&fwd=ProductPage&ed=true&tc=&ic=&coverimage=[preview]");
		item3.setImageUrl(IMAGE_URL_PREFIX+imageFileName);
		return item3;
	}

}
