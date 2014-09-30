package com.example.ozucarpool;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.zip.Inflater;

import com.example.ozucarpool.R;

import android.view.ViewGroup;
import android.graphics.Typeface;
import android.os.Bundle;
import android.support.v7.app.ActionBarActivity;
import android.text.Html;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.ArrayAdapter;
import android.widget.ListView;
import android.widget.TextView;

import com.google.android.gms.maps.GoogleMap;
import com.google.android.gms.maps.SupportMapFragment;
import com.google.android.gms.maps.model.LatLng;
import com.google.android.gms.maps.model.MarkerOptions;

public class InfoActivity extends ActionBarActivity {
	public GoogleMap map;
	public ArrayList<String> listItem= new ArrayList<String>();
	public Typeface font;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_info);
		getSupportActionBar().hide();
		font = Typeface.createFromAsset( getAssets(), "fontawesome-webfont.ttf" );

		TextView direction = (TextView) findViewById(R.id.textView1);
		direction.setTypeface(font);
		direction.setText(Html.fromHtml("&#xf024; &#xf178; &#xf19c;"));

		TextView time = (TextView) findViewById(R.id.textView2);
		time.setTypeface(font);
		time.setText(Html.fromHtml("&#xf017; 10:45"));

		TextView seats = (TextView) findViewById(R.id.textView3);
		seats.setTypeface(font);
		seats.setText(Html.fromHtml("&#xf1ae; 4"));

		TextView driver = (TextView) findViewById(R.id.textView4);
		driver.setTypeface(font);
		driver.setText(Html.fromHtml("&#xf1b9; "));
		
		TextView driverName = (TextView) findViewById(R.id.textView6);
		driverName.setText(Html.fromHtml("Hakan Peker"));

		TextView desc = (TextView) findViewById(R.id.textView5);
		desc.setTypeface(font);
		desc.setText(Html.fromHtml("&#xf0a1; "));
		
		TextView desctext = (TextView) findViewById(R.id.textView7);
		desctext.setText(Html.fromHtml("Arkadaþlar bir kahve ýsmarlarsanýz fena olmaz ;)"));

		ListView list = (ListView) findViewById(R.id.stoplist);

		ArrayAdapter<String> adapter = new ArrayAdapter<String>(this,
				R.layout.info_list_item, R.id.actress_name, listItem)  {
			@Override
			public View getView(int position, View convertView, ViewGroup parent) 
			{
				View row;
				LayoutInflater mInflater = getLayoutInflater();

				if (null == convertView) {
					row = mInflater.inflate(R.layout.info_list_item, null);
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


		listItem.add("Özü");
		listItem.add("Taþdelen");
		listItem.add("Altunizade");
		listItem.add("Kadýköy");
		adapter.notifyDataSetChanged();

		map = (GoogleMap) ((SupportMapFragment) getSupportFragmentManager().findFragmentById(R.id.map)).getMap();
		map.addMarker(new MarkerOptions()
        .position(new LatLng(10, 10))
        .title("Hello world"));
	}
}
