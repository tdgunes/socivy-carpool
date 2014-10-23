package com.socivy.ozucarpool;

import org.json.JSONException;
import org.json.JSONObject;

public class ParticipantInfo {

	public int id;
	public String name;
	public String phone;
	public String email;
	public boolean showPhone;

	public ParticipantInfo() {

	}

	public static ParticipantInfo createFromJSON(String json) {
		ParticipantInfo listItem = new ParticipantInfo();

		try {
			JSONObject jObject = new JSONObject(json);
			listItem.id = Integer.parseInt(jObject.getString("id"));
			listItem.name = jObject.getString("name");
			listItem.email = jObject.getString("email");
			JSONObject info = jObject.getJSONObject("information");
			listItem.showPhone = info.getBoolean("showPhone");
			if (listItem.showPhone)
				listItem.phone = info.getString("phone");

		} catch (JSONException e) {
			e.printStackTrace();
		}
		return listItem;
	}
}
