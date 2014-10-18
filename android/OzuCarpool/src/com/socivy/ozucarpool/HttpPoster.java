package com.socivy.ozucarpool;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.security.KeyStore;

import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.HttpVersion;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.conn.ClientConnectionManager;
import org.apache.http.conn.scheme.PlainSocketFactory;
import org.apache.http.conn.scheme.Scheme;
import org.apache.http.conn.scheme.SchemeRegistry;
import org.apache.http.conn.ssl.SSLSocketFactory;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.impl.conn.tsccm.ThreadSafeClientConnManager;
import org.apache.http.params.BasicHttpParams;
import org.apache.http.params.HttpParams;
import org.apache.http.params.HttpProtocolParams;
import org.apache.http.protocol.HTTP;
import org.json.JSONObject;

import android.content.Context;

public class HttpPoster {
	public static String accessToken;

	public HttpPoster(Context current) {
	}

	public static HttpClient getNewHttpClient() {
		try {
			KeyStore trustStore = KeyStore.getInstance(KeyStore
					.getDefaultType());
			trustStore.load(null, null);

			SSLSocketFactory sf = new OzuSSLSocketFactory(trustStore);
			sf.setHostnameVerifier(SSLSocketFactory.ALLOW_ALL_HOSTNAME_VERIFIER);

			HttpParams params = new BasicHttpParams();
			HttpProtocolParams.setVersion(params, HttpVersion.HTTP_1_1);
			HttpProtocolParams.setContentCharset(params, HTTP.UTF_8);

			SchemeRegistry registry = new SchemeRegistry();
			registry.register(new Scheme("http", PlainSocketFactory.getSocketFactory(), 80));
			registry.register(new Scheme("https", sf, 443));

			ClientConnectionManager ccm = new ThreadSafeClientConnManager(
					params, registry);

			return new DefaultHttpClient(ccm, params);
		} catch (Exception e) {
			return new DefaultHttpClient();
		}
	}


	public static String getJSON(String address, Context context) throws Exception{
		StringBuilder builder = new StringBuilder();
		HttpClient client = new DefaultHttpClient();
		HttpGet httpGet = new HttpGet(address);
		httpGet.addHeader("Access-token", AppCredintals.getAccessToken(context));
		HttpResponse response = client.execute(httpGet);
		/*StatusLine statusLine = response.getStatusLine();
		int statusCode = statusLine.getStatusCode();*/
		HttpEntity entity = response.getEntity();
		InputStream content = entity.getContent();
		BufferedReader reader = new BufferedReader(new InputStreamReader(content));
		String line;
		while((line = reader.readLine()) != null){
			builder.append(line);
		}

		JSONObject json = new JSONObject(builder.toString());
		JSONObject info = json.getJSONObject("info");
		int error = info.getInt("error_code");
		if (error == 4 || error == 3) { //expire olduysak bi daha baðlan ve tekrar çaðýr
			new ExpiredAuthenticator().tryLogin(context);
			return getJSON(address, context);
		}


		return builder.toString();
	}

	public static String postJSON(String address, Context context, String jsonData) throws Exception{
		StringBuilder builder = new StringBuilder();
		HttpClient client = new DefaultHttpClient();
		HttpPost httpPost = new HttpPost(address);
		httpPost.addHeader("Access-token", AppCredintals.getAccessToken(context));
		httpPost.setHeader("Accept", "application/json");
		httpPost.addHeader("Content-type", "application/json");
		StringEntity sendEntity = new StringEntity(jsonData);
		httpPost.setEntity(sendEntity);

		HttpResponse response = client.execute(httpPost);
		/*StatusLine statusLine = response.getStatusLine();
		int statusCode = statusLine.getStatusCode();*/
		HttpEntity entity = response.getEntity();
		InputStream content = entity.getContent();
		BufferedReader reader = new BufferedReader(new InputStreamReader(content));
		String line;
		while((line = reader.readLine()) != null){
			builder.append(line);
		}

		JSONObject json = new JSONObject(builder.toString());
		System.out.println(json.toString());
		JSONObject info = json.getJSONObject("info");
		int error = info.getInt("error_code");
		if (error == 4 || error == 3) { //expire olduysak bi daha baðlan ve tekrar çaðýr
			new ExpiredAuthenticator().tryLogin(context);
			return postJSON(address, context, jsonData);
		}

		return builder.toString();
	}


}