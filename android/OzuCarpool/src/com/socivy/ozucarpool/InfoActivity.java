package com.socivy.ozucarpool;

import java.util.ArrayList;
import java.util.concurrent.ExecutionException;

import org.json.JSONObject;

import android.app.AlertDialog;
import android.content.DialogInterface;
import android.graphics.Typeface;
import android.os.Bundle;
import android.support.v7.app.ActionBarActivity;
import android.text.Html;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.ListView;
import android.widget.TextView;

import com.google.android.gms.maps.GoogleMap;

public class InfoActivity extends ActionBarActivity {
	public GoogleMap map;
	public ArrayList<String> listItem= new ArrayList<String>();
	public Typeface font;
	public RouteInfo info;
	private int id;
	private ArrayAdapter<String> adapter;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_info);
		
		getSupportActionBar().hide();
		font = Typeface.createFromAsset( getAssets(), "fontawesome-webfont.ttf" );

		Bundle bundle = getIntent().getExtras();
		if (bundle != null) {
			id = bundle.getInt("routeid");
		}

		ListView list = (ListView) findViewById(R.id.stoplist);

		adapter = new ArrayAdapter<String>(this,
				R.layout.info_list_item, R.id.actress_name, listItem)  {
			@Override
			public View getView(int position, View convertView, ViewGroup parent) 
			{
				View row;
				LayoutInflater mInflater = getLayoutInflater();

				if (null == convertView) {
					row = mInflater.inflate(R.layout.info_list_item, parent, false);
				} else {
					row = convertView;
				}
		
				TextView tv = (TextView) row.findViewById(R.id.actress_name);
				//tv.setTypeface(font);
				tv.setText(Html.fromHtml(getItem(position)));

				return row;
			}

		};


		list.setAdapter(adapter);		
		getRoutes();

		adapter.notifyDataSetChanged();

		/*map = (GoogleMap) ((SupportMapFragment) getSupportFragmentManager().findFragmentById(R.id.map)).getMap();
		map.addMarker(new MarkerOptions()
        .position(new LatLng(10, 10))
        .title("Hello world"));*/
	}
	
	
	private void getRoutes() {
		try {
			
			new ContextTask<String, Void, String>(this) {

				@Override
				protected void onPostExecute(String result) {
					try {
						JSONObject res = new JSONObject(result);
						populate(res.getString("result").toString());
					} catch (Exception e) {
						e.printStackTrace();
						new AlertDialog.Builder(getApplicationContext())
					    .setTitle("Error")
					    .setMessage(result)
					    .setPositiveButton(android.R.string.yes, new DialogInterface.OnClickListener() {
					        public void onClick(DialogInterface dialog, int which) { 
					            // continue with delete
					        }
					     })
					    .setIcon(android.R.drawable.ic_dialog_alert)
					     .show();
					}
					
					super.onPostExecute(result);
				}
				
				@Override
				protected String doInBackground(String... token) {
					try {
					return HttpPoster.getJSON("http://development.socivy.com/api/v1/route/"+id, context);
					} catch (Exception e) {
						return e.toString();
					}
				}
			}.execute(AppCredintals.getAccessToken(this)).get();
		} catch (InterruptedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (ExecutionException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	public void populate(String json) {
		info = RouteInfo.createFromJSON(json);
		for (String name : info.stops) {
			listItem.add(name);
		}
		
		TextView direction = (TextView) findViewById(R.id.textView1);
		direction.setTypeface(font);
		
		if (info.toSchool)
			direction.setText(Html.fromHtml("&#xf024; &#xf178; &#xf19c;"));
		else 
			direction.setText(Html.fromHtml("&#xf19c; &#xf178; &#xf024;"));

		TextView time = (TextView) findViewById(R.id.textView2);
		time.setTypeface(font);
		time.setText(Html.fromHtml("&#xf017; " + info.time.format("%H:%M")));

		TextView seats = (TextView) findViewById(R.id.textView3);
		seats.setTypeface(font);
		seats.setText(Html.fromHtml("&#xf1ae; " + info.seats));

		TextView driver = (TextView) findViewById(R.id.textView4);
		driver.setTypeface(font);
		driver.setText(Html.fromHtml("&#xf1b9; "));
		
		TextView driverName = (TextView) findViewById(R.id.textView6);
		driverName.setText(Html.fromHtml(info.driver));

		TextView desc = (TextView) findViewById(R.id.textView5);
		desc.setTypeface(font);
		desc.setText(Html.fromHtml("&#xf0a1; "));
		
		TextView desctext = (TextView) findViewById(R.id.textView7);
		desctext.setText(Html.fromHtml(info.description));
		
	}
}
