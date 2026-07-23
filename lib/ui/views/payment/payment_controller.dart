import 'package:flutter/material.dart';
import 'package:flutter_cashfree_pg_sdk/api/cferrorresponse/cferrorresponse.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpayment/cfdropcheckoutpayment.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpaymentgateway/cfpaymentgatewayservice.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfsession/cfsession.dart';
import 'package:flutter_cashfree_pg_sdk/utils/cfenums.dart';
import 'package:flutter_cashfree_pg_sdk/utils/cfexceptions.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../../../locator.dart';
import '../../../services/api_base_service.dart';
import '../../../services/appconfig_service.dart';
import '../../../services/request_method.dart';
import '../dashboard/dashboard_controller.dart';

class PaymentController extends GetxController {
  final CFPaymentGatewayService _pgService = CFPaymentGatewayService();

  final RxString paymentStatus = ''.obs;
  bool _isPaymentInProgress = false;

  String? _eventId; // <-- Add this


  /// Change this based on build flavor
  // static const CFEnvironment _environment = CFEnvironment.SANDBOX;

  @override
  void onInit() {
    super.onInit();
    _initCallbacks();
    _loadEnvironment();
  }

  /// Initialize callbacks ONCE
  void _initCallbacks() {
    _pgService.setCallback(_onPaymentSuccess, _onPaymentFailure);
  }

  late CFEnvironment _environment;
  CFEnvironment get environment => _environment;

  /// Load environment from AppConfig dynamically
  void _loadEnvironment() {
    final newConfig = locator<AppConfigService>().config;

    print("newConfig ${newConfig.cashfreeEnvironment}");

    final envString = newConfig.cashfreeEnvironment?.trim().toLowerCase();
    print("envString $envString");

    _environment = switch (envString) {
      'production' => CFEnvironment.PRODUCTION,
      'prod' => CFEnvironment.PRODUCTION,
      'sandbox' => CFEnvironment.SANDBOX,
      'dev' => CFEnvironment.SANDBOX,
      _ => CFEnvironment.SANDBOX,
    };

    debugPrint("💰 Cashfree Environment: $_environment");
  }

  /// Start payment
  void startPayment({required String orderId, required String orderToken, required String eventId,}) {
    if (_isPaymentInProgress) {
      debugPrint('⚠️ Payment already in progress');
      return;
    }

    _eventId = eventId; // Save for callback

    _isPaymentInProgress = true;

    try {
      final session =
          CFSessionBuilder()
              .setEnvironment(_environment)
              .setOrderId(orderId)
              .setPaymentSessionId(orderToken)
              .build();

      final payment =
          CFDropCheckoutPaymentBuilder().setSession(session).build();

      _pgService.doPayment(payment);
    } on CFException catch (e) {
      _isPaymentInProgress = false;
      debugPrint('❌ CFException: ${e.message}');
      rethrow;
    }
  }

  /// Success handler
  // void _onPaymentSuccess(String orderId) {
  //   paymentStatus.value = 'SUCCESS';
  //   _isPaymentInProgress = false;
  //
  //   debugPrint('✅ Payment Successful: $orderId');
  //
  //   Fluttertoast.showToast(
  //     msg: "Payment Successful",
  //     backgroundColor: Colors.green,
  //     textColor: Colors.white,
  //   );
  //
  //   Get.offAllNamed('/dashboard');
  // }

  Future<void> _onPaymentSuccess(String orderId) async {
    paymentStatus.value = 'VERIFYING';
    _isPaymentInProgress = false;

    if (_eventId == null) {
      Fluttertoast.showToast(
        msg: "Event ID not found",
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }

    try {
      final response = await confirmOrder(
        orderId: orderId,
        eventId: _eventId!,
      );

      final status =
      (response['orderStatus'] ?? '').toString().toUpperCase();

      if (status == 'SUCCESS') {
        paymentStatus.value = 'SUCCESS';

        Fluttertoast.showToast(
          msg: "Payment Successful",
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );

        // final dashboardController = Get.find<DashboardController>();
        //
        // dashboardController.onItemTapped(2); // Registered tab

        Get.offAllNamed(
          '/dashboard',
          arguments: {
            'selectedIndex': 2,
          },
        );

        // Get.offAllNamed('/dashboard');

      } else {
        paymentStatus.value = 'FAILED';

        Fluttertoast.showToast(
          msg: response['error_details'] ?? 'Payment verification failed',
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    } catch (e) {
      paymentStatus.value = 'FAILED';

      Fluttertoast.showToast(
        msg: "Unable to verify payment",
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    } finally {
      _eventId = null; // Clear after verification
    }
  }

  Future<Map<String, dynamic>> confirmOrder({
    required String orderId,
    required String eventId,
  }) async {
    try {
      final response = await ApiBaseService.request<Map<String, dynamic>>(
        'PG/ConfirmOrder?OrderID=$orderId&EventID=$eventId',
        method: RequestMethod.GET,
        authenticated: false,
      );

      return response;
    } catch (e) {
      debugPrint("❌ ConfirmOrder Error: $e");
      rethrow;
    }
  }

  /// Failure handler

  /// FAILURE CALLBACK (matches SDK exactly)
  void _onPaymentFailure(CFErrorResponse error, String orderId) {
    paymentStatus.value = 'FAILED';
    _isPaymentInProgress = false;

    debugPrint(
      '❌ Payment Failed | Order: $orderId | '
      'Code: ${error.getCode()} | '
      'Message: ${error.getMessage()}',
    );

    Fluttertoast.showToast(
      msg: "Payment Failed: ${error.getMessage()}",
      backgroundColor: Colors.red,
      textColor: Colors.white,
    );
  }
}
