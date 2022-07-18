import 'package:get/get.dart';

import '../controller/bottom_nav_controller.dart';

class InitBinding extends Bindings {
  @override
  void dependencies() {
    // Get.put(AuthController(), permanent: true);
    Get.put(BottomNavController(), permanent: true);
    // Get.put(NewsController(),permanent: true);
    // Get.put(NotificationController(),permanent: true); // 이거 맞나
  }

}
