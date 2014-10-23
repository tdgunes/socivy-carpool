package com.socivy.ozucarpool;



import java.util.Locale;
import java.util.concurrent.atomic.AtomicInteger;

import android.content.Context;
import android.content.SharedPreferences;
import android.os.AsyncTask;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentPagerAdapter;
import android.support.v4.app.FragmentTransaction;
import android.support.v4.view.ViewPager;
import android.support.v7.app.ActionBar;
import android.support.v7.app.ActionBarActivity;
import android.util.Log;
import android.view.Menu;
import android.view.MenuItem;
import android.widget.TextView;

import com.google.android.gms.gcm.GoogleCloudMessaging;

public class UserActivity extends ActionBarActivity implements
ActionBar.TabListener {

	SectionsPagerAdapter mSectionsPagerAdapter;
	GoogleCloudMessaging gcm;
	AtomicInteger msgId = new AtomicInteger();
	SharedPreferences prefs;
	Context context;
	String regid;



	ViewPager mViewPager;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_user);



		final ActionBar actionBar = getSupportActionBar();
		actionBar.setNavigationMode(ActionBar.NAVIGATION_MODE_TABS);
		actionBar.setDisplayShowHomeEnabled(false);
		actionBar.setDisplayShowTitleEnabled(false);


		mSectionsPagerAdapter = new SectionsPagerAdapter(
				getSupportFragmentManager());

		mViewPager = (ViewPager) findViewById(R.id.pager);
		mViewPager.setAdapter(mSectionsPagerAdapter);


		mViewPager.setOnPageChangeListener(new ViewPager.SimpleOnPageChangeListener() {
			@Override
			public void onPageSelected(int position) {
				actionBar.setSelectedNavigationItem(position);
			}
		});



		actionBar.addTab(actionBar.newTab().setTabListener(this).setCustomView(R.layout.tab_view_car));
		((TextView) findViewById(R.id.tab_car_title)).setText(R.string.title_section1);

		actionBar.addTab(actionBar.newTab().setTabListener(this).setCustomView(R.layout.tab_view_map));
		((TextView) findViewById(R.id.tab_map_title)).setText(R.string.title_section2);

		actionBar.addTab(actionBar.newTab().setTabListener(this).setCustomView(R.layout.tab_view_bus));
		((TextView) findViewById(R.id.tab_bus_title)).setText(R.string.title_section4);
		
		actionBar.addTab(actionBar.newTab().setTabListener(this).setCustomView(R.layout.tab_view_settings));
		((TextView) findViewById(R.id.tab_gear_title)).setText(R.string.title_section3);


		context = getApplicationContext();
		registerGCM();
	}

	private void registerGCM() {
		if (AppCredintals.checkPlayServices(this)) {
			gcm = GoogleCloudMessaging.getInstance(this);
			regid = AppCredintals.getRegistrationId(context);

			if (regid.equals(" ")) {
				new AsyncTask<Void, Void, Void>() {
					@Override
					protected Void doInBackground(Void... params) {
						AppCredintals.registerInBackground(context);
						return null;
					}

					@Override
					protected void onPostExecute(Void msg) {
						Log.i("lol", "sent store");
					}

				}.execute();
			}
			else {
				new AsyncTask<Void, Void, Void>() {
					@Override
					protected Void doInBackground(Void... params) {
						AppCredintals.sendRegistrationIdToBackend(context);
						return null;
					}

					@Override
					protected void onPostExecute(Void msg) {
						Log.i("lol", "sent store");
					}

				}.execute();
				Log.i("lol", regid);
			}
		} else {
			Log.i("hata", "No valid Google Play Services APK found.");
		}
	}

	@Override
	public void onResume() {
		super.onResume();
		AppCredintals.checkPlayServices(this);
	}



	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		getMenuInflater().inflate(R.menu.user, menu);
		return true;
	}

	@Override
	public boolean onOptionsItemSelected(MenuItem item) {
		int id = item.getItemId();
		if (id == R.id.action_settings) {
			return true;
		}
		return super.onOptionsItemSelected(item);
	}

	@Override
	public void onTabSelected(ActionBar.Tab tab,
			FragmentTransaction fragmentTransaction) {
		getSupportActionBar().setTitle("Güzergahlarým");
		mViewPager.setCurrentItem(tab.getPosition());
	}

	@Override
	public void onTabUnselected(ActionBar.Tab tab,
			FragmentTransaction fragmentTransaction) {
	}

	@Override
	public void onTabReselected(ActionBar.Tab tab,
			FragmentTransaction fragmentTransaction) {
	}


	public class SectionsPagerAdapter extends FragmentPagerAdapter {

		public SectionsPagerAdapter(FragmentManager fm) {
			super(fm);
		}

		@Override
		public Fragment getItem(int position) {

			switch(position) {
			case 0:
				return RoutesFragment.newInstance();
			case 1:
				return SearchFragment.newInstance();
			case 2:
				return IETTFragment.newInstance();
			case 3:
				return SettingsFragment.newInstance();
				

			}
			return RoutesFragment.newInstance();
		}

		@Override
		public int getCount() {
			// Show 3 total pages.
			return 4;
		}

		@Override
		public CharSequence getPageTitle(int position) {
			Locale l = Locale.getDefault();
			switch (position) {
			case 0:
				return getString(R.string.title_section1).toUpperCase(l);
			case 1:
				return getString(R.string.title_section2).toUpperCase(l);
			case 2:
				return getString(R.string.title_section4).toUpperCase(l);
			case 3:
				return getString(R.string.title_section3).toUpperCase(l);
			}
			return null;
		}


		public int getIcon(int position) {
			switch (position) {
			case 0:
				return R.drawable.caricon;
			case 1:
				return R.drawable.mapicon;
			case 2:
				return R.drawable.busicon;
			case 3:
				return R.drawable.gearicon;
			}
			return 0;
		}
	}

}
