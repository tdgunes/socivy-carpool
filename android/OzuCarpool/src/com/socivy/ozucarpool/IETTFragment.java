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
import android.webkit.WebChromeClient;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.AbsListView;
import android.widget.AdapterView;
import android.widget.Button;
import android.widget.ListView;
import android.widget.AbsListView.OnScrollListener;
import android.widget.AdapterView.OnItemClickListener;


public class IETTFragment extends Fragment {

	public static IETTFragment newInstance() {
		IETTFragment fragment = new IETTFragment();
		return fragment;
	}

	private View rootView;
	public ArrayList<RouteInfo> listItem= new ArrayList<RouteInfo>();
	private SwipeRefreshLayout swipeLayout;
	private ListView list;
	private StopListAdapter adapter;
	private WebView webView;

	public IETTFragment() {
	}

	@Override
	public View onCreateView(LayoutInflater inflater, ViewGroup container,
			Bundle savedInstanceState) {


		if (rootView == null) {
			rootView = inflater.inflate(R.layout.fragment_iett, container,
					false);
			webView = (WebView) rootView.findViewById(R.id.webView1);
			webView.setWebViewClient(new MyWebViewClient());
			//webView.setWebChromeClient(new WebChromeClient());
			webView.getSettings().setJavaScriptEnabled(true);
			webView.loadUrl("http://tdgunes.org/iett/");
			

		}
		else {
			((ViewGroup) rootView.getParent()).removeView(rootView);
		}

		return rootView;
	}
	
	@Override
	public void onResume() {
		super.onResume();
	}

	private class MyWebViewClient extends WebViewClient {
	    @Override
	    public boolean shouldOverrideUrlLoading(WebView view, String url) {
	        view.loadUrl(url);
	        return true;
	    }
	}
	
}