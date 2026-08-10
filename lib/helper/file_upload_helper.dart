import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tjw1/services/api_base_service.dart';
import 'package:toastification/toastification.dart';

enum UploadSource { file, camera, gallery }

class FileUploadHelper {
  static Future<void> pickAndUploadFile({
    required UploadSource source,
    required String fileType,
    required String gstNumber,
    required String mobileNumber,
    required Function(String uploadedFileName, String uploadedFileUrl)
    onSuccess,
    required RxBool isUploadLoading,
    required RxString uploadingKey,
  }) async {
    const allowedExtensions = ['jpg', 'pdf'];
    const maxFileSizeBytes = 2 * 1024 * 1024;
    File? file;

    try {
      /// ---------------- FILE PICKER (PDF / DOCS) ----------------
      if (source == UploadSource.file) {
        final result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: allowedExtensions,
          allowMultiple: false,
        );

        if (result == null || result.files.single.path == null) return;

        file = File(result.files.single.path!);
      }
      /// ---------------- CAMERA ----------------
      else if (source == UploadSource.camera) {
        final status = await Permission.camera.request();

        print("CAMERA STATUS (request result) - $status");

        if (status.isGranted) {
          final picker = ImagePicker();
          final pickedFile = await picker.pickImage(
            source: ImageSource.camera,
            imageQuality: 85,
          );

          if (pickedFile == null) return;
          file = File(pickedFile.path);

        } else if (status.isPermanentlyDenied) {
          Fluttertoast.showToast(
            msg: "Camera permission is disabled. Enable it from Settings.",
          );
          // Optional but correct UX:
          // openAppSettings();
        } else {
          Fluttertoast.showToast(msg: "Camera permission denied");
        }
      }
      /// ---------------- GALLERY (ANDROID + iOS SAFE) ----------------
      else if (source == UploadSource.gallery) {
        // ❗ DO NOT request Permission.photos on iOS
        final picker = ImagePicker();
        final pickedFile = await picker.pickImage(
          source: ImageSource.gallery,
          imageQuality: 85,
        );

        if (pickedFile == null) return;

        file = File(pickedFile.path);
      }

      /// ---------------- FILE SIZE CHECK ----------------
      final fileSize = await file!.length();
      if (fileSize > maxFileSizeBytes) {
        Fluttertoast.showToast(
          msg: "File too large. Please select a file under 2MB.",
        );
        return;
      }

      /// ---------------- UPLOAD ----------------
      isUploadLoading(true);
      uploadingKey.value = fileType;

      final response = await ApiBaseService().uploadImage(
        file,
        'SQ/FileUpload',
        fileCategory: fileType,
        gstNumber: gstNumber,
        mobileNumber: mobileNumber,
      );

      if (response['status'] == "200") {
        onSuccess(response['data']['fileName'], response['data']['url']);

        toastification.show(
          title: Text(response['message'] ?? "Uploaded"),
          alignment: Alignment.center,
          type: ToastificationType.success,
          style: ToastificationStyle.fillColored,
          autoCloseDuration: const Duration(seconds: 2),
        );
      } else {
        Fluttertoast.showToast(msg: "Upload failed. Try again.");
      }
    } catch (e) {
      debugPrint("Upload error: $e");
      Fluttertoast.showToast(msg: "Something went wrong");
    } finally {
      isUploadLoading(false);
      uploadingKey.value = '';
    }
  }
}
