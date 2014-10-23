package com.socivy.ozucarpool;

import java.util.ArrayList;
import java.util.Iterator;

import android.app.Activity;
import android.content.Intent;
import android.graphics.Typeface;
import android.os.Bundle;
import android.support.v7.app.ActionBarActivity;
import android.text.Html;
import android.text.SpannableStringBuilder;
import android.text.Spanned;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.CheckBox;
import android.widget.LinearLayout;

import com.socivy.ozucarpool.R;

public class AddRouteMapActivity extends ActionBarActivity {

	private Typeface font;
	private ArrayList<CheckBox> boxes;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_add_route_map);
		getSupportActionBar().hide();
		boxes=new ArrayList<CheckBox>();

		findViewById(R.id.progressBar1).setVisibility(View.VISIBLE);

		font = Typeface.createFromAsset( getAssets(), "fontawesome-webfont.ttf" );

		Button finishBtn = (Button) findViewById(R.id.button1);
		finishBtn.setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View arg0) {
				Intent result = new Intent();
				ArrayList<Integer> stopIds = new ArrayList<Integer>();

				for (CheckBox box : boxes) {
					if (box.isChecked()) {
						StopInfo info = (StopInfo) box.getTag();
						stopIds.add(info.id);
					}
				}
				int[] ret = new int[stopIds.size()];
			    Iterator<Integer> iterator = stopIds.iterator();
			    for (int i = 0; i < ret.length; i++)
			    {
			        ret[i] = iterator.next().intValue();
			    }
				result.putExtra("stops", ret);
				setResult(Activity.RESULT_OK, result);
				finish();
			}
		});

		new ContextTask<String, Void, String>(this) {

			@Override
			protected void onPostExecute(String result) {
				populate(result);
				super.onPostExecute(result);
			}

			@Override
			protected String doInBackground(String... token) {
				try {
					return HttpPoster.getJSON(AppCredintals.BASE_LINK+"/api/v1/place", context);
				} catch (Exception e) {
					return e.toString();
				}
			}
		}.execute();

	}

	@Override
	protected void onResume() {
		super.onResume();
		findViewById(R.id.progressBar1).setVisibility(View.VISIBLE);
	}

	public void populate(String result) {
		findViewById(R.id.progressBar1).setVisibility(View.GONE);
		LinearLayout lt = (LinearLayout) findViewById( R.id.stops );
		lt.removeAllViews();
		ArrayList<StopInfo> item = new ArrayList<StopInfo>(); 
		StopInflater inflater = new StopInflater(result);
		inflater.inflate(item);
		for (StopInfo stopItem : item) {
			CheckBox stop = new CheckBox(this);
			SpannableStringBuilder str = new SpannableStringBuilder(Html.fromHtml("&#xf024; " + stopItem.name));
			str.setSpan(new CustomTypefaceSpan("bold", font) , 0, 1, Spanned.SPAN_EXCLUSIVE_INCLUSIVE);
			stop.setText(str);
			stop.setTextColor(0xFF000000);
			stop.setTextSize(20.0f);
			stop.setTag(stopItem);

			boxes.add(stop);
			//stop.setBackgroundResource(R.drawable.stop_style);
			lt.addView(stop);
		}
	}

	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
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
}
