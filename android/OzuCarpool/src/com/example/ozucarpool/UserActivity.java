package com.example.ozucarpool;

import java.util.Locale;

import com.example.ozucarpool.R;

import android.content.Intent;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentPagerAdapter;
import android.support.v4.app.FragmentTransaction;
import android.support.v4.view.ViewPager;
import android.support.v7.app.ActionBar;
import android.support.v7.app.ActionBarActivity;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.TextView;

public class UserActivity extends ActionBarActivity implements
		ActionBar.TabListener {

	
	SectionsPagerAdapter mSectionsPagerAdapter;

	
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
		((TextView) findViewById(R.id.tab_car_title)).setText("Arabam Var");
		
		actionBar.addTab(actionBar.newTab().setTabListener(this).setCustomView(R.layout.tab_view_map));
		((TextView) findViewById(R.id.tab_map_title)).setText("Arabam Yok");
		
		actionBar.addTab(actionBar.newTab().setTabListener(this).setCustomView(R.layout.tab_view_settings));
		((TextView) findViewById(R.id.tab_gear_title)).setText("Ayarlar");
		
		
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
				return SettingsFragment.newInstance();
		
			}
			return RoutesFragment.newInstance();
		}

		@Override
		public int getCount() {
			// Show 3 total pages.
			return 3;
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
				return R.drawable.gearicon;
			}
			return 0;
		}
	}

	public static class RoutesFragment extends Fragment {
		
		public static RoutesFragment newInstance() {
			RoutesFragment fragment = new RoutesFragment();
			return fragment;
		}

		public RoutesFragment() {
		}

		@Override
		public View onCreateView(LayoutInflater inflater, ViewGroup container,
				Bundle savedInstanceState) {
			
			
			View rootView = inflater.inflate(R.layout.fragment_user, container,
					false);
			
			Button myButton = (Button) rootView.findViewById(R.id.button1);

			myButton.setOnClickListener(new View.OnClickListener() {

				@Override
				public void onClick(View v) {

					Intent intent = new Intent(v.getContext(), AddRouteActivity.class);
					startActivity(intent);
				}
			});

			
			return rootView;
		}
	}
	
	public static class SearchFragment extends Fragment {
		
		public static SearchFragment newInstance() {
			SearchFragment fragment = new SearchFragment();
			
			return fragment;
		}

		public SearchFragment() {
		}

		@Override
		public View onCreateView(LayoutInflater inflater, ViewGroup container,
				Bundle savedInstanceState) {
			
			View rootView = inflater.inflate(R.layout.fragment_map, container,
					false);
			
			return rootView;
		}
	}
	
	public static class SettingsFragment extends Fragment {
		
		public static SettingsFragment newInstance() {
			SettingsFragment fragment = new SettingsFragment();
			
			return fragment;
		}

		public SettingsFragment() {
		}

		@Override
		public View onCreateView(LayoutInflater inflater, ViewGroup container,
				Bundle savedInstanceState) {
			
			View rootView = inflater.inflate(R.layout.fragment_settings, container,
					false);
			
			return rootView;
		}
	}

}
