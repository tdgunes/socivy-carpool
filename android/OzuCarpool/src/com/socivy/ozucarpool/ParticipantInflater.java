package com.socivy.ozucarpool;
import java.util.ArrayList;

import org.json.JSONArray;
import org.json.JSONObject;

public class ParticipantInflater {
	String JSON;

	public ParticipantInflater(String json) {
		this.JSON = json;
	}

	public void inflate(ArrayList<ParticipantInfo> listItem) {
		try {
			JSONObject json = new JSONObject(JSON);
			JSONObject info = json.getJSONObject("info");
			int status = info.getInt("status_code");

			if (status == 1) {
				JSONArray resultArray = json.getJSONArray("result");

				for (int i = 0; i < resultArray.length(); i++) {
					JSONObject route = resultArray.getJSONObject(i);
					listItem.add(ParticipantInfo.createFromJSON(route.toString()));
				}
			}


		} catch (Exception ex) {
			ex.printStackTrace();
		}

	}

}
