import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:tjw1/controllers/master_data_controller.dart';
import 'package:tjw1/ui/views/add_visitor/add_visitor_controller.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(MasterDataController(), permanent: true);
    Get.put<AddVisitorController>(AddVisitorController(), permanent: false,
    );
  }
}
