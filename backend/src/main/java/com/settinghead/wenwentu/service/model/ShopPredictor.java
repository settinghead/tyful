package com.settinghead.tyful.service.model;

import java.util.ArrayList;
import java.util.List;


public class ShopPredictor {

	public static List<ShopItem> getShop(String userId, String templateId) {
		return getGenericShop();
	}
	
	private static final String IMAGE_URL_PREFIX = "https://www.tyful.me/f/shop/";
	
	public static List<ShopItem> getGenericShop(){
		List<ShopItem> result = new ArrayList<ShopItem>();

		result.add(zazzleProduct("Men's T-Shirt", "235575712596686313","standardtee.jpeg"));
		result.add(zazzleProduct("Women's T-Shirt", "235790054086636250","femaletee.jpeg"));
		result.add(zazzleProduct("Coffee Mug", "168032355816708750","coffeemug.jpeg"));
		result.add(zazzleProduct("Iphone 4 Case", "176594061325731500","iphone4case.png"));
		
		return result;
	}
	
	private static ShopItem zazzleProduct(String name, String prod_id, String imageFileName){
		ShopItem item3 = new ShopItem();
		item3.setName(name);
		item3.setUrl("http://www.zazzle.com/api/create/at-238390271796358057?rf=238390271796358057&ax=Linkover&pd="
				+prod_id+"&fwd=designtool&ed=true&tc=&ic=&coverimage=[preview]&coverimage2=[preview]");
		item3.setImageUrl(IMAGE_URL_PREFIX+imageFileName);
		return item3;
	}

}
