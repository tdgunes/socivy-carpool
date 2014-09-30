package com.example.ozucarpool;

import android.support.v7.app.ActionBarActivity;
import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.Button;
import android.widget.TimePicker;

public class AddRouteActivity extends Activity {

	
	private static final int TIME_PICKER_INTERVAL=15;
	private boolean mIgnoreEvent=false;

	private TimePicker.OnTimeChangedListener mTimePickerListener=new TimePicker.OnTimeChangedListener(){
	    public void onTimeChanged(TimePicker timePicker, int hourOfDay, int minute){

            timePicker.setCurrentHour(hourOfDay);
            
	        if (mIgnoreEvent)
	            return;
	        if (minute%TIME_PICKER_INTERVAL!=0){
	            int minuteFloor=minute-(minute%TIME_PICKER_INTERVAL);
	            minute=minuteFloor + (minute==minuteFloor+1 ? TIME_PICKER_INTERVAL : 0);
	            if (minute==60)
	                minute=0;
	            mIgnoreEvent=true;
	            timePicker.setCurrentMinute(minute);
	            mIgnoreEvent=false;
	        }

	    }
	};
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_add_route);
		TimePicker picker = (TimePicker) findViewById(R.id.timePicker1);
		picker.setIs24HourView(true);
		//picker.setOnTimeChangedListener(mTimePickerListener);
		
		Button myButton = (Button) findViewById(R.id.button1);

		myButton.setOnClickListener(new View.OnClickListener() {

			@Override
			public void onClick(View v) {

				Intent intent = new Intent(v.getContext(), AddRouteMapActivity.class);
				startActivity(intent);
			}
		});
	}

	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		// Inflate the menu; this adds items to the action bar if it is present.
		getMenuInflater().inflate(R.menu.add_route, menu);
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
