package com.socivy.ozucarpool;

import java.util.ArrayList;

import android.content.Intent;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.widget.SwipeRefreshLayout;
import android.support.v4.widget.SwipeRefreshLayout.OnRefreshListener;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AbsListView;
import android.widget.AdapterView;
import android.widget.Button;
import android.widget.ListView;
import android.widget.ProgressBar;
import android.widget.AbsListView.OnScrollListener;
import android.widget.AdapterView.OnItemClickListener;


public class SearchFragment extends Fragment  {

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
		getRoutes();
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
					ProgressBar bar = (ProgressBar) SearchFragment.this.rootView.findViewById(R.id.progressBar1);
					if (bar.getVisibility() == View.GONE) {
						RouteInfo info = (RouteInfo) arg0.getItemAtPosition(pos);
						Intent intent = new Intent(getActivity(), InfoActivity.class);
						Bundle b = new Bundle();
						b.putInt("routeid", info.id);
						b.putString("routejson", info.jsonData);
						b.putBoolean("joined", true);
						b.putBoolean("joinable", true);
						intent.putExtras(b);

						getActivity().startActivity(intent);
					}
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
					return HttpPoster.getJSON(AppCredintals.BASE_LINK+"/api/v1/me/route/enrolled", context);
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