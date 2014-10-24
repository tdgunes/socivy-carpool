package com.socivy.ozucarpool;

import java.util.ArrayList;
import java.util.concurrent.ExecutionException;

import org.json.JSONException;
import org.json.JSONObject;

import android.app.Activity;
import android.app.Dialog;
import android.app.ProgressDialog;
import android.content.Intent;
import android.graphics.Typeface;
import android.net.Uri;
import android.os.Bundle;
import android.support.v7.app.ActionBarActivity;
import android.text.Html;
import android.text.format.Time;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.view.ViewGroup.LayoutParams;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.Toast;

import com.google.android.gms.maps.GoogleMap;

public class InfoActivity extends ActionBarActivity {
	public GoogleMap map;
	public ArrayList<String> listItem= new ArrayList<String>();
	public ArrayList<ParticipantInfo> listItemcomp= new ArrayList<ParticipantInfo>();
	public Typeface font;
	public RouteInfo info;
	private int id;
	public String phonenumber;
	private boolean joinable;
	private boolean joined;
	private String json;
	private ArrayAdapter<String> adapter;
	private ArrayAdapter<ParticipantInfo> adaptercomp;
	private ProgressDialog progressDialog;
	private String email;
	private boolean showphone;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_info);

		progressDialog = new ProgressDialog(this);
		progressDialog.setCancelable(false);

		getSupportActionBar().setTitle("Route Info");

		font = CachedFont.get("fontawesome-webfont.ttf", this); // Typeface.createFromAsset( getAssets(), "fontawesome-webfont.ttf" );

		Bundle bundle = getIntent().getExtras();
		if (bundle != null) {
			id = bundle.getInt("routeid");
			json = bundle.getString("routejson");
			joinable = bundle.getBoolean("joinable");
			joined = bundle.getBoolean("joined");
		}

		Button contactbutton = (Button) findViewById(R.id.contactbutton);
		contactbutton.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {
				showContactPopup(-1);
			}
		});

		Button joinbutton = (Button) findViewById(R.id.joinbutton);

		if (joined) {
			joinbutton.setBackgroundResource(R.drawable.custom_button_red);
			joinbutton.setText(R.string.string_leave);
		}
		else {
			joinbutton.setBackgroundResource(R.drawable.custom_button);
			joinbutton.setText(R.string.string_join);
		}

		if (!joinable) {
			joinbutton.setBackgroundResource(R.drawable.custom_button_red);
			joinbutton.setText(R.string.string_cancel);
		}

		joinbutton.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {
				if (!joinable) {
					routeDestroy();
				}
				else {
					if (joined) {
						routeLeave();
					}
					else {
						routeJoin();
					}
				}
			}
		});

		ListView list = (ListView) findViewById(R.id.stoplist);

		adapter = new ArrayAdapter<String>(this,
				R.layout.info_list_item, R.id.actress_name, listItem)  {
			@Override
			public View getView(int position, View convertView, ViewGroup parent) 
			{
				View row;
				LayoutInflater mInflater = getLayoutInflater();

				if (null == convertView) {
					row = mInflater.inflate(R.layout.info_list_item, parent, false);
				} else {
					row = convertView;
				}

				TextView tv = (TextView) row.findViewById(R.id.actress_name);
				//tv.setTypeface(font);
				tv.setText(Html.fromHtml(getItem(position)));

				return row;
			}

		};


		list.setAdapter(adapter);		

		ListView list2 = (ListView) findViewById(R.id.complist);
		adaptercomp = new ArrayAdapter<ParticipantInfo>(this,
				R.layout.info_list_item, R.id.actress_name, listItemcomp)  {
			@Override
			public View getView(int position, View convertView, ViewGroup parent) 
			{
				View row;
				LayoutInflater mInflater = getLayoutInflater();
				ParticipantInfo info = getItem(position);
				if (null == convertView) {
					row = mInflater.inflate(R.layout.info_list_item, parent, false);
				} else {
					row = convertView;
				}

				TextView tv = (TextView) row.findViewById(R.id.actress_name);
				//tv.setTypeface(font);
				tv.setText(Html.fromHtml(info.name));


				return row;
			}

		};

		list2.setOnItemClickListener(new OnItemClickListener() {

			@Override
			public void onItemClick(AdapterView<?> parent, View view,
					int position, long id) {
				showContactPopup(position);

			}
		});


		list2.setAdapter(adaptercomp);	

		getRoutes();

		adapter.notifyDataSetChanged();
	}


	protected void showContactPopup(int user) {
		final String phonetemp;
		final String emailtemp;
		final String driver;
		boolean showphonetemp = false;
		if (user == -1) {
			phonetemp = phonenumber;
			showphonetemp = showphone;
			emailtemp = email;
			driver = info.driver;
		} 
		else {
			ParticipantInfo participant = adaptercomp.getItem(user);
			phonetemp = participant.phone;
			showphonetemp = participant.showPhone;
			emailtemp = participant.email;
			driver = participant.name;
		}

		Dialog popUp = new Dialog(this);
		popUp.setTitle("Contact "+driver);
		LinearLayout layout = new LinearLayout(this);
		Button callbutton = new Button(this);
		callbutton.setBackgroundResource(R.drawable.custom_button);
		callbutton.setText("Call");
		callbutton.setTextColor(0xffffffff);
		callbutton.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {
				String url = "tel:"+phonetemp;
				Intent intent = new Intent(Intent.ACTION_DIAL, Uri.parse(url));
				startActivity(intent);
			}
		});

		Button smsbutton = new Button(this);
		smsbutton.setBackgroundResource(R.drawable.custom_button);
		smsbutton.setText("Send SMS");
		smsbutton.setTextColor(0xffffffff);
		smsbutton.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {
				String url = "sms:"+phonetemp;
				Intent intent = new Intent(Intent.ACTION_VIEW, Uri.parse(url));
				startActivity(intent);
			}
		});

		Button emailbutton = new Button(this);
		emailbutton.setBackgroundResource(R.drawable.custom_button);
		emailbutton.setText("Send E-mail");
		emailbutton.setTextColor(0xffffffff);
		emailbutton.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {

				Intent emailIntent = new Intent(android.content.Intent.ACTION_SEND);
				emailIntent.setType("plain/text");
				emailIntent.putExtra(android.content.Intent.EXTRA_EMAIL, new String[]{emailtemp});
				emailIntent.putExtra(android.content.Intent.EXTRA_SUBJECT, "Socivy - Route");
				emailIntent.putExtra(android.content.Intent.EXTRA_TEXT, "Hello " + info.driver+",\n");
				startActivity(emailIntent);
			}
		});

		LayoutParams params = new LayoutParams(LayoutParams.FILL_PARENT,
				LayoutParams.WRAP_CONTENT);
		layout.setOrientation(LinearLayout.VERTICAL);
		if (showphonetemp)	 {
			layout.addView(callbutton, params);
			layout.addView(smsbutton, params);
		}
		layout.addView(emailbutton, params);


		popUp.setContentView(layout);
		popUp.show();
	}


	private void getRoutes() {
		/*try {

			new ContextTask<String, Void, String>(this) {

				@Override
				protected void onPostExecute(String result) {
					try {
						JSONObject res = new JSONObject(result);
						populate(res.getString("result").toString());
					} catch (Exception e) {
						e.printStackTrace();
						Toast.makeText(context, "Some error occured", Toast.LENGTH_LONG).show();
						finish();
					}

					super.onPostExecute(result);
				}

				@Override
				protected String doInBackground(String... token) {
					try {
						return HttpPoster.getJSON(AppCredintals.BASE_LINK+"/api/v1/route/"+id, context);
					} catch (Exception e) {
						return e.toString();
					}
				}
			}.execute(AppCredintals.getAccessToken(this)).get();
		} catch (InterruptedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (ExecutionException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}*/

		populate(json);
	}

	public void populate(String json) {
		try {
			info = RouteInfo.createFromJSON(json);
		} catch (JSONException e1) {
			finish();
			return;
		}
		for (String name : info.stops) {
			listItem.add(name);
		}


		for (ParticipantInfo inf : info.comps) {
			listItemcomp.add(inf);
		}



		TextView direction = (TextView) findViewById(R.id.textView1);
		direction.setTypeface(font);

		if (info.toSchool)
			direction.setText(Html.fromHtml("&#xf024; &#xf178; &#xf19c;"));
		else 
			direction.setText(Html.fromHtml("&#xf19c; &#xf178; &#xf024;"));

		Time timestamp = new Time();
		timestamp.setToNow();

		TextView time = (TextView) findViewById(R.id.textView2);
		time.setTypeface(font);
		time.setText(Html.fromHtml("&#xf017; " + ((info.time.monthDay != timestamp.monthDay) ? "Tomorrow ":"") + info.time.format("%H:%M")));

		TextView seats = (TextView) findViewById(R.id.textView3);
		seats.setTypeface(font);
		seats.setText(Html.fromHtml("&#xf1ae; " + info.seats));

		TextView driver = (TextView) findViewById(R.id.textView4);
		driver.setTypeface(font);
		driver.setText(Html.fromHtml("&#xf1b9; "));

		TextView driverName = (TextView) findViewById(R.id.textView6);
		driverName.setText(Html.fromHtml(info.driver));

		TextView desc = (TextView) findViewById(R.id.textView5);
		desc.setTypeface(font);
		desc.setText(Html.fromHtml("&#xf0a1; "));

		TextView desctext = (TextView) findViewById(R.id.textView7);
		desctext.setText(Html.fromHtml(info.description));




		if (info.description.length() <= 1) {
			desc.setVisibility(View.GONE);
			desctext.setVisibility(View.GONE);

		} 
		else {
			desc.setVisibility(View.VISIBLE);
			desctext.setVisibility(View.VISIBLE);
		}

		try {
			JSONObject res = new JSONObject(json);
			JSONObject user = res.getJSONObject("user");
			JSONObject inf = user.getJSONObject("information");

			email = user.getString("email");

			showphone = inf.getBoolean("showPhone");
			TextView phoneicon = (TextView) findViewById(R.id.phonetext);
			phoneicon.setTypeface(font);
			phoneicon.setText(Html.fromHtml("&#xf095; "));

			TextView phonetext = (TextView) findViewById(R.id.phonetext2);
			phonenumber = inf.getString("phone");
			phonetext.setText(Html.fromHtml(phonenumber));


			if (!showphone) {
				phoneicon.setVisibility(View.GONE);
				phonetext.setVisibility(View.GONE);
			} 
			else {
				phoneicon.setVisibility(View.VISIBLE);
				phonetext.setVisibility(View.VISIBLE);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}


	private void routeJoin() {
		progressDialog.setMessage("Joining!");
		progressDialog.show();
		try {
			new ContextTask<Void, Void, Void>(InfoActivity.this) {

				@Override
				protected Void doInBackground(Void... params) {
					try {
						HttpPoster.getJSON(AppCredintals.BASE_LINK+"/api/v1/route/"+id+"/request", context);
					} catch (Exception e) {
						e.printStackTrace();
					}
					return null;
				}

				@Override
				protected void onPostExecute(Void res) {
					progressDialog.dismiss();
					super.onPostExecute(res);
					Toast.makeText(context, "Joined the route", Toast.LENGTH_LONG).show();
					((Activity) context).finish();
				}

			}.execute().get();
		} catch (InterruptedException e) {
			e.printStackTrace();
		} catch (ExecutionException e) {
			e.printStackTrace();
		}
	}


	private void routeLeave() {
		progressDialog.setMessage("Leaving!");
		progressDialog.show();
		try {
			new ContextTask<Void, Void, Void>(InfoActivity.this) {

				@Override
				protected Void doInBackground(Void... params) {
					try {
						HttpPoster.getJSON(AppCredintals.BASE_LINK+"/api/v1/route/"+id+"/cancel", context);
					} catch (Exception e) {
						e.printStackTrace();
					}
					return null;
				}

				@Override
				protected void onPostExecute(Void res) {
					progressDialog.dismiss();
					super.onPostExecute(res);
					Toast.makeText(context, "Left the route", Toast.LENGTH_LONG).show();
					((Activity) context).finish();

				}

			}.execute().get();
		} catch (InterruptedException e) {
			e.printStackTrace();
		} catch (ExecutionException e) {
			e.printStackTrace();
		}
	}


	private void routeDestroy() {
		progressDialog.setMessage("Destroying!");
		progressDialog.show();
		try {
			new ContextTask<Void, Void, Void>(InfoActivity.this) {

				@Override
				protected Void doInBackground(Void... params) {
					try {
						HttpPoster.deleteRequest(AppCredintals.BASE_LINK+"/api/v1/route/"+id, context);
					} catch (Exception e) {
						e.printStackTrace();
					}
					return null;
				}

				@Override
				protected void onPostExecute(Void res) {
					progressDialog.dismiss();
					super.onPostExecute(res);
					Toast.makeText(context, "Destroyed the route", Toast.LENGTH_LONG).show();
					((Activity) context).finish();

				}

			}.execute().get();
		} catch (InterruptedException e) {
			e.printStackTrace();
		} catch (ExecutionException e) {
			e.printStackTrace();
		}
	}

	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		MenuInflater inflater=getMenuInflater();
		inflater.inflate(R.menu.sharemenu, menu);
		return super.onCreateOptionsMenu(menu);

	}
	@Override
	public boolean onOptionsItemSelected(MenuItem item) {
		switch(item.getItemId())
		{
		case R.id.action_sharefb:
			Intent intent = new Intent(Intent.ACTION_SEND);
			intent.setType("text/plain");
			intent.putExtra(Intent.EXTRA_TEXT, "https://www.socivy.com/route/"+info.id);
			startActivity(Intent.createChooser(intent, "Share with"));
			break;
		}
		return true;
	}

}
