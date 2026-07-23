import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';

import '../common_widget/common_dialog.dart';
import '../core/res/colors.dart';

class OneSignalService {
  static const String _appId = "22b3d945-d73e-4d7c-a206-5112f98e7c5f";
  static Future<void> init(BuildContext context) async {
    if (kDebugMode) {
      OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
    }

    OneSignal.initialize(_appId);
    debugPrint("🔥 OneSignal initialized");

    // // ✅ HANDLE OS PERMISSION FIRST
    await requestNotificationPermission(context);

    // ✅ READ CURRENT STATE
    final sub = OneSignal.User.pushSubscription;
    debugPrint("📌 CURRENT SUB ID: ${sub.id}");
    debugPrint("📌 CURRENT TOKEN: ${sub.token}");
    debugPrint("📌 CURRENT OPTED IN: ${sub.optedIn}");

    // ✅ LISTEN FOR FUTURE CHANGES
    OneSignal.User.pushSubscription.addObserver((state) {
      debugPrint("🔄 Subscription observer fired");
      debugPrint("SUB ID: ${state.current.id}");
      debugPrint("TOKEN: ${state.current.token}");
      debugPrint("OPTED IN: ${state.current.optedIn}");
      if (state.current.id != null) {
        // 🔥 SEND TO BACKEND
      }
    });
  }

  /// ✅ SIMPLE HELPER FOR UI
  static bool get isNotificationEnabled {
    return OneSignal.User.pushSubscription.optedIn == true;
  }

  /// ✅ OPTIONAL: expose subscription ID safely
  static String? get subscriptionId {
    return OneSignal.User.pushSubscription.id;
  }

  static Future<void> requestNotificationPermission(
    BuildContext context,
  ) async {
    // Android 13+ requires runtime permission
    final status = await Permission.notification.status;

    debugPrint("🔔 Notification permission status: $status");

    if (status.isGranted) {
      return;
    }

    if (status.isPermanentlyDenied) {
      _showSettingsDialog(context);
      return;
    }

    // Ask permission
    final result = await Permission.notification.request();

    if (result.isGranted) {
      return;
    }

    if (result.isPermanentlyDenied) {
      _showSettingsDialog(context);
    } else {
      Fluttertoast.showToast(msg: "Please allow notifications to stay updated");
    }
  }

  static void _showSettingsDialog(BuildContext context) {
    CommonDialog.showConfirmDialog(
      title: "Enable Notifications",
      content:
          "Notifications are disabled. Please enable them from app settings to receive updates.",
      confirmText: "Open Settings",
      cancelTextHide: true,
      leading: Icon(
        Icons.notifications_active_outlined,
        size: 48,
        color: AppColor.primary,
      ),
      onConfirm: () {
        openAppSettings();
      },
      dismissible: true,
    );
  }
}


//1️⃣ Attach Your User ID (MOST IMPORTANT)
//
// After the user logs into your app, call:
//
// Future<void> attachUser(String userId) async {
//   await OneSignal.login(userId);
//
//   debugPrint("👤 OneSignal user attached: $userId");
// }
//
// Example:
//
// await OneSignalService.attachUser("123");
//
// Now OneSignal internally stores:
//
// External User ID → Devices
// 123 → device_A
// 123 → device_B
//
// Now backend can send:
//
// "include_external_user_ids": ["123"]
//
// and the correct user receives the push.


//{
//   "app_id": "YOUR_APP_ID",
//   "target_channel": "push",
//   "include_aliases": {
//     "external_id": ["123"]
//   },
//   "headings": { "en": "New Comment" },
//   "contents": { "en": "Someone commented on your video" },
//   "data": {
//     "type": "comment",
//     "video_id": "456"
//   }
// }

//2️⃣ Send to Specific Devices
//
// If you stored the subscription ID from your Flutter observer:
//
// state.current.id
//
// Then you can target devices directly.
//
// {
//   "app_id": "YOUR_APP_ID",
//   "target_channel": "push",
//   "include_subscription_ids": [
//     "SUBSCRIPTION_ID_1"
//   ],
//   "contents": {
//     "en": "Device specific notification"
//   }
// }
//
// But normally external_id is better.


//3️⃣ Send to a User Segment
//
// Example: all pro users
//
// First your app sets tag:
//
// OneSignal.User.addTag("plan", "pro");
//
// Then send push:
//
// {
//   "app_id": "YOUR_APP_ID",
//   "target_channel": "push",
//   "filters": [
//     {
//       "field": "tag",
//       "key": "plan",
//       "relation": "=",
//       "value": "pro"
//     }
//   ],
//   "headings": {
//     "en": "Pro Feature"
//   },
//   "contents": {
//     "en": "New feature available for Pro users"
//   }
// }
// 4️⃣ Send Using a Template
//
// If you create a template in OneSignal dashboard:
//
// {
//   "app_id": "YOUR_APP_ID",
//   "template_id": "TEMPLATE_ID",
//   "include_aliases": {
//     "external_id": ["123"]
//   }
// }

//5️⃣ Sending Deep Link Data to Flutter
//
// Use data.
//
// Example:
//
// {
//   "app_id": "YOUR_APP_ID",
//   "include_aliases": {
//     "external_id": ["123"]
//   },
//   "headings": {
//     "en": "Video Ready"
//   },
//   "contents": {
//     "en": "Your video is ready"
//   },
//   "data": {
//     "screen": "video_review",
//     "video_id": "987"
//   }
// }
//
// Flutter can read it when notification clicked.

//3️⃣ Flutter Listens for Click Event
//
// Inside your OneSignal initialization add:
//
// OneSignal.Notifications.addClickListener((event) {
//   final data = event.notification.additionalData;
//
//   if (data == null) return;
//
//   final screen = data["screen"];
//
//   if (screen == "video_review") {
//     final videoId = data["video_id"];
//
//     Navigator.pushNamed(
//       navigatorKey.currentContext!,
//       "/videoReview",
//       arguments: videoId,
//     );
//   }
// });
//
// This is where the deep link navigation happens.