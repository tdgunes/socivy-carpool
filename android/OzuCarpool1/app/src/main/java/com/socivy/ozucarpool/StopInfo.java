package com.socivy.ozucarpool;

import org.json.JSONException;
import org.json.JSONObject;

public class StopInfo {

	public int id;
	public String name;
	public long latitude;
	public long longitude;
	
	public StopInfo() {
		
	}
	
	public static StopInfo createFromJSON(String json) {
		StopInfo listItem = new StopInfo();

		try {
			JSONObject jObject = new JSONObject(json);
			listItem.id = Integer.parseInt(jObject.getString("id"));
			listItem.name = jObject.getString("name");

		} catch (JSONException e) {
			e.printStackTrace();
		}
		return listItem;
	}
}
