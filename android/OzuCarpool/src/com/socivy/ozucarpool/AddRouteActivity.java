package com.socivy.ozucarpool;

import java.util.ArrayList;

import org.json.JSONArray;
import org.json.JSONObject;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.RadioButton;
import android.widget.TimePicker;
import android.widget.Toast;

public class AddRouteActivity extends Activity {


	private int hour;
	private int min;
	private ArrayList<Integer> stopList;

	private TimePicker.OnTimeChangedListener mTimePickerListener=new TimePicker.OnTimeChangedListener(){
		public void onTimeChanged(TimePicker timePicker, int hourOfDay, int minute){
			hour = hourOfDay;
			min = minute;

		}
	};

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_add_route);
		stopList = new ArrayList<Integer>();
		TimePicker picker = (TimePicker) findViewById(R.id.timePicker1);
		picker.setIs24HourView(true);
		picker.setOnTimeChangedListener(mTimePickerListener);

		Button myButton = (Button) findViewById(R.id.button1);

		myButton.setOnClickListener(new View.OnClickListener() {

			@Override
			public void onClick(View v) {

				Intent intent = new Intent(v.getContext(), AddRouteMapActivity.class);
				startActivityForResult(intent, 0);
			}
		});

		Button setoffButton = (Button) findViewById(R.id.buttonsetoff);
		setoffButton.setOnClickListener(new View.OnClickListener() {

			@Override
			public void onClick(View v) {
				RadioButton toStop = (RadioButton) findViewById(R.id.radioButton1);
				RadioButton today = (RadioButton) findViewById(R.id.radioButton3);
				EditText desc = (EditText) findViewById(R.id.editText1);

				try {
					JSONObject postJson = new JSONObject();
					postJson.accumulate("plan", (toStop.isChecked() ? "fromSchool" : "toSchool"));
					postJson.accumulate("action_day", (today.isChecked() ? 0 : 1));
					postJson.accumulate("action_hour", hour);
					postJson.accumulate("action_minute", min);
					postJson.accumulate("available_seat", 4);
					postJson.accumulate("description", desc.getText());

					JSONArray stopsArray = new JSONArray();
					for (int stopId : stopList) {
						stopsArray.put(new JSONObject().accumulate("id", stopId));
					}
					postJson.accumulate("points", stopsArray);


					new ContextTask<String, Void, String>(AddRouteActivity.this) {

						@Override
						protected void onPostExecute(String result) {
							try {
								JSONObject json = new JSONObject(result);
								System.out.println(json.toString());
								JSONObject info = json.getJSONObject("info");
								int error = info.getInt("error_code");
								
								if (error == 0) {
									Toast.makeText(context, "Route added", Toast.LENGTH_LONG).show();
									finish();
								} 
								else {
									Toast.makeText(context, "Some problem occured", Toast.LENGTH_LONG).show();
								}
							} catch(Exception ex) {
								Toast.makeText(context, "Some problem occured", Toast.LENGTH_LONG).show();
							}
							super.onPostExecute(result);
						}

						@Override
						protected String doInBackground(String... token) {
							try {
								return HttpPoster.postJSON("http://development.socivy.com/api/v1/route", context, token[0]);
							} catch (Exception e) {
								return e.toString();
							}
						}
					}.execute(postJson.toString());

				} catch(Exception ex) {
					ex.printStackTrace();
				}
			}
		});
	}

	@Override
	public void onActivityResult(int requestCode, int resultCode, Intent data) {
		super.onActivityResult(requestCode, resultCode, data);

		if(requestCode == 0) {
			if(resultCode == Activity.RESULT_OK) {
				stopList.clear();
				int[] stops = data.getIntArrayExtra("stops");
				if (stops != null) {
					for (int i : stops) {
						stopList.add(i);
					}
				}
			}
		}
	}

	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		// Inflate the menu; this adds items to the action bar if it is present.
		//getMenuInflater().inflate(R.menu.add_route, menu);
		return false;
	}

	@Override
	public boolean onOptionsItemSelected(MenuItem item) {
		// Handle action bar item clicks here. The action bar will
		// automatically handle clicks on the Home/Up button, so long
		// as you specify a parent activity in AndroidManifest.xml.
		int id = item.getItemId();
		if (id == R.id.action_settings) {
			return true;
		}
		return super.onOptionsItemSelected(item);
	}
}
