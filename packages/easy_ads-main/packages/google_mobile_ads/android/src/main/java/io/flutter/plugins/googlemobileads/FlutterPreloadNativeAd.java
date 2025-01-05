package io.flutter.plugins.googlemobileads;

import android.content.Context;
import android.util.Log;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import com.google.android.ads.nativetemplates.TemplateView;
import com.google.android.gms.ads.AdListener;
import com.google.android.gms.ads.admanager.AdManagerAdRequest;
import com.google.android.gms.ads.nativead.NativeAd;
import com.google.android.gms.ads.nativead.NativeAd.OnNativeAdLoadedListener;
import com.google.android.gms.ads.nativead.NativeAdOptions;
import com.google.android.gms.ads.nativead.NativeAdView;
import com.google.errorprone.annotations.CanIgnoreReturnValue;
import io.flutter.plugin.platform.PlatformView;
import io.flutter.plugins.googlemobileads.GoogleMobileAdsPlugin.NativeAdFactory;
import io.flutter.plugins.googlemobileads.nativetemplates.FlutterNativeTemplateStyle;
import java.util.Map;

public class FlutterPreloadNativeAd extends FlutterAd {

  private static final String TAG = "FlutterPreloadNativeAd";

  @NonNull
  private final AdInstanceManager manager;

  @NonNull
  private final String adUnitId;

  @Nullable
  private final NativeAdFactory adFactory;

  @NonNull
  private final FlutterAdLoader flutterAdLoader;

  @Nullable
  private FlutterAdRequest request;

  @Nullable
  private FlutterAdManagerAdRequest adManagerRequest;

  @Nullable
  private Map<String, Object> customOptions;

  @Nullable
  private NativeAdView nativeAdView;

  @Nullable
  private final FlutterNativeAdOptions nativeAdOptions;

  @Nullable
  private final FlutterNativeTemplateStyle nativeTemplateStyle;

  @Nullable
  private TemplateView templateView;

  @NonNull
  private final Context context;

  @Nullable
  private NativeAd nativeAd;

  static class Builder {

    @Nullable
    private AdInstanceManager manager;

    @Nullable
    private String adUnitId;

    @Nullable
    private NativeAdFactory adFactory;

    @Nullable
    private FlutterAdRequest request;

    @Nullable
    private FlutterAdManagerAdRequest adManagerRequest;

    @Nullable
    private Map<String, Object> customOptions;

    @Nullable
    private Integer id;

    @Nullable
    private FlutterNativeAdOptions nativeAdOptions;

    @Nullable
    private FlutterAdLoader flutterAdLoader;

    @Nullable
    private FlutterNativeTemplateStyle nativeTemplateStyle;

    @NonNull
    private final Context context;

    Builder(Context context) {
      this.context = context;
    }

    @CanIgnoreReturnValue
    public Builder setAdFactory(@NonNull NativeAdFactory adFactory) {
      this.adFactory = adFactory;
      return this;
    }

    @CanIgnoreReturnValue
    public Builder setId(int id) {
      this.id = id;
      return this;
    }

    @CanIgnoreReturnValue
    public Builder setCustomOptions(
      @Nullable Map<String, Object> customOptions
    ) {
      this.customOptions = customOptions;
      return this;
    }

    @CanIgnoreReturnValue
    public Builder setManager(@NonNull AdInstanceManager manager) {
      this.manager = manager;
      return this;
    }

    @CanIgnoreReturnValue
    public Builder setAdUnitId(@NonNull String adUnitId) {
      this.adUnitId = adUnitId;
      return this;
    }

    @CanIgnoreReturnValue
    public Builder setRequest(@NonNull FlutterAdRequest request) {
      this.request = request;
      return this;
    }

    @CanIgnoreReturnValue
    public Builder setAdManagerRequest(
      @NonNull FlutterAdManagerAdRequest request
    ) {
      this.adManagerRequest = request;
      return this;
    }

    @CanIgnoreReturnValue
    public Builder setNativeAdOptions(
      @Nullable FlutterNativeAdOptions nativeAdOptions
    ) {
      this.nativeAdOptions = nativeAdOptions;
      return this;
    }

    @CanIgnoreReturnValue
    public Builder setFlutterAdLoader(
      @NonNull FlutterAdLoader flutterAdLoader
    ) {
      this.flutterAdLoader = flutterAdLoader;
      return this;
    }

    @CanIgnoreReturnValue
    public Builder setNativeTemplateStyle(
      @Nullable FlutterNativeTemplateStyle nativeTemplateStyle
    ) {
      this.nativeTemplateStyle = nativeTemplateStyle;
      return this;
    }

