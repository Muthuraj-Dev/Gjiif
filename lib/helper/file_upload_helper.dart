import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tjw1/services/api_base_service.dart';
import 'package:toastification/toastification.dart';

// enum UploadSource { file, camera, gallery }
//
// class FileUploadHelper {
//   static Future<void> pickAndUploadFile({
//     required UploadSource source,
//     required String fileType,
//     required String gstNumber,
//     required String mobileNumber,
//     required Function(String uploadedFileName, String uploadedFileUrl) onSuccess,
//     required RxBool isUploadLoading,
//     required RxString uploadingKey,
//   }) async {
//     const allowedExtensions = ['jpg', 'pdf'];
//     const maxFileSizeBytes = 2 * 1024 * 1024;
//     File? file;
//
//     try {
//       if (source == UploadSource.file) {
//         final result = await FilePicker.platform.pickFiles(
//           type: FileType.custom,
//           allowedExtensions: allowedExtensions,
//           allowMultiple: false,
//         );
//
//         if (result == null || result.files.single.path == null) {
//           print("No file selected.");
//           return;
//         }
//         file = File(result.files.single.path!);
//       } else {
//
//         final permission = source == UploadSource.camera
//             ? Permission.camera
//             : Permission.photos;
//
//         final status = await permission.request();
//
//         print("STATUS - ${status}");
//
//         if (!status.isGranted) {
//           if (status.isPermanentlyDenied) {
//             CommonDialog.showConfirmDialog(
//               title: "Permission required",
//               content: "Please enable permission from app settings to continue.",
//               confirmText: "Open Settings",
//               cancelTextHide: true,
//               leading: Icon(
//                 Icons.camera_enhance_outlined,
//                 size: 48,
//                 color: AppColor.primary,
//               ),
//               onConfirm: () {
//                 openAppSettings();
//               },
//               dismissible: true
//             );
//           } else {
//             Fluttertoast.showToast(msg: "Permission denied. Please allow access.");
//           }
//           return;
//         }
//
//         final picker = ImagePicker();
//         final pickedFile = await picker.pickImage(
//           source: source == UploadSource.camera ? ImageSource.camera : ImageSource.gallery,
//           imageQuality: 85,
//         );
//
//         if (pickedFile == null) {
//           print("No image selected.");
//           return;
//         }
//         file = File(pickedFile.path);
//       }
//
//       final fileSize = await file.length();
//       if (fileSize > maxFileSizeBytes) {
//         Fluttertoast.showToast(msg: "File too large. Please select a file under 2MB.");
//         return;
//       }
//
//       isUploadLoading(true);
//       uploadingKey.value = fileType;
//
//       final response = await ApiBaseService().uploadImage(
//         file,
//         'SQ/FileUpload',
//         fileCategory: fileType,
//         gstNumber: gstNumber,
//         mobileNumber: mobileNumber,
//       );
//
//       if (response['status'] == "200") {
//         final uploadedFileName = response['data']['fileName'];
//         final uploadedUrl = response['data']['url'];
//
//         onSuccess(uploadedFileName, uploadedUrl);
//
//         toastification.show(
//           title: Text('${response['message']}'),
//           alignment: Alignment.center,
//           type: ToastificationType.success,
//           style: ToastificationStyle.fillColored,
//           showProgressBar: false,
//           autoCloseDuration: const Duration(seconds: 2),
//         );
//         // Fluttertoast.showToast(msg: response['message'] ?? "");
//       } else {
//         Fluttertoast.showToast(msg: "Upload failed. Try again.");
//       }
//     } catch (e) {
//       print("Error during picking/uploading: $e");
//       Fluttertoast.showToast(msg: "Something went wrong. Try again.");
//     } finally {
//       isUploadLoading(false);
//       uploadingKey.value = '';
//     }
//   }
// }

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
      // else if (source == UploadSource.camera) {
      //   final status = await Permission.camera.request();
      //
      //   if (!status.isGranted) {
      //     if (status.isPermanentlyDenied) {
      //       openAppSettings();
      //     } else {
      //       Fluttertoast.showToast(msg: "Camera permission denied");
      //     }
      //     return;
      //   }
      //
      //   final picker = ImagePicker();
      //   final pickedFile = await picker.pickImage(
      //     source: ImageSource.camera,
      //     imageQuality: 85,
      //   );
      //
      //   if (pickedFile == null) return;
      //
      //   file = File(pickedFile.path);
      // }
      // else if (source == UploadSource.camera) {
      //   // Check current status first
      //   final status = await Permission.camera.status;
      //
      //   print("CAMERA STATUS - $status");
      //
      //   if (status.isPermanentlyDenied) {
      //     Fluttertoast.showToast(
      //       msg: "Camera permission is disabled. Enable it from Settings.",
      //     );
      //     return;
      //   }
      //
      //   final result = await Permission.camera.request();
      //
      //   print("CAMERA STATUS 2 - $status");
      //
      //   if (!result.isGranted) {
      //     Fluttertoast.showToast(msg: "Camera permission denied");
      //     return;
      //   }
      //
      //   final picker = ImagePicker();
      //   final pickedFile = await picker.pickImage(
      //     source: ImageSource.camera,
      //     imageQuality: 85,
      //   );
      //
      //   if (pickedFile == null) return;
      //   file = File(pickedFile.path);
      // }
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
