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
import android.widget.AbsListView.OnScrollListener;
import android.widget.AdapterView.OnItemClickListener;


public class RoutesFragment extends Fragment {

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
					b.putString("routejson", info.jsonData);
					b.putBoolean("joined", false);
					b.putBoolean("joinable", false);
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
	
	@Override
	public void onResume() {
		super.onResume();
		getRoutes();
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
					return HttpPoster.getJSON(AppCredintals.BASE_LINK+"/api/v1/me/route/self", context);
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