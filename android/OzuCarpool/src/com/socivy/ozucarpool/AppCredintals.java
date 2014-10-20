package com.socivy.ozucarpool;

import java.io.IOException;

import org.json.JSONException;
import org.json.JSONObject;

import android.app.Activity;
import android.content.Context;
import android.content.SharedPreferences;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager.NameNotFoundException;
import android.util.Log;

import com.google.android.gms.common.ConnectionResult;
import com.google.android.gms.common.GooglePlayServicesUtil;
import com.google.android.gms.gcm.GoogleCloudMessaging;

public class AppCredintals {


	public static String accessToken;
	public static String userSecret;
	public static long expireTime;
	public static String publicKey = "$2y$10$22MijpDxi5wipiKoZaN/6eaUeBeA9pd82tlijnuGNawXZoWPcXqJS";
	public static String SENDER_ID = "1015246128884"; 
	public static final String EXTRA_MESSAGE = "message";
	public static final String PROPERTY_REG_ID = "registration_id";
	public static final String PROPERTY_APP_VERSION = "appVersion";


	public static void createFromJSON(String json) {
		try {
			JSONObject jObject = new JSONObject(json);
			JSONObject status = jObject.getJSONObject("info");
			int result = status.getInt("status_code");

			if (result == 1) {
				JSONObject resultObject = jObject.getJSONObject("result");
				accessToken = resultObject.getString("access_token");
				userSecret = resultObject.getString("user_secret");
				expireTime = resultObject.getInt("expire_time");
			}


		} catch (JSONException e) {
			e.printStackTrace();
		}
	}


	public static SharedPreferences getPrefs(Context context) {
		return context.getSharedPreferences("socivysettings", 0);
	}

	public static String getAccessToken(Context context) {
		return getPrefs(context).getString("accessToken", " ");
	}


	public static String getUserSecret(Context context) {

		return getPrefs(context).getString("userSecret", " ");
	}


	public static void sendRegistrationIdToBackend(Context context) {
		// Your implementation here.
		try {
			JSONObject postJson = new JSONObject();
			postJson.accumulate("device_token", getRegistrationId(context));
			postJson.accumulate("device_type", "android");
			HttpPoster.postJSON("http://development.socivy.com/api/v1/device", context, postJson.toString());


		} catch(Exception ex) {
			ex.printStackTrace();
		}
	}

	public static void storeRegistrationId(Context context, String regId) {
		final SharedPreferences prefs = getGCMPreferences(context);
		int appVersion = getAppVersion(context);
		Log.i("hata", "Saving regId on app version " + appVersion);
		SharedPreferences.Editor editor = prefs.edit();
		editor.putString(PROPERTY_REG_ID, regId);
		editor.putInt(PROPERTY_APP_VERSION, appVersion);
		editor.commit();
	}

	public static int getAppVersion(Context context) {
		try {
			PackageInfo packageInfo = context.getPackageManager()
					.getPackageInfo(context.getPackageName(), 0);
			return packageInfo.versionCode;
		} catch (NameNotFoundException e) {
			// should never happen
			throw new RuntimeException("Could not get package name: " + e);
		}
	}


	public static SharedPreferences getGCMPreferences(Context context) {
		return getPrefs(context); //context.getSharedPreferences(UserActivity.class.getSimpleName(),Context.MODE_PRIVATE);
	}

	public static void registerInBackground(Context context) {

		String msg;
		try {
			GoogleCloudMessaging gcm = GoogleCloudMessaging.getInstance(context);
			
			String regid = gcm.register(AppCredintals.SENDER_ID);
			msg = "Device registered, registration ID=" + regid;
			AppCredintals.sendRegistrationIdToBackend(context);
			AppCredintals.storeRegistrationId(context, regid);
		} catch (IOException ex) {
			msg = "Error :" + ex.getMessage();
		}
		
		Log.i("HATA", "GCM'ye kayit olunamadi.\n"+msg);

	}

	public static boolean checkPlayServices(Context context) {
		int resultCode = GooglePlayServicesUtil.isGooglePlayServicesAvailable(context);
		if (resultCode != ConnectionResult.SUCCESS) {
			if (GooglePlayServicesUtil.isUserRecoverableError(resultCode)) {
				GooglePlayServicesUtil.getErrorDialog(resultCode, (Activity) context,
						9000).show();
			} else {
				Log.i("hata", "This device is not supported.");
				((Activity) context).finish();
			}
			return false;
		}
		return true;
	}

	public static String getRegistrationId(Context context) {
		final SharedPreferences prefs = getGCMPreferences(context);
		String registrationId = prefs.getString(PROPERTY_REG_ID, " ");
		if (registrationId.equals(" ")) {
			Log.i("hata", "Registration not found.");
			return " ";
		}


		int registeredVersion = prefs.getInt(PROPERTY_APP_VERSION, Integer.MIN_VALUE);
		int currentVersion = getAppVersion(context);
		if (registeredVersion != currentVersion) {
			Log.i("hata", "App version changed.");
			return " ";
		}
		return registrationId;
	}

}
