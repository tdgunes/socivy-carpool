package com.socivy.ozucarpool;



import java.util.ArrayList;
import java.util.Locale;
import java.util.concurrent.atomic.AtomicInteger;

import org.json.JSONObject;

import android.app.Activity;
import android.app.ProgressDialog;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.AsyncTask;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentPagerAdapter;
import android.support.v4.app.FragmentTransaction;
import android.support.v4.view.ViewPager;
import android.support.v4.widget.SwipeRefreshLayout;
import android.support.v4.widget.SwipeRefreshLayout.OnRefreshListener;
import android.support.v7.app.ActionBar;
import android.support.v7.app.ActionBarActivity;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AbsListView;
import android.widget.AbsListView.OnScrollListener;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.Button;
import android.widget.ListView;
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

		private View rootView;
		public ArrayList<RouteInfo> listItem= new ArrayList<RouteInfo>();
		private SwipeRefreshLayout swipeLayout;
		private ListView list;
		private StopListAdapter adapter;

		public RoutesFragment() {
		}

		@Override
		public View onCreateView(LayoutInflater inflater, ViewGroup container,
				Bundle savedInstanceState) {


			if (rootView == null) {
				rootView = inflater.inflate(R.layout.fragment_route, container,
						false);

				Button myButton = (Button) rootView.findViewById(R.id.button_add);

				myButton.setOnClickListener(new View.OnClickListener() {

					@Override
					public void onClick(View v) {

						Intent intent = new Intent(v.getContext(), AddRouteActivity.class);
						startActivity(intent);
					}
				});


				swipeLayout = (SwipeRefreshLayout) rootView.findViewById(R.id.swipe_container2);
				swipeLayout.setColorScheme(R.color.blue2, R.color.blue25, R.color.orange4, R.color.orange5);
				swipeLayout.setOnRefreshListener(new OnRefreshListener() {

					@Override
					public void onRefresh() {
						getRoutes();
						swipeLayout.setEnabled(false);
					}
				});
				swipeLayout.setHapticFeedbackEnabled(true);

				list = (ListView) rootView.findViewById(R.id.routeslist2);

				list.setOnItemClickListener(new OnItemClickListener() {

					@Override
					public void onItemClick(AdapterView<?> arg0, View arg1, int pos,
							long arg3) {
						RouteInfo info = (RouteInfo) arg0.getItemAtPosition(pos);
						Intent intent = new Intent(getActivity(), InfoActivity.class);
						Bundle b = new Bundle();
						b.putInt("routeid", info.id);
						intent.putExtras(b);

						getActivity().startActivity(intent);
					}

				});

				list.setOnScrollListener(new OnScrollListener() {  
					@Override
					public void onScrollStateChanged(AbsListView view, int scrollState) {

					}

					@Override
					public void onScroll(AbsListView view, int firstVisibleItem, int visibleItemCount, int totalItemCount) {
						int topRowVerticalPosition = 
								(list == null || list.getChildCount() == 0) ? 
										0 : list.getChildAt(0).getTop();
						System.out.println(topRowVerticalPosition);
						swipeLayout.setEnabled(topRowVerticalPosition == 0);
					}
				});


				adapter = new StopListAdapter(getActivity(), 0, listItem);
				list.setAdapter(adapter);
			}
			else {
				((ViewGroup) rootView.getParent()).removeView(rootView);
			}
			getRoutes();

			return rootView;
		}


		private void getRoutes() {
			rootView.findViewById(R.id.progressBar2).setVisibility(View.VISIBLE);
			new ContextTask<String, Void, String>(getActivity()) {

				@Override
				protected void onPostExecute(String result) {
					populate(result);
					swipeLayout.setRefreshing(false);
					list.scrollTo(0, 0);
					rootView.findViewById(R.id.progressBar2).setVisibility(View.GONE);
					super.onPostExecute(result);
				}

				@Override
				protected String doInBackground(String... token) {
					try {
						return HttpPoster.getJSON("http://development.socivy.com/api/v1/me/route/self", context);
					} catch (Exception e) {
						return e.toString();
					}
				}
			}.execute();
		}

		public void populate(String json) {

			adapter.clear();
			RouteInflater inflater = new RouteInflater(json);
			inflater.inflate(listItem);
			adapter.notifyDataSetChanged();
		}
	}

	public static class SearchFragment extends Fragment  {

		private View rootView;
		public ArrayList<RouteInfo> listItem= new ArrayList<RouteInfo>();

		private SwipeRefreshLayout swipeLayout;

		private ListView list;

		private StopListAdapter adapter;

		public static SearchFragment newInstance() {
			SearchFragment fragment = new SearchFragment();

			return fragment;
		}

		public SearchFragment() {
		}

		@Override
		public void onResume() {
			super.onResume();
		}

		@Override
		public View onCreateView(LayoutInflater inflater, ViewGroup container,
				Bundle savedInstanceState) {



			if (rootView == null) {
				rootView = inflater.inflate(R.layout.fragment_map, container,
						false);

				Button myButton = (Button) rootView.findViewById(R.id.button_find);

				myButton.setOnClickListener(new View.OnClickListener() {

					@Override
					public void onClick(View v) {

						Intent intent = new Intent(v.getContext(), FindRouteActivity.class);
						startActivity(intent);
					}
				});

				swipeLayout = (SwipeRefreshLayout) rootView.findViewById(R.id.swipe_container);
				swipeLayout.setColorScheme(R.color.blue2, R.color.blue25, R.color.orange4, R.color.orange5);
				swipeLayout.setOnRefreshListener(new OnRefreshListener() {

					@Override
					public void onRefresh() {
						getRoutes();
						swipeLayout.setEnabled(false);

					}
				});
				swipeLayout.setHapticFeedbackEnabled(true);

				list = (ListView) rootView.findViewById(R.id.routeslist);

				list.setOnItemClickListener(new OnItemClickListener() {

					@Override
					public void onItemClick(AdapterView<?> arg0, View arg1, int pos,
							long arg3) {
						RouteInfo info = (RouteInfo) arg0.getItemAtPosition(pos);
						Intent intent = new Intent(getActivity(), InfoActivity.class);
						Bundle b = new Bundle();
						b.putInt("routeid", info.id);
						intent.putExtras(b);

						getActivity().startActivity(intent);
					}

				});

				list.setOnScrollListener(new OnScrollListener() {  
					@Override
					public void onScrollStateChanged(AbsListView view, int scrollState) {

					}

					@Override
					public void onScroll(AbsListView view, int firstVisibleItem, int visibleItemCount, int totalItemCount) {
						int topRowVerticalPosition = 
								(list == null || list.getChildCount() == 0) ? 
										0 : list.getChildAt(0).getTop();
						swipeLayout.setEnabled(topRowVerticalPosition == 0);
					}
				});


				adapter = new StopListAdapter(getActivity(), 0, listItem);
				list.setAdapter(adapter);
			}
			else {
				((ViewGroup) rootView.getParent()).removeView(rootView);
			}

			getRoutes();

			return rootView;
		}

		@Override
		public void onStart() {
			super.onStart();



		}

		private void getRoutes() {
			rootView.findViewById(R.id.progressBar1).setVisibility(View.VISIBLE);
			new ContextTask<String, Void, String>(getActivity()) {

				@Override
				protected void onPostExecute(String result) {
					populate(result);
					list.scrollTo(0, 0);
					swipeLayout.setRefreshing(false);
					rootView.findViewById(R.id.progressBar1).setVisibility(View.GONE);
					super.onPostExecute(result);
				}

				@Override
				protected String doInBackground(String... token) {
					try {
						return HttpPoster.getJSON("http://development.socivy.com/api/v1/me/route/enrolled", context);
					} catch (Exception e) {
						return e.toString();
					}
				}
			}.execute();
		}

		public void populate(String json) {

			adapter.clear();
			RouteInflater inflater = new RouteInflater(json);
			inflater.inflate(listItem);
			adapter.notifyDataSetChanged();
		}

	}

	public static class SettingsFragment extends Fragment {

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

			Button signout = (Button) rootView.findViewById(R.id.signoutbutton);
			signout.setOnClickListener(new View.OnClickListener() {

				@Override
				public void onClick(View v) {


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

								JSONObject json = new JSONObject(HttpPoster.getJSON("http://development.socivy.com/api/v1/logout", context));
								JSONObject info = json.getJSONObject("info");
								int error = info.getInt("error_code");
								if (error == 0)
									return true;
								else 
									return false;
							} catch (Exception e) {
								return false;
							}
						}
					}.execute();
				}
			});

			return rootView;
		}
	}

}
