
import 'package:get/get.dart';
class DashboardController extends GetxController {
  var isLoading = false.obs;  // Observable variable to track loading state
  var selectedIndex = 0.obs;


  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments;

    if (args != null && args['selectedIndex'] != null) {
      selectedIndex.value = args['selectedIndex'];
    }

    print("Selected Index: ${selectedIndex.value}");
  }


  // Function to handle tab changes
  // GetX automatically updates the UI based on these changes


  void onItemTapped(int index) {
    print("ONNNNNN $index");
    selectedIndex.value = index;  // Directly update the selected index (no setState needed)
  }

}
