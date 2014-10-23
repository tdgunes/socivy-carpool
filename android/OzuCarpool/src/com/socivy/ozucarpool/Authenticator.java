package com.socivy.ozucarpool;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;

import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.StringEntity;
import org.json.JSONArray;
import org.json.JSONObject;

import android.app.Activity;
import android.app.ProgressDialog;
import android.content.Context;
import android.content.Intent;
import android.os.AsyncTask;
import android.widget.Toast;

public class Authenticator extends AsyncTask<String, String, String> {
	private ProgressDialog progressDialog;
	private Context current;
	public Authenticator(Context current) {
		this.current = current;
	}

	@Override
	protected void onPreExecute() {
		super.onPreExecute();
		progressDialog = new ProgressDialog(current);
		progressDialog.setCancelable(false);
		progressDialog.setMessage("Signing in!");
		progressDialog.show();
	}

	@Override
	protected void onPostExecute(String result) {
		progressDialog.dismiss();
		
		try {
			JSONObject jObject = new JSONObject(result);
			JSONObject status = jObject.getJSONObject("info");
			int resultStr = status.getInt("status_code");

			if (resultStr == 1) {
				JSONObject resultObject = jObject.getJSONObject("result");
				AppCredintals.accessToken = resultObject.getString("access_token");
				AppCredintals.userSecret = resultObject.getString("user_secret");
				AppCredintals.expireTime = Long.parseLong(resultObject.getString("expire_time"));
				
				
				Intent intent = new Intent(current, UserActivity.class);
				intent.putExtra("accessToken", AppCredintals.accessToken);
				intent.putExtra("userSecret", AppCredintals.userSecret);
				AppCredintals.getPrefs(current).edit().putString("accessToken", resultObject.getString("access_token")).putString("userSecret", resultObject.getString("user_secret")).commit();

				System.out.println("token: "+ AppCredintals.getUserSecret(current));
				current.startActivity(intent);
				((Activity)current).finish();
			}
			else {
				Toast.makeText(current, "Login failed, check your credintals", Toast.LENGTH_LONG).show();
				//JSONArray jArray = status.getJSONArray("errors");
				//System.out.println(jArray.toString());
			}
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		
		
		super.onPostExecute(result);
	}


	@Override
	protected String doInBackground(String... params) {
		try {
			HttpClient httpclient = HttpPoster.getNewHttpClient();
			
			String user = params[0];
			String pass = params[1];

			HttpPost httppost = new HttpPost(AppCredintals.BASE_LINK+"/api/v1/authenticate");
			httppost.setHeader("Accept", "application/json");
		    httppost.setHeader("Content-type", "application/json");
		    StringEntity se = new StringEntity("{\"email\":\""+user+"\", \"password\":\""+pass+"\", \"public_key\":\""+AppCredintals.publicKey+"\"}");
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
			
			

			return builder.toString();

		} catch (Exception ex) {
			ex.printStackTrace();
			return ex.toString();
		}	
	}

}
