import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

import '../ui/views/gst/gst_screen.dart';
import 'json_parsers.dart';
import 'secure_storage_service.dart';
import 'token_manager.dart';

class ApiBaseService {
  static const String baseUrl =
      'https://apptest.gjiif.in/'; // 'https://app.gjiif.in/';
  static final _logger = Logger();
  static final http.Client _httpClient = http.Client();

  static Future<List<T>> requestList<T>(
    String endpoint, {
    String method = 'GET',
    Object? body,
    Map<String, String>? params,
    bool authenticated = true,
  }) async {
    try {
      var response = await _sendAsync(
        method,
        endpoint,
        body,
        queryParams: params,
        authenticated: authenticated,
      );
      if (response != null) {
        var jsonResponse = jsonDecode(response.body);
        if (response.statusCode == 200 || response.statusCode == 204) {
          return jsonResponse
              .map((item) => JsonParsers.fromJson<T>(item))
              .cast<T>()
              .toList();
        } else {
          throw Exception('Error: ${response.body}');
        }
      }
    } on TimeoutException {
      Fluttertoast.showToast(
        msg: "There is a problem connecting to the server.",
      );
    } catch (exception) {
      print('Exception: $exception');
    }
    throw ApiException("No Response: something went wrong");
  }

  static Future<T> request<T>(
    String endpoint, {
    String method = 'GET',
    Object? body,
    Map<String, String>? params,
    bool authenticated = true,
  }) async {
    const timeoutDuration = Duration(seconds: 10);
    try {
      var response = await _sendAsync(
        method,
        endpoint,
        body,
        queryParams: params,
        authenticated: authenticated,
      ).timeout(timeoutDuration);
      if (response != null) {
        var jsonResponse = jsonDecode(response.body);
        if (response.statusCode == 200 ||
            response.statusCode == 201 ||
            response.statusCode == 204) {
          return JsonParsers.fromJson<T>(jsonResponse);
        } else {
          throw Exception('Error: ${response.body}');
        }
      }
    } on TimeoutException {
      Fluttertoast.showToast(
        msg: "There is a problem connecting to the server.",
      );
    } catch (exception) {
      print('Exception: $exception');
    }
    //  throw Exception("No Response: something error");
    throw ApiException("No Response: something went wrong");
  }

  static Future<http.Response?> _sendAsync(
    String method,
    String endpoint,
    Object? body, {
    Map<String, String>? queryParams,
    bool authenticated = true,
  }) async {
    var url = Uri.parse(
      baseUrl +
          endpoint +
          (queryParams != null
              ? '?${Uri(queryParameters: queryParams).query}'
              : ""),
    );
    var requestMessage = http.Request(method, url);

    print("=== API URL : $requestMessage");
    print("=== API BODY DATA : $body");

    if (body != null && body is! http.MultipartRequest) {
      requestMessage.body = json.encode(body);
    }

    requestMessage.headers.addAll(await _headers(body, authenticated));

    if (kDebugMode) {
      print("=== HEADER : ${requestMessage.headers}");
    }

    http.Response? response;

    try {
      if (body is http.MultipartRequest) {
        body.headers.addAll(requestMessage.headers);
        response = await http.Response.fromStream(await body.send());
      } else {
        response = await http.Response.fromStream(
          await _httpClient.send(requestMessage),
        );
      }
    } on HttpException catch (e) {
      if (kDebugMode) {
        print("HTTP Exception: $e");
      }
      Fluttertoast.showToast(msg: "HTTP Exception: $e");
    }

    return _handleResponse(response);
  }

  static Future<Map<String, String>> _headers(
    Object? body,
    bool authenticated,
  ) async {
    Map<String, String> headerParams = {};
    headerParams["Content-Type"] = "application/json";
    if (body is String) {
      //    headerParams["Content-Type"] = "application/x-www-form-urlencoded";
      headerParams['Content-Type'] = 'application/json';
    } else if (body is Map) {
      headerParams['Accept'] = "application/json";
      headerParams["Content-Type"] = "application/json";
    } else if (body is http.MultipartRequest) {
      headerParams['Accept'] = "application/json";
      headerParams["Content-Type"] = "multipart/form-data";
    }

    // Attach the saved auth token whenever one is available, regardless of
    // the `authenticated` flag, so every request automatically carries it
    // once the user is logged in. Endpoints called before login (no token
    // saved yet) are unaffected - the header is simply omitted, exactly as
    // before. There is no refresh-token API, so an expired token is just
    // sent as-is - the server's 401 response is what triggers the
    // session-expired handling in `_handleResponse`.
    String token = await _getToken();

    if (token.isNotEmpty) {
      headerParams['Authorization'] = 'Bearer $token';
    } else if (authenticated) {
      throw Exception('Token is not available.');
    }

    return headerParams;
  }

  static Future<http.Response?> _handleResponse(http.Response? response) async {
    if (response == null) {
      return null;
    }
    debugPrint("=== RESPONSE : ${response.body}");
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return response;
    } else if (response.statusCode == 401) {
      await _handleSessionExpired();
    } else if (response.statusCode >= 400 && response.statusCode < 500) {
      Fluttertoast.showToast(msg: "${jsonDecode(response.body)['message']}");
    } else if (response.statusCode >= 500) {
      Fluttertoast.showToast(msg: "Server Error: ${response.statusCode}");
    }
    return null;
  }

  static bool _isHandlingSessionExpiry = false;

  // No refresh-token API exists, so a 401 means the session is over: clear
  // the stored session and send the user back to the GST screen, same as a
  // manual Logout. Guarded so concurrent requests only trigger this once.
  static Future<void> _handleSessionExpired() async {
    if (_isHandlingSessionExpiry) return;
    _isHandlingSessionExpiry = true;

    Fluttertoast.showToast(msg: "Your session has expired");

    await TokenManager.deleteToken();
    await TokenManager.deleteTokenExpiry();
    await SecureStorageService().delete("gst");
    await SecureStorageService().delete("mobileNumber");
    await SecureStorageService().delete("visitorID");

    Get.offAll(() => GstScreen());

    _isHandlingSessionExpiry = false;
  }

  Future<dynamic> uploadImage(
    File file,
    String endpoint, {
    required String fileCategory,
    required String gstNumber,
    required String mobileNumber,
  }) async {
    var uri = Uri.parse(baseUrl + endpoint);

    var request =
        http.MultipartRequest('POST', uri)
          ..files.add(
            await http.MultipartFile.fromPath('uploadedFile', file.path),
          )
          ..fields['fileCategory'] = fileCategory
          ..fields['gstNumber'] = gstNumber
          ..fields['mobileNumber'] = mobileNumber;

    // 🖨️ Print request details
    print('📤 UPLOADING TO: $uri');
    print('📄 FILE PATH: ${file.path}');
    print('📁 FIELD fileCategory: $fileCategory');
    print('🏢 FIELD gstNumber: $gstNumber');
    print('📱 FIELD mobileNumber: $mobileNumber');
    print('🧾 HEADERS: ${request.headers}');

    var response = await _sendAsync(
      'POST',
      endpoint,
      request,
      authenticated: false,
    );

    if (response != null && response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    throw Exception("Image upload failed");
  }

  // Get Token from Secure Storage
  static Future<String> _getToken() async {
    return await TokenManager.getToken() ?? '';
  }
}

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, {this.statusCode});

  @override
  String toString() {
    return "ApiException: $message (Status Code: $statusCode)";
  }
}
