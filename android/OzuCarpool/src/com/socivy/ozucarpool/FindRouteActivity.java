package com.socivy.ozucarpool;

import java.util.ArrayList;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.support.v4.widget.SwipeRefreshLayout;
import android.support.v4.widget.SwipeRefreshLayout.OnRefreshListener;
import android.view.View;
import android.widget.AbsListView;
import android.widget.AbsListView.OnScrollListener;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.ListView;

public class FindRouteActivity extends Activity {
	
	public ArrayList<RouteInfo> listItem= new ArrayList<RouteInfo>();
	private SwipeRefreshLayout swipeLayout;
	private ListView list;
	private StopListAdapter adapter;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_find_route);
		
		swipeLayout = (SwipeRefreshLayout) findViewById(R.id.swipe_container);
		swipeLayout.setColorScheme(R.color.blue2, R.color.blue25, R.color.orange4, R.color.orange5);
		swipeLayout.setOnRefreshListener(new OnRefreshListener() {

			@Override
			public void onRefresh() {
				getRoutes();
				swipeLayout.setEnabled(false);

			}
		});
		swipeLayout.setHapticFeedbackEnabled(true);

		list = (ListView) findViewById(R.id.routeslist);

		list.setOnItemClickListener(new OnItemClickListener() {

			@Override
			public void onItemClick(AdapterView<?> arg0, View arg1, int pos,
					long arg3) {
				RouteInfo info = (RouteInfo) arg0.getItemAtPosition(pos);
				Intent intent = new Intent(FindRouteActivity.this, InfoActivity.class);
				Bundle b = new Bundle();
				b.putInt("routeid", info.id);
				intent.putExtras(b);

				startActivity(intent);
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
				swipeLayout.setEnabled(topRowVerticalPosition >= 0);
			}
		});


		adapter = new StopListAdapter(this, 0, listItem);
		list.setAdapter(adapter);
		
		getRoutes();
	}
	
	private void getRoutes() {
		findViewById(R.id.progressBar1).setVisibility(View.VISIBLE);
		new ContextTask<String, Void, String>(this) {

			@Override
			protected void onPostExecute(String result) {
				populate(result);
				swipeLayout.setRefreshing(false);
				findViewById(R.id.progressBar1).setVisibility(View.GONE);
				super.onPostExecute(result);
			}

			@Override
			protected String doInBackground(String... token) {
				try {
					return HttpPoster.getJSON("http://development.socivy.com/api/v1/route", context);
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
