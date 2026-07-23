import 'package:get/get.dart';

import 'add_visitor_controller.dart';

class AddVisitorBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<AddVisitorController>(AddVisitorController(), permanent: false);
  }
}
