package com.socivy.ozucarpool;

import java.util.ArrayList;

import android.app.Activity;
import android.content.Context;
import android.graphics.Typeface;
import android.text.Html;
import android.text.SpannableStringBuilder;
import android.text.Spanned;
import android.text.format.Time;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.socivy.ozucarpool.R;

public class StopListAdapter extends ArrayAdapter<RouteInfo> {
	public StopListAdapter(Context context, int resource, ArrayList<RouteInfo> objects) {
		super(context, resource, objects);

		this.context = context;
		this.listItem = objects;
		this.font = CachedFont.get("fontawesome-webfont.ttf", context); // Typeface.createFromAsset( getActivity().getAssets(), "fontawesome-webfont.ttf" );
	}


	private Typeface font;
	private Context context;
	public ArrayList<RouteInfo> listItem;

	public Activity getActivity() {
		return (Activity) context;
	}


	@Override
	public View getView(int position, View convertView, ViewGroup parent) 
	{
		View row;
		LayoutInflater mInflater = getActivity().getLayoutInflater();
		final RouteInfo item = getItem(position);
		
		if (null == convertView) {
			row = mInflater.inflate(R.layout.route_list_item, parent, false);
			
			
		} 
		else {
			row = convertView;
		}
		
		LinearLayout lt = (LinearLayout) row.findViewById( R.id.stops );
		lt.removeAllViews();
		for (String stopName : item.stops) {
			TextView stop = new TextView(context);
			SpannableStringBuilder str = new SpannableStringBuilder(Html.fromHtml("&#xf024; " + stopName));
			str.setSpan(new CustomTypefaceSpan("bold", font) , 0, 1, Spanned.SPAN_EXCLUSIVE_INCLUSIVE);
			stop.setText(str);
			stop.setTextColor(0xFFFFFFFF);
			stop.setTextSize(16.0f);
			stop.setBackgroundResource(R.drawable.stop_style);
			lt.addView(stop);
		}
		
		Time timestamp = new Time();
		timestamp.setToNow();
		long diff = item.time.toMillis(false) - timestamp.toMillis(false);

		
		
		TextView tv = (TextView) row.findViewById(R.id.textView1);
		if (diff / (1000*60*60) > 0) 
			tv.setText((diff / (1000*60*60))+" hour(s) left");
		else
			tv.setText((diff / (1000*60))+" minute(s) left");

		TextView direction = (TextView) row.findViewById(R.id.textView7);
		direction.setTypeface(font);
		if (item.toSchool)
			direction.setText(Html.fromHtml("&#xf024; &#xf178; &#xf19c;"));
		else 
			direction.setText(Html.fromHtml("&#xf19c; &#xf178; &#xf024;"));

		TextView time = (TextView) row.findViewById(R.id.textView2);
		time.setTypeface(font);
		time.setText(Html.fromHtml("&#xf017; " + ((item.time.monthDay != timestamp.monthDay) ? "Tomorrow ":"") + item.time.format("%H:%M")));


		TextView seats = (TextView) row.findViewById(R.id.textView3);
		seats.setTypeface(font);
		seats.setText(Html.fromHtml("&#xf1ae; " + item.seats));

		TextView driver = (TextView) row.findViewById(R.id.textView4);
		driver.setTypeface(font);
		driver.setText(Html.fromHtml("&#xf1b9; "));

		TextView driverName = (TextView) row.findViewById(R.id.textView6);
		driverName.setText(Html.fromHtml(item.driver));

		





		return row;
	}
}


