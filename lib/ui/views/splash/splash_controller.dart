import 'dart:async';
import 'dart:convert';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


import '../../../controllers/master_data_controller.dart';
import '../../../locator.dart';
import '../../../services/appconfig_service.dart';
import '../../../services/network_service.dart';
import '../../../services/token_manager.dart';
import '../dashboard/dashboard_screen.dart';
import '../home/home_controller.dart';
import '../payment/payment_controller.dart';
import '../terms/terms_screen.dart';

// class SplashController extends GetxController {
//
//   var isLoading = true.obs;
//
//
//   @override
//   void onInit() {
//     super.onInit();
//     init();
//   }
//
//   /// Initial method called on splash screen load
//   Future<void> init() async {
//     print("INSIDE INIT SPLASH CONTROLLER");
//     // Simulate a short loading time (splash delay)
//     await Future.delayed(const Duration(seconds: 2));
//
//     // Optionally fetch data or check login state
//     // await fetchUserData();
//
//     // Navigate to dashboard (or login depending on logic)
//     Get.off(() => TermsScreen());
//     // OR Get.offNamed('/dashboard');
//   }
//
// }


class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _initApp();
  }

  Future<void> _initApp() async {
    try {
      debugPrint("🚀 Splash init started");

      // // Small splash delay (optional UX)
      // await Future.delayed(const Duration(seconds: 1));

      await _loadRemoteConfig();

      // 2️⃣ NOW config is available → create PaymentController
      final masterData = Get.put(MasterDataController(), permanent: true);
      Get.put(PaymentController(), permanent: true);

      await _initServices();

      debugPrint("✅ App init success");

      // Already have a session from a previous login - skip the
      // Terms/GST/OTP flow entirely and go straight to the Dashboard. If the
      // token has actually expired, the first authenticated call will 401
      // and ApiBaseService's session-expired handler bounces back to GST.
      final existingToken = await TokenManager.getToken();
      if (existingToken != null && existingToken.isNotEmpty) {
        masterData.loadInitialData();
        final homeController = Get.find<HomeController>();
        homeController.fetchBannerEvent();
        homeController.fetchRateCard();
        Get.offAll(() => DashboardScreen());
      } else {
        Get.offAll(() => TermsScreen());
      }
    } catch (e, s) {
      debugPrint("❌ Splash init failed: $e");
      debugPrint("$s");

      Get.snackbar(
        'Startup Error',
        'Unable to initialize app',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}

Future<void> _loadRemoteConfig() async {
  final remoteConfig = FirebaseRemoteConfig.instance;

  await remoteConfig.setDefaults({'config': '{}'});

  await remoteConfig.setConfigSettings(
    RemoteConfigSettings(
      fetchTimeout: const Duration(seconds: 2),
      minimumFetchInterval: Duration.zero,
    ),
  );

  await remoteConfig.fetchAndActivate();

  final rawJson = remoteConfig.getString('config');
  if (rawJson.isNotEmpty && rawJson != '{}') {
    locator<AppConfigService>().setConfig(jsonDecode(rawJson));
  }
}

Future<void> _initServices() async {
  locator<NetworkService>().onInit();

  // Master data (designations/states/company types) now requires an auth
  // token, so it can't be loaded here - it's fetched right after OTP
  // verification succeeds instead (see OtpController).
}


