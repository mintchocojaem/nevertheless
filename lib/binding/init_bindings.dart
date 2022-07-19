import 'package:get/get.dart';

import '../controller/bottom_nav_controller.dart';

class InitBinding extends Bindings {

  //Dependency Injection을 분리하는 클래스이다. 상태 관리자 및 Dependency 관리자로 라우팅 된다.

  @override
  void dependencies() {
    Get.put(BottomNavController(), permanent: true);
  }

}
