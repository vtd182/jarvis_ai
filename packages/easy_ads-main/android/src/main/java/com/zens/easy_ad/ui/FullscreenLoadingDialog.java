package com.zens.easy_ad.ui;

import android.app.Dialog;
import android.content.Context;
import android.os.Bundle;
import android.os.Handler;
import android.util.Log;
import android.view.View;
import android.view.ViewGroup;
import android.view.Window;

import androidx.annotation.NonNull;
import androidx.lifecycle.Lifecycle;
import androidx.lifecycle.LifecycleObserver;
import androidx.lifecycle.OnLifecycleEvent;
import androidx.lifecycle.ProcessLifecycleOwner;

import com.google.android.material.progressindicator.CircularProgressIndicator;
import com.zens.easy_ad.EasyAdPlugin;
import com.zens.easy_ad.R;

public class FullscreenLoadingDialog extends Dialog implements LifecycleObserver {
    static final String TAG = "FullscreenLoadingDialog";

    private Boolean adFailedToShow = false;
    private Boolean isResume = true;
    private final int color;

    public FullscreenLoadingDialog(@NonNull Context context, int color) {
        super(context, R.style.LoadingTheme);

        this.color = color;
        Log.d(TAG, String.valueOf(this.color));
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.layout_fullscreen_loading);
        Window window = getWindow();
        if (window != null) {
            window.setLayout(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT);
            window.getDecorView().setSystemUiVisibility(View.SYSTEM_UI_FLAG_LAYOUT_STABLE | View.SYSTEM_UI_FLAG_LAYOUT_HIDE_NAVIGATION | View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN | View.SYSTEM_UI_FLAG_HIDE_NAVIGATION | View.SYSTEM_UI_FLAG_IMMERSIVE);
        }
        setCancelable(false);
        CircularProgressIndicator cpi = findViewById(R.id.progressBar);
        cpi.setIndicatorColor(color);
    }

    @Override
    protected void onStart() {
        super.onStart();
        Log.d(TAG, "onStart");
        ProcessLifecycleOwner.get().getLifecycle().addObserver(this);
        EasyAdPlugin.loadingChannel.setMethodCallHandler((call, result) -> {
            switch (call.method) {
                case "handleShowAd":
                    showAd();
                    result.success(null);
                    break;
                case "closeAd":
                    closeAd();
                    result.success(null);
                    break;
                default:
                    result.notImplemented();
                    break;
            }
        });
    }

    @Override
    protected void onStop() {
        super.onStop();
        Log.d(TAG, "onStop");
        ProcessLifecycleOwner.get().getLifecycle().removeObserver(this);
        EasyAdPlugin.loadingChannel.setMethodCallHandler(null);
    }

    void showAd() {
        new Handler().postDelayed(() -> {
            if (isResume) {
                EasyAdPlugin.loadingChannel.invokeMethod("showAd", null);
            } else {
                adFailedToShow = true;
            }
        }, 1000);
    }

    void closeAd() {
        dismiss();
    }

    @OnLifecycleEvent(Lifecycle.Event.ON_STOP)
    void onAppBackgrounded() {
        Log.d(TAG, "onAppBackgrounded");
        isResume = false;
    }

    @OnLifecycleEvent(Lifecycle.Event.ON_START)
    void onAppForegrounded() {
        Log.d(TAG, "onAppForegrounded");
        isResume = true;
        if (adFailedToShow) {
            showAd();
        }
    }
}
