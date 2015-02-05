package com.socivy.ozucarpool;

import java.util.concurrent.ExecutionException;

import android.app.Activity;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.view.MenuItem;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;

public class MainActivity extends Activity  {

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_main);
		//new HttpPoster(this).execute("asd");
		
		createNot();
		
		try {
			new ContextTask<String, Void, Boolean>(this) {

				@Override
				protected void onPostExecute(Boolean result) {
					super.onPostExecute(result);
					if (result == true) {
						Intent intent = new Intent(context, UserActivity.class);
						context.startActivity(intent);
						((Activity)context).finish();
					}
				}

				@Override
				protected Boolean doInBackground(String... token) {
					try {
						return new ExpiredAuthenticator().tryLogin(context);
					} catch (Exception e) {
						return false;
					}
				}
			}.execute().get();
		} catch (InterruptedException e) {
			e.printStackTrace();
		} catch (ExecutionException e) {
			e.printStackTrace();
		}

		Button myButton = (Button) findViewById(R.id.girisbut);
		Button myButton2 = (Button) findViewById(R.id.sifrebut);
		Button myButton3 = (Button) findViewById(R.id.kayitbut);

		myButton.setOnClickListener(new View.OnClickListener() {

			@Override
			public void onClick(View v) {
				EditText email = (EditText) findViewById(R.id.editText1);
				EditText pass = (EditText) findViewById(R.id.editText2);
				new Authenticator(v.getContext()).execute(email.getText().toString(), pass.getText().toString());
				
			}
		});

		myButton2.setOnClickListener(new View.OnClickListener() {

			@Override
			public void onClick(View v) {

				Intent intent = new Intent(Intent.ACTION_VIEW).setData(Uri.parse("https://socivy.com/forgot-password"));
				startActivity(intent);
			}
		});
		
		myButton3.setOnClickListener(new View.OnClickListener() {

			@Override
			public void onClick(View v) {

				Intent intent = new Intent(v.getContext(), RegisterActivity.class);
				startActivity(intent);
			}
		});
		
	}


	@Override
	public void onPause() {
		super.onPause();
	}
	
	@Override
	public void onResume() {
		super.onResume();
	}

	@Override
	public boolean onOptionsItemSelected(MenuItem item) {
		// Handle presses on the action bar items
		return false;
	}
	
	public void createNot() {
		/*NotificationCompat.Builder mBuilder =

		Intent resultIntent = new Intent(this, MainActivity.class);

		// The stack builder object will contain an artificial back stack for the
		// started Activity.
		// This ensures that navigating backward from the Activity leads out of
		// your application to the Home screen.
		TaskStackBuilder stackBuilder = TaskStackBuilder.create(this);
		// Adds the back stack for the Intent (but not the Intent itself)
		stackBuilder.addParentStack(MainActivity.class);
		// Adds the Intent that starts the Activity to the top of the stack
		stackBuilder.addNextIntent(resultIntent);
		PendingIntent resultPendingIntent =
		        stackBuilder.getPendingIntent(
		            0,
		            PendingIntent.FLAG_UPDATE_CURRENT
		        );
		mBuilder.setContentIntent(resultPendingIntent);
		NotificationManager mNotificationManager =
		    (NotificationManager) getSystemService(Context.NOTIFICATION_SERVICE);
		// mId allows you to update the notification later on.
		mNotificationManager.notify(1, mBuilder.build());*/
	}
}
