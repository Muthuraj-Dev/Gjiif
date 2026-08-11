import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:linkify_plus/linkify_plus.dart';
import 'package:tjw1/ui/views/setting/setting_controller.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../common_widget/common_dialog.dart';
import '../../../core/res/colors.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  final SettingController controller = Get.put(SettingController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFDF7DF),
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        title: Image.asset('assets/GJIIF_Logo.png', height: 35),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/splash_background.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Settings",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildExpandableTile(
                      title: "Terms & Conditions",
                      content: controller.termsContent,
                    ),
                    SizedBox(height: 12),
                    _buildExpandableTile(
                      title: "Privacy Policy",
                      content: controller.privacyPolicyContent,
                    ),
                    SizedBox(height: 12),
                    _buildExpandableTile(
                      title: "Refunds/Cancellation",
                      content: controller.refundCancellationContent,
                    ),
                    SizedBox(height: 12),
                    _buildExpandableTile(
                      title: "Shipping/Delivery",
                      content:
                          'Last updated on Feb. 01, 2023. Shipping is not applicable for business',
                    ),
                    // SizedBox(height: 12),
                    // _buildExpandableTile(
                    //   title: "Account Deletion and Data Retention",
                    //   content: controller.accountDeletion,
                    // ),
                    SizedBox(height: 12),
                    GestureDetector(
                      onTap: () {
                        CommonDialog.showCustomDialog(
                          content: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.logout,
                                  size: 50,
                                  color: AppColor.primary,
                                ),
                                const SizedBox(height: 16),
                                const Text(
                                  "Log Out",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                const Text(
                                  "Are you sure you want to log out of your account?",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black54,
                                  ),
                                ),
                                const SizedBox(height: 24),
                                Row(
                                  children: [
                                    Expanded(
                                      child: OutlinedButton(
                                        onPressed: () {
                                          Get.back(); // No
                                        },
                                        child: const Text("No"),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: () {
                                          Get.back(); // Close dialog
                                          controller.logout();
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: AppColor.primary,
                                        ),
                                        child: const Text(
                                          "Yes",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: const Color(0xffFCF4CB),
                          border: Border.all(color: Colors.grey.shade300),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],

                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            children: [
                              Icon(Icons.logout, size: 20),
                              SizedBox(width: 16),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Log-Out",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    "Sign out of your account",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xff5C5C5C),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 12),

                    GestureDetector (
                      onTap: (){
                        CommonDialog.showCustomDialog(
                          content: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.delete_forever_rounded,
                                  size: 50,
                                  color: AppColor.primary,
                                ),
                                const SizedBox(height: 16),
                                const Text(
                                  "Delete Account",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                const Text(
                                  "Are you sure you want to delete your account?\nThis action cannot be undone.",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black54,
                                  ),
                                ),
                                const SizedBox(height: 24),
                                Row(
                                  children: [
                                    Expanded(
                                      child: OutlinedButton(
                                        onPressed: () {
                                          Get.back(); // No
                                        },
                                        child: const Text("No"),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: () {
                                          Get.back(); // Close dialog
                                          controller.deleteAccount();
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: AppColor.primary,
                                        ),
                                        child: const Text(
                                          "Yes",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: const Color(0xffFCF4CB),
                          border: Border.all(color: Colors.grey.shade300),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],

                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            children: [
                              Icon(Icons.delete_outline, size: 22),
                              SizedBox(width: 16),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Delete",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    "Remove your account",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xff5C5C5C),

                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Version : 1.0.0"),
          ),
        ],
      ),
    );
  }

  // Widget _buildExpandableTile({
  //   required String title,
  //   required String content,
  // }) {
  //   return Container(
  //     decoration: BoxDecoration(
  //       color: Color(0xffFCF4CB),
  //       borderRadius: BorderRadius.circular(10),
  //       border: Border.all(color: Colors.grey.shade300),
  //       boxShadow: [
  //         BoxShadow(
  //           color: Colors.grey.withOpacity(0.1),
  //           blurRadius: 4,
  //           offset: Offset(0, 2),
  //         ),
  //       ],
  //     ),
  //     child: ExpansionTile(
  //       tilePadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  //       title: Text(
  //         title,
  //         style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
  //       ),
  //       childrenPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
  //       children: [
  //         Text(
  //           content,
  //           style: TextStyle(fontSize: 14, color: Colors.grey[700]),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildExpandableTile({
    required String title,
    required String content,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xffFCF4CB),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Text(
          title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
        ),
        childrenPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 10,
        ),
        children: [
          Linkify(
            text: content,
            style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            linkStyle: const TextStyle(
              color: Colors.blue,
              decoration: TextDecoration.underline,
            ),
            onOpen: (link) async {
              final Uri url = Uri.parse(link.url);
              if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
                throw Exception('Could not launch ${link.url}');
              }
            },
          ),
        ],
      ),
    );
  }
}
