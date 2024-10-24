import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:jarvis_ai/modules/subscribe/presentation/widget/loading_widget.dart';

class SubscribeController extends SuperController {
  // use another screen to update UI
  final isShowSub = true.obs;

  final canDismiss = false.obs;
  final currentItem = 0.obs;
  final isFromSetting = false.obs;
  final onSubScreen = false.obs;
  var canPress = true;

  //in app purchase
  final String weekSubscriptionId = 'weekly';
  final String monthSubscriptionId = 'monthly';
  final String yearSubscriptionId = 'yearly';

  Rx<ProductDetailsResponse> productDetailResponse =
      ProductDetailsResponse(productDetails: [], notFoundIDs: []).obs;
  final List<String> _kProductIds = [];

  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? _subscription;
  DialogRoute? router;

  init() {
    onSubScreen.value = true;
  }

  initStream() async {
    final Stream<List<PurchaseDetails>> purchaseUpdated =
        _inAppPurchase.purchaseStream;
    _subscription = purchaseUpdated.listen((purchaseDetailsList) async {
      print("tpoo purchaseDetailsList ${purchaseDetailsList.length}");
      if (purchaseDetailsList.isEmpty) {
        return;
      }
      _listenToPurchaseUpdated(purchaseDetailsList);
    }, onDone: () {
      print("tpoo onDone");
    }, onError: (Object error) {
      print("tpoo onError $error");
    });
  }

  @override
  Future<void> onInit() async {
    _kProductIds.addAll([
      weekSubscriptionId,
      monthSubscriptionId,
      yearSubscriptionId,
    ]);

    // productDetailResponse.value =
    //     await _inAppPurchase.queryProductDetails(_kProductIds.toSet());

    // for (var i in productDetailResponse.value.productDetails) {
    //   if (i.id == weekSubscriptionId) {
    //     productDetailResponse.value.productDetails.remove(i);
    //     productDetailResponse.value.productDetails.insert(0, i);
    //   }
    //   if (i.id == monthSubscriptionId) {
    //     productDetailResponse.value.productDetails.remove(i);
    //     productDetailResponse.value.productDetails.insert(1, i);
    //   }
    //   if (i.id == yearSubscriptionId) {
    //     productDetailResponse.value.productDetails.remove(i);
    //     productDetailResponse.value.productDetails.insert(2, i);
    //   }
    // }

    productDetailResponse.value.productDetails.addAll(
      [
        ProductDetails(id: weekSubscriptionId, title: "Weekly", description: "", price: "6.99", rawPrice: 9.99, currencyCode: "USD",currencySymbol: "\$"),
        ProductDetails(id: monthSubscriptionId, title: "Monthly", description: "Most popular", price: "6.99", rawPrice: 9.99, currencyCode: "USD",currencySymbol: "\$"),
        ProductDetails(id: yearSubscriptionId, title: "Yearly", description: "", price: "6.99", rawPrice: 9.99, currencyCode: "USD",currencySymbol: "\$"),
      ]
    );
    super.onInit();
  }

  @override
  void onClose() {
    if (Platform.isIOS) {
      final InAppPurchaseStoreKitPlatformAddition iosPlatformAddition =
          _inAppPurchase
              .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
      iosPlatformAddition.setDelegate(null);
    }
    currentItem.value = 0;
    canDismiss.value = false;
    super.onClose();
  }

  Future<void> _listenToPurchaseUpdated(
      List<PurchaseDetails> purchaseDetailsList) async {
    for (final PurchaseDetails purchaseDetails in purchaseDetailsList) {
      try {
        print("tpoo status ${purchaseDetails.status}");
        if (purchaseDetails.status == PurchaseStatus.pending) {
          showLoading();
        } else if (purchaseDetails.status == PurchaseStatus.canceled) {
          hideLoading();
          await _inAppPurchase.completePurchase(purchaseDetails);
        } else {
          if (purchaseDetails.status == PurchaseStatus.error) {
            hideLoading();
            ScaffoldMessenger.of(Get.context!).showSnackBar(const SnackBar(
              content: Text("Payment not ready"),
            ));
            await _inAppPurchase.completePurchase(purchaseDetails);
          } else if (purchaseDetails.status == PurchaseStatus.purchased) {
            await _inAppPurchase.completePurchase(purchaseDetails);
            final bool valid = await _verifyPurchase(purchaseDetails);
            if (valid) {
              // update unlimited token
            }
          } else if (purchaseDetails.status == PurchaseStatus.restored) {
            await _inAppPurchase.completePurchase(purchaseDetails);
            final bool valid = await _verifyPurchase(purchaseDetails);
            if (valid) {
              // update unlimited token
            }
          } else {
            await _inAppPurchase.completePurchase(purchaseDetails);
          }
        }
      } catch (e) {
        await _inAppPurchase.completePurchase(purchaseDetails);
        ScaffoldMessenger.of(Get.context!).showSnackBar(const SnackBar(
          content: Text("Sub warning"),
        ));
      }
    }
  }

  Future<bool> _verifyPurchase(PurchaseDetails purchaseDetails) {
    return Future<bool>.value(true);
  }

  onItemtap(int index) {
    currentItem.value = index;
  }

  Future<void> onPlaceOrder() async {
    // EventLog.logEvent("IAP_purchase", params: {
    //   "purchase_value": productDetailResponse
    //       .value.productDetails[currentItem.value].id
    //       .replaceRange(0, 4, ""),
    //   "place": where,
    // });
    if (canPress) {
      canPress = false;
      showLoading();
      final bool isAvailable = await _inAppPurchase.isAvailable();
      if (isAvailable) {
        try {
          await _inAppPurchase
              .buyNonConsumable(
            purchaseParam: PurchaseParam(
              productDetails:
                  productDetailResponse.value.productDetails[currentItem.value],
            ),
          )
              .then(
            (value) {
              if (value) {
                print("tpoo hide 1 ");
              } else {
                print("tpoo hide 2 ");

                hideLoading();
                ScaffoldMessenger.of(Get.context!).showSnackBar(const SnackBar(
                  content: Text("Sub warning"),
                ));
              }
            },
          );
          Future.delayed(const Duration(seconds: 2), () => canPress = true);
        } catch (e) {
          ScaffoldMessenger.of(Get.context!).showSnackBar(const SnackBar(
            content: Text("Sub warning"),
          ));
          Future.delayed(const Duration(seconds: 2), () => canPress = true);
        }
      } else {
        ScaffoldMessenger.of(Get.context!).showSnackBar(const SnackBar(
          content: Text("Sub warning"),
        ));
      }
    }
  }

  Future<void> onRestore() async {
    showLoading();
    await _inAppPurchase.restorePurchases().whenComplete(() => hideLoading());
  }

  Future<void> showLoading() async {
    if (router != null) {
      hideLoading();
    }
    if (Get.context != null) {
      router = DialogRoute(
        context: Get.context!,
        builder: (context) => const LoadingWidget(),
      );
      Navigator.push(Get.context!, router!);
    }
  }

  Future<void> hideLoading() async {
    if (Get.context != null && router != null) {
      Navigator.removeRoute(Get.context!, router!);
      router = null;
    }
  }

  @override
  void onDetached() {}

  @override
  void onHidden() {}

  @override
  void onInactive() {}

  @override
  void onPaused() {}

  @override
  void onResumed() {}
}
