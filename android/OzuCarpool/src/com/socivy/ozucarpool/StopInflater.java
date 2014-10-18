package com.socivy.ozucarpool;
import java.util.ArrayList;

import org.json.JSONArray;
import org.json.JSONObject;

public class StopInflater {
	String JSON;

	public StopInflater(String json) {
		this.JSON = json;
	}

	public void inflate(ArrayList<StopInfo> listItem) {
		try {
			JSONObject json = new JSONObject(JSON);
			JSONObject info = json.getJSONObject("info");
			int status = info.getInt("status_code");

			if (status == 1) {
				JSONArray resultArray = json.getJSONArray("result");

				for (int i = 0; i < resultArray.length(); i++) {
					JSONObject route = resultArray.getJSONObject(i);
					listItem.add(StopInfo.createFromJSON(route.toString()));
				}
			}


		} catch (Exception ex) {
			ex.printStackTrace();
		}

	}

}
