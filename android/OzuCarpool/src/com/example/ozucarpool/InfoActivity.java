package com.example.ozucarpool;

import com.example.ozucarpool.R;
import android.os.Bundle;
import android.support.v7.app.ActionBarActivity;

import com.google.android.gms.maps.GoogleMap;
import com.google.android.gms.maps.SupportMapFragment;

public class InfoActivity extends ActionBarActivity {
	public GoogleMap map;
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_info);
		

	    map = (GoogleMap) ((SupportMapFragment) getSupportFragmentManager().findFragmentById(R.id.map)).getMap();
	    
	}
}
