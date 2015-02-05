package com.socivy.ozucarpool;

import org.json.JSONException;
import org.json.JSONObject;

import android.app.Activity;
import android.app.ProgressDialog;
import android.content.Intent;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.CheckBox;
import android.widget.EditText;
import android.widget.TextView;
import android.widget.Toast;


public class SettingsFragment extends Fragment {

	private View rootView;
	public static SettingsFragment newInstance() {
		SettingsFragment fragment = new SettingsFragment();

		return fragment;
	}

	public SettingsFragment() {
	}

	@Override
	public View onCreateView(LayoutInflater inflater, ViewGroup container,
			Bundle savedInstanceState) {

		rootView = inflater.inflate(R.layout.fragment_settings, container,
				false);
		
		Button update = (Button) rootView.findViewById(R.id.updatebutton);
		update.setOnClickListener(new View.OnClickListener() {

			@Override
			public void onClick(View v) {
				updateSettings();
			}
		});

		Button signout = (Button) rootView.findViewById(R.id.signoutbutton);
		signout.setOnClickListener(new View.OnClickListener() {

			@Override
			public void onClick(View v) {


				signOut();
			}
		});

		return rootView;
	}
	
	@Override
	public void onResume(){
		super.onResume();
		getSettings();
	}
	
	private void getSettings() {
		rootView.findViewById(R.id.progressBar3).setVisibility(View.VISIBLE);
		new ContextTask<String, Void, String>(getActivity()) {

			@Override
			protected void onPostExecute(String result) {
				System.out.println(result);
				try {
					JSONObject obj = new JSONObject(result);
					JSONObject json = obj.getJSONObject("result");
					System.out.println(json);
					String email = json.getString("email");
					String name = json.getString("name");
					
					JSONObject info = json.getJSONObject("information");
					String phone = info.getString("phone");
					
					JSONObject settings = json.getJSONObject("route_settings");
					String showphone = settings.getString("show_phone");
					
					
					((EditText) rootView.findViewById(R.id.editname)).setText(name);
					//((EditText) rootView.findViewById(R.id.editmail)).setText(email);
					((EditText) rootView.findViewById(R.id.edittel)).setText(phone);
					
					if (showphone.equals("1"))
						((CheckBox) rootView.findViewById(R.id.checktel)).setChecked(true);
					else
						((CheckBox) rootView.findViewById(R.id.checktel)).setChecked(false);
				} catch (JSONException e) {
					e.printStackTrace();
				}
				
				rootView.findViewById(R.id.progressBar3).setVisibility(View.GONE);
				super.onPostExecute(result);
			}

			@Override
			protected String doInBackground(String... token) {
				try {
					return HttpPoster.getJSON(AppCredintals.BASE_LINK+"/api/v1/me/setting", context);
				} catch (Exception e) {
					return e.toString();
				}
			}
		}.execute();
	}
	
	private void updateSettings() {
		final ProgressDialog progressDialog = new ProgressDialog(getActivity());
		progressDialog.setCancelable(false);
		progressDialog.setMessage("Updating!");
		progressDialog.show();
		
		
		
		String name = ((EditText) rootView.findViewById(R.id.editname)).getText().toString();
		String pass = ((EditText) rootView.findViewById(R.id.editpass)).getText().toString();
		String pass2 = ((EditText) rootView.findViewById(R.id.editpass2)).getText().toString();
		String phone = ((EditText) rootView.findViewById(R.id.edittel)).getText().toString();
	
		boolean checked = ((CheckBox) rootView.findViewById(R.id.checktel)).isChecked();
		

		JSONObject json = new JSONObject();
		JSONObject info = new JSONObject();
		JSONObject settings = new JSONObject();
		
		try {
			json.accumulate("name", name);
			if (!pass.equals(pass2)) {
				progressDialog.dismiss();
				Toast.makeText(getActivity(), "Passwords fields don\'t match", Toast.LENGTH_LONG).show();
				return;
			} 
			else {
				if (pass.length() > 1) {
					json.accumulate("password", pass);
				}
			}
			
			info.accumulate("phone", phone);
			settings.accumulate("show_phone", (checked) ? true: false);
			json.accumulate("information", info);
			json.accumulate("route_settings", settings);
			
		} catch (JSONException e1) {
			e1.printStackTrace();
		}
		
		
		
		new ContextTask<String, Void, String>(getActivity()) {

			@Override
			protected void onPostExecute(String result) {
				progressDialog.dismiss();
				super.onPostExecute(result);
			}

			@Override
			protected String doInBackground(String... token) {
				try {
					return HttpPoster.postJSON(AppCredintals.BASE_LINK+"/api/v1/me/setting", context, token[0]);
				} catch (Exception e) {
					return e.toString();
				}
			}
		}.execute(json.toString());
	}

	private void signOut() {
		final ProgressDialog progressDialog = new ProgressDialog(getActivity());
		progressDialog.setCancelable(false);
		progressDialog.setMessage("Signing out!");
		progressDialog.show();

		new ContextTask<String, Void, Boolean>(getActivity()) {

			@Override
			protected void onPostExecute(Boolean result) {
				super.onPostExecute(result);
				progressDialog.dismiss();
				if (result == true) {
					AppCredintals.getPrefs(context).edit().putString("userSecret", " ").commit();
					Intent intent = new Intent(context, MainActivity.class);
					context.startActivity(intent);
					((Activity)context).finish();
				}
			}

			@Override
			protected Boolean doInBackground(String... token) {
				try {

					JSONObject json = new JSONObject(HttpPoster.getJSON(AppCredintals.BASE_LINK+"/api/v1/logout", context));
					JSONObject info = json.getJSONObject("info");
					int status = info.getInt("status_code");
					if (status == 1)
						return true;
					else 
						return false;
				} catch (Exception e) {
					return false;
				}
			}
		}.execute();
	}
}