package com.socivy.ozucarpool;

import org.json.JSONException;
import org.json.JSONObject;

import android.app.Activity;
import android.app.ProgressDialog;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Toast;

public class RegisterActivity extends Activity {

	private ProgressDialog progressDialog;


	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_register);

		progressDialog = new ProgressDialog(this);
		progressDialog.setCancelable(false);
		progressDialog.setMessage("Registering!");

		Button register = (Button) findViewById(R.id.buttonregister);
		register.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {
				register();
			}
		});

	}


	private void register() {
		String name = ((EditText) findViewById(R.id.editname)).getText().toString();
		String email = ((EditText) findViewById(R.id.editemail)).getText().toString();
		String pass = ((EditText) findViewById(R.id.editpass)).getText().toString();
		String pass2 = ((EditText) findViewById(R.id.editpass2)).getText().toString();
		String phone = ((EditText) findViewById(R.id.edittel)).getText().toString();

		if (!pass.equals(pass2)) {
			Toast.makeText(this, "Passwords don\'t match", Toast.LENGTH_LONG).show();
			return;
		}

		if (pass.length() < 6) {
			Toast.makeText(this, "Password must be at least 6 characters", Toast.LENGTH_LONG).show();
			return;
		}


		JSONObject json = new JSONObject();

		try {
			json.accumulate("name", name);
			json.accumulate("email", email);
			json.accumulate("password", pass);
			json.accumulate("phone", phone);
			json.accumulate("public_key", AppCredintals.publicKey);	
		} catch (JSONException e1) {
			e1.printStackTrace();
			return;
		}


		progressDialog.show();



		new ContextTask<String, Void, String>(this) {

			@Override
			protected void onPostExecute(String result) {
				super.onPostExecute(result);
				progressDialog.dismiss();

				try {
					JSONObject json = new JSONObject(result);
					System.out.println(json.toString());
					JSONObject info = json.getJSONObject("info");

					int status = info.getInt("status_code");
					if (status==0) {
						Toast.makeText(context, "Failed to register, check your credintals", Toast.LENGTH_LONG).show();
						return;
					}
				} catch(Exception e) {
					Toast.makeText(context, "Failed to register, check your credintals", Toast.LENGTH_LONG).show();
					return;
				}

				Toast.makeText(context, "Register successful", Toast.LENGTH_LONG).show();
				((Activity) context).finish();

			}

			@Override
			protected String doInBackground(String... token) {
				try {
					return HttpPoster.postJSON(AppCredintals.BASE_LINK+"/api/v1/register", context, token[0]);
				} catch (Exception e) {
					return "error";
				}
			}
		}.execute(json.toString());
	}
}