    FlutterPreloadNativeAd build() {
      if (manager == null) {
        throw new IllegalStateException("AdInstanceManager cannot be null.");
      } else if (adUnitId == null) {
        throw new IllegalStateException("AdUnitId cannot be null.");
      } else if (request == null && adManagerRequest == null) {
        throw new IllegalStateException(
          "adRequest or addManagerRequest must be non-null."
        );
      }

      final FlutterPreloadNativeAd nativeAd;
      if (request == null) {
        nativeAd =
          new FlutterPreloadNativeAd(
            context,
            id,
            manager,
            adUnitId,
            adFactory,
            adManagerRequest,
            flutterAdLoader,
            customOptions,
            nativeAdOptions,
            nativeTemplateStyle
          );
      } else {
        nativeAd =
          new FlutterPreloadNativeAd(
            context,
            id,
            manager,
            adUnitId,
            adFactory,
            request,
            flutterAdLoader,
            customOptions,
            nativeAdOptions,
            nativeTemplateStyle
          );
      }
      return nativeAd;
    }
  }

  protected FlutterPreloadNativeAd(
    @NonNull Context context,
    int adId,
    @NonNull AdInstanceManager manager,
    @NonNull String adUnitId,
    @Nullable NativeAdFactory adFactory,
    @NonNull FlutterAdRequest request,
    @NonNull FlutterAdLoader flutterAdLoader,
    @Nullable Map<String, Object> customOptions,
    @Nullable FlutterNativeAdOptions nativeAdOptions,
    @Nullable FlutterNativeTemplateStyle nativeTemplateStyle
  ) {
    super(adId);
    this.context = context;
    this.manager = manager;
    this.adUnitId = adUnitId;
    this.adFactory = adFactory;
    this.request = request;
    this.flutterAdLoader = flutterAdLoader;
    this.customOptions = customOptions;
    this.nativeAdOptions = nativeAdOptions;
    this.nativeTemplateStyle = nativeTemplateStyle;
  }

  protected FlutterPreloadNativeAd(
    @NonNull Context context,
    int adId,
    @NonNull AdInstanceManager manager,
    @NonNull String adUnitId,
    @Nullable NativeAdFactory adFactory,
    @NonNull FlutterAdManagerAdRequest adManagerRequest,
    @NonNull FlutterAdLoader flutterAdLoader,
    @Nullable Map<String, Object> customOptions,
    @Nullable FlutterNativeAdOptions nativeAdOptions,
    @Nullable FlutterNativeTemplateStyle nativeTemplateStyle
  ) {
    super(adId);
    this.context = context;
    this.manager = manager;
    this.adUnitId = adUnitId;
    this.adFactory = adFactory;
    this.adManagerRequest = adManagerRequest;
    this.flutterAdLoader = flutterAdLoader;
    this.customOptions = customOptions;
    this.nativeAdOptions = nativeAdOptions;
    this.nativeTemplateStyle = nativeTemplateStyle;
  }

  @Override
  void load() {
    final OnNativeAdLoadedListener loadedListener = new FlutterPreloadNativeAdLoadedListener(
      this
    );
    final AdListener adListener = new FlutterNativeAdListener(adId, manager);
    // Note we delegate loading the ad to FlutterAdLoader mainly for testing purposes.
    // As of 20.0.0 of GMA, mockito is unable to mock AdLoader.
    final NativeAdOptions options = this.nativeAdOptions == null
      ? new NativeAdOptions.Builder().build()
      : nativeAdOptions.asNativeAdOptions();
    if (request != null) {
      flutterAdLoader.loadNativeAd(
        adUnitId,
        loadedListener,
        options,
        adListener,
        request.asAdRequest(adUnitId)
      );
    } else if (adManagerRequest != null) {
      AdManagerAdRequest adManagerAdRequest = adManagerRequest.asAdManagerAdRequest(
        adUnitId
      );
      flutterAdLoader.loadAdManagerNativeAd(
        adUnitId,
        loadedListener,
        options,
        adListener,
        adManagerAdRequest
      );
    } else {
      Log.e(TAG, "A null or invalid ad request was provided.");
    }
  }

  @Override
  @Nullable
  public PlatformView getPlatformView() {
    if (nativeAdView != null) {
      return new FlutterPlatformView(nativeAdView);
    } else if (templateView != null) {
      return new FlutterPlatformView(templateView);
    }
    return null;
  }

  void setPlatformView(
    @Nullable NativeAdFactory adFactory,
    @Nullable FlutterNativeTemplateStyle nativeTemplateStyle
  ) {
    if (adFactory == null && nativeTemplateStyle == null) {
      throw new IllegalStateException(
        "NativeAdFactory and nativeTemplateStyle cannot be null."
      );
    }
    if (nativeTemplateStyle != null) {
      templateView = nativeTemplateStyle.asTemplateView(context);
      templateView.setNativeAd(nativeAd);
    } else {
      nativeAdView = adFactory.createNativeAd(nativeAd, customOptions);
    }
  }

  void onNativeAdLoaded(@NonNull NativeAd nativeAd) {
    this.nativeAd = nativeAd;
    nativeAd.setOnPaidEventListener(
      new FlutterPaidEventListener(manager, this)
    );
    manager.onAdLoaded(adId, nativeAd.getResponseInfo());
  }

  @Override
  void dispose() {
    if (nativeAdView != null) {
      nativeAdView.destroy();
      nativeAdView = null;
    }
    if (templateView != null) {
      templateView.destroyNativeAd();
      templateView = null;
    }
  }
}
