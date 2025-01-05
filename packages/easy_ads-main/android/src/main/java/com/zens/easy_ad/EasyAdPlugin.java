package com.zens.easy_ad;

import android.app.Activity;
import android.content.Context;
import android.content.SharedPreferences;
import android.graphics.PixelFormat;
import android.preference.PreferenceManager;
import android.util.Log;
import android.view.View;
import android.view.WindowManager;

import androidx.annotation.NonNull;

import com.zens.easy_ad.ui.FullscreenLoadingDialog;

import io.flutter.FlutterInjector;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.android.FlutterActivityLaunchConfigs;
import io.flutter.embedding.engine.dart.DartExecutor;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

import java.util.Objects;

/**
 * EasyAd_2Plugin
 */
public class EasyAdPlugin
        implements FlutterPlugin, MethodChannel.MethodCallHandler, ActivityAware {

    private MethodChannel channel;
    public static MethodChannel loadingChannel;
    private Context context;
    private Activity mActivity;

    static final String TAG = "EasyAdPlugin";

    @Override
    public void onAttachedToEngine(
            @NonNull FlutterPluginBinding flutterPluginBinding
    ) {
        Log.d(TAG, "onDetachedFromEngine");
        if (channel == null) {
            channel =
                    new MethodChannel(
                            flutterPluginBinding.getBinaryMessenger(),
                            "easy_ads_flutter"
                    );
            channel.setMethodCallHandler(this);
        }

        this.context = flutterPluginBinding.getApplicationContext();

        if (loadingChannel == null) {
            loadingChannel =
                    new MethodChannel(
                            flutterPluginBinding.getBinaryMessenger(),
                            "loadingChannel"
                    );
        }
    }

    @Override
    public void onMethodCall(
            @NonNull MethodCall call,
            @NonNull MethodChannel.Result result
    ) {
        switch (call.method) {
            case "getPlatformVersion":
                result.success("Android " + android.os.Build.VERSION.RELEASE);
                break;
            case "hasConsentForPurposeOne": {
                SharedPreferences sharedPref = PreferenceManager.getDefaultSharedPreferences(
                        context
                );
                // Example value: "1111111111"
                String purposeConsents = sharedPref.getString(
                        "IABTCF_PurposeConsents",
                        ""
                );

                // Purposes are zero-indexed. Index 0 contains information about Purpose 1.
                if (!purposeConsents.isEmpty()) {
                    String purposeOneString = String.valueOf(purposeConsents.charAt(0));
                    boolean hasConsentForPurposeOne = Objects.equals(
                            purposeOneString,
                            "1"
                    );
                    result.success(hasConsentForPurposeOne);
                } else {
                    result.success(null);
                }
                break;
            }
            case "showLoadingAd": {
                long color = (long) call.arguments;
                showOverlayLoading((int) color);
                break;
            }
            case "hideLoadingAd": {
                hideOverlayLoading();
                break;
            }
            default:
                result.notImplemented();
                break;
        }
    }

    private View loadingOverlayView;
    private final WindowManager.LayoutParams loadingOverlayParams = new WindowManager.LayoutParams(
            WindowManager.LayoutParams.MATCH_PARENT,
            WindowManager.LayoutParams.MATCH_PARENT,
            WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY,
            WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE |
                    WindowManager.LayoutParams.FLAG_LAYOUT_IN_SCREEN |
                    WindowManager.LayoutParams.FLAG_LAYOUT_NO_LIMITS,
            PixelFormat.TRANSLUCENT
    );

    private FullscreenLoadingDialog dialog;

    void showOverlayLoading(int color) {
        //        Intent loadingIntent = new Intent(mActivity, FullscreenLoadingActivity.class);
        //        mActivity.startActivity(loadingIntent);

        if (dialog == null) {
            dialog = new FullscreenLoadingDialog(mActivity, color);
        }

        dialog.show();
    }

    void hideOverlayLoading() {
        if (dialog != null) {
            dialog.dismiss();
            dialog = null;
        }
        //        if (loadingOverlayView != null) {
        //            WindowManager wm = (WindowManager) mActivity.getSystemService(Context.WINDOW_SERVICE);
        //            wm.removeView(loadingOverlayView);
        //            loadingOverlayView.invalidate();
        //            loadingOverlayView = null;
        //        }

    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        Log.d(TAG, "onDetachedFromEngine");
        if (channel != null) {
            channel.setMethodCallHandler(null);
            channel = null;
        }

        if (loadingChannel != null) {
            loadingChannel.setMethodCallHandler(null);
            loadingChannel = null;
        }

    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {
    }

    @Override
    public void onReattachedToActivityForConfigChanges(
            @NonNull ActivityPluginBinding binding
    ) {
        mActivity = binding.getActivity();
    }

    @Override
    public void onDetachedFromActivity() {
    }

    @Override
    public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
        mActivity = binding.getActivity();
    }
}
