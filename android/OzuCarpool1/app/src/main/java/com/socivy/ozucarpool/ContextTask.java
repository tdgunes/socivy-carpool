package com.socivy.ozucarpool;

import android.content.Context;
import android.os.AsyncTask;

public abstract class ContextTask<Params, Progress, Result> extends AsyncTask<Params, Progress, Result>{
	
	public Context context;
	public ContextTask(Context context) {
		this.context = context;
	}
}
