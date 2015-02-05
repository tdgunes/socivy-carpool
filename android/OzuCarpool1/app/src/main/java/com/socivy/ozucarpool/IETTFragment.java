package com.socivy.ozucarpool;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import org.json.JSONArray;
import org.json.JSONObject;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.text.format.Time;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ExpandableListView;


public class IETTFragment extends Fragment {

	public static IETTFragment newInstance() {
		IETTFragment fragment = new IETTFragment();
		return fragment;
	}

	private View rootView;
	public ArrayList<RouteInfo> listItem= new ArrayList<RouteInfo>();
	private ArrayList<ParentItem> itemList;
	private ExpandableListAdapter adapter;


	public IETTFragment() {
	}

	@Override
	public View onCreateView(LayoutInflater inflater, ViewGroup container,
			Bundle savedInstanceState) {


		if (rootView == null) {
			rootView = inflater.inflate(R.layout.fragment_iett, container,
					false);
			/*webView = (WebView) rootView.findViewById(R.id.webView1);
			webView.setWebViewClient(new MyWebViewClient());
			//webView.setWebChromeClient(new WebChromeClient());
			webView.getSettings().setJavaScriptEnabled(true);
			webView.loadUrl("http://tdgunes.org/iett/");*/

			itemList = new ArrayList<ParentItem>();

			adapter = new ExpandableListAdapter(getActivity(), itemList); 


			ExpandableListView list = (ExpandableListView) rootView.findViewById(R.id.expandedlist);
			list.setAdapter(adapter);

			populate();

		}
		else {
			((ViewGroup) rootView.getParent()).removeView(rootView);
		}

		return rootView;
	}

	private void populate() {
		rootView.findViewById(R.id.progressBariett).setVisibility(View.VISIBLE);
		
		new ContextTask<String, String, String>(getActivity()) {

			@Override
			protected String doInBackground(String... params) {
				try {
					return HttpPoster.getRegularJSON("http://tdgunes.org/iett/api/");
				} catch (Exception e) {
					e.printStackTrace();
					return "lol";
				}
			}

			@Override
			protected void onPostExecute(String result) {
				super.onPostExecute(result);
				rootView.findViewById(R.id.progressBariett).setVisibility(View.GONE );
				if (itemList == null) 
					itemList = new ArrayList<ParentItem>();
				
				itemList.clear();
				
				System.out.println(result);
				try {
					JSONArray jarray = new JSONArray(result);
					for (int i = 0; i < jarray.length(); i++) {
						JSONObject bus = jarray.getJSONObject(i);

						ParentItem parent = new ParentItem(bus.getString("id") + " (" + bus.getString("direction")+")");
						
						JSONArray hours = new JSONArray(bus.getString("hours"));
						for (int j = 0; j < hours.length(); j++) {
							parent.getChildItemList().add(new ChildItem(hours.getString(j)));
						}
						
						itemList.add(parent);
						adapter.notifyDataSetChanged();
					}

				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		}.execute();
	}

	/* Creating the Hashmap for the row */
	private List<HashMap<String, String>> createGroupList() {
		ArrayList<HashMap<String, String>> result = new ArrayList<HashMap<String, String>>();
		for( int i = 0 ; i < 15 ; ++i ) { // 15 groups........
			HashMap<String, String> m = new HashMap<String, String>();
			m.put( "Group Item","Group Item " + i ); // the key and it's value.
			result.add( m );
		}
		return (List<HashMap<String, String>>)result;
	}

	/* creatin the HashMap for the children */
	private List<ArrayList<HashMap<String, String>>> createChildList() {

		ArrayList<ArrayList<HashMap<String, String>>> result = new ArrayList<ArrayList<HashMap<String, String>>>();
		for( int i = 0 ; i < 15 ; ++i ) { // this -15 is the number of groups(Here it's fifteen)
			/* each group need each HashMap-Here for each group we have 3 subgroups */
			ArrayList<HashMap<String, String>> secList = new ArrayList<HashMap<String, String>>();
			for( int n = 0 ; n < 3 ; n++ ) {
				HashMap<String, String> child = new HashMap<String, String>();
				child.put( "Sub Item", "Sub Item " + n );
				secList.add( child );
			}
			result.add( secList );
		}
		return result;
	}

	@Override
	public void onResume() {
		super.onResume();
		populate();
	}



}