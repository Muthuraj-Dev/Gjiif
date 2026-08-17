import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:tjw1/services/api_base_service.dart';
import 'package:tjw1/services/request_method.dart';
import 'package:tjw1/ui/views/otp/otp_screen.dart';
import 'package:toastification/toastification.dart';
import 'package:url_launcher/url_launcher.dart';

class PhoneController extends GetxController {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  FocusNode phoneFocusNode = FocusNode();
  FocusNode otpFocusNode = FocusNode();

  final formKey = GlobalKey<FormState>();

  var isMobileOptCalled = false.obs;
  var isLoading = false.obs;
  bool isAlreadyRegister = false;

  Future<void> mobileOpt() async {
    if (formKey.currentState?.validate() != true) {
      return;
    }
    try {
      isLoading(true);

      final Map<String, dynamic>
      verifyResponse = await ApiBaseService.request<Map<String, dynamic>>(
        'VisitorDetail/VerifyMobileNumber?mobileNumber=${phoneController.text}',
        method: RequestMethod.GET,
        authenticated: false,
      );

      print("KKKK : $verifyResponse");
      if (verifyResponse.isNotEmpty) {
        if (verifyResponse['status'] == "100") {
          toastification.show(
            title: Text('${verifyResponse['message']}'),
            alignment: Alignment.center,
            type: ToastificationType.warning,
            style: ToastificationStyle.flatColored,
            showProgressBar: false,
            autoCloseDuration: const Duration(seconds: 2),
          );

          isAlreadyRegister = true;
          return;
        } else if (verifyResponse['status'] == "200") {
          final data = verifyResponse['data'];
          if (data != null) {
            final otpData = {
              "otpID": data['otpID'],
              "mobileNumber": data['mobileNumber'],
              "visitorID": data['visitorID'],
              "sentOTP": data['sentOTP'],
            };
            Get.to(() => OtpScreen(), arguments: otpData);
          }
        } else {
          final Map<String, dynamic> json =
              await ApiBaseService.request<Map<String, dynamic>>(
                'OTP/ReSendOTP?mobileNumber=${phoneController.text}',
                method: RequestMethod.GET,
                authenticated: false,
              );
          final data = json['data'];
          if (data != null) {
            // await SecureStorageService().write("visitorID", data['visitorID'].toString());
            final otpData = {
              "otpID": data['otpID'],
              "mobileNumber": data['mobileNumber'],
              "visitorID": data['visitorID'],
              "sentOTP": data['sentOTP'],
            };
            Get.to(() => OtpScreen(), arguments: otpData);
          }
        }
      }
    } catch (e) {
      print('Error: $e');
      Get.snackbar("Error", "Something went wrong");
    } finally {
      isLoading(false);
    }
  }

  final String helplineNumber = "+919935043504";

  Future<void> launchCaller() async {
    final Uri phoneUri = Uri(scheme: 'tel', path: helplineNumber);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      print("Could not launch dialer");
    }
  }
}
