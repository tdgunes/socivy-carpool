package com.socivy.ozucarpool;

import java.util.ArrayList;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.os.Parcel;
import android.os.Parcelable;
import android.text.format.Time;

public class RouteInfo implements Parcelable{
	public int id;
	public String driver;
	public ArrayList<String> stops;
	public ArrayList<ParticipantInfo> comps;
	public Time time;
	public int seats;
	public boolean toSchool;
	public String description;
	public boolean joined;

	public String jsonData;

	public RouteInfo() {
		stops = new ArrayList<String>();
		comps = new ArrayList<ParticipantInfo>();
	}

	public static RouteInfo createFromJSON(String json) throws JSONException {
		RouteInfo listItem = new RouteInfo();
		listItem.jsonData = json;

		JSONObject jObject = new JSONObject(json);
		listItem.id = Integer.parseInt(jObject.getString("id"));
		listItem.driver = jObject.getJSONObject("user").getString("name");
		listItem.seats = jObject.getInt("seats");
		listItem.toSchool = jObject.getString("plan").equals("toSchool") ? true : false;
		listItem.description = jObject.getString("description");
		Time time = new Time();
		time.set(Long.parseLong(jObject.getString("action_time"))*1000);
		//time.setToNow(); //set(0, jObject.getInt("minute"), jObject.getInt("hour"), jObject.getInt("day"), jObject.getInt("month"), jObject.getInt("year"));
		listItem.time = time;

		JSONArray jArray = jObject.getJSONArray("places");
		for (int i = 0; i < jArray.length(); i++) {
			JSONObject stop = jArray.getJSONObject(i);
			listItem.stops.add(stop.getString("name"));
		}

		JSONArray companions = jObject.getJSONArray("companions");
		for (int i = 0; i < companions.length(); i++) {
			JSONObject companion = companions.getJSONObject(i);
			listItem.comps.add(ParticipantInfo.createFromJSON(companion.toString()));
		}


		return listItem;
	}

	@Override
	public int describeContents() {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public void writeToParcel(Parcel dest, int flags) {
		// TODO Auto-generated method stub

	}

}