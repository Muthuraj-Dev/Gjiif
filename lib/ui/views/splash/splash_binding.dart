import 'package:get/get.dart';
import 'package:tjw1/ui/views/splash/splash_controller.dart';

import '../../../controllers/master_data_controller.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(SplashController());
    Get.put(MasterDataController());
    // Get.put(PaymentController(), permanent: true);
  }
}
