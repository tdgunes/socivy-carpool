package com.socivy.ozucarpool;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;

import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.StringEntity;
import org.json.JSONObject;

import android.content.Context;

public class ExpiredAuthenticator {
	public ExpiredAuthenticator() {
	}


	public boolean tryLogin(Context context) {
		try {
			HttpClient httpclient = HttpPoster.getNewHttpClient();

			HttpPost httppost = new HttpPost(AppCredintals.BASE_LINK+"/api/v1/login");
			httppost.setHeader("Accept", "application/json");
			httppost.setHeader("Content-type", "application/json");
			StringEntity se = new StringEntity("{\"user_secret\":\""+AppCredintals.getUserSecret(context)+"\"}");
			httppost.setEntity(se);


			HttpResponse response = httpclient.execute(httppost);

			HttpEntity entity = response.getEntity();
			InputStream content = entity.getContent();
			StringBuilder builder = new StringBuilder();
			BufferedReader reader = new BufferedReader(new InputStreamReader(content));
			String line;
			while((line = reader.readLine()) != null){
				builder.append(line);
			}

			String result = builder.toString();

			JSONObject jObject = new JSONObject(result);
			JSONObject status = jObject.getJSONObject("info");
			int resultStr = status.getInt("status_code");
			System.out.println("success1\n"+AppCredintals.getUserSecret(context)+"\n"+result);
			if (resultStr == 1) {
				JSONObject resultObject = jObject.getJSONObject("result");
				AppCredintals.accessToken = resultObject.getString("access_token");
				AppCredintals.expireTime = Long.parseLong(resultObject.getString("expire_time"));
				AppCredintals.getPrefs(context).edit().putString("accessToken", resultObject.getString("access_token")).putLong("expireTime", AppCredintals.expireTime).commit();
				
                AppCredintals.sendRegistrationIdToBackend(context);
                System.out.println("success2");
				return true;
			}

			return false;
		} catch (Exception ex) {
			ex.printStackTrace();
			return false;
		}	
	}

}