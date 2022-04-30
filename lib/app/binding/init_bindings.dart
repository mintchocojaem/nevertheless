import 'package:get/get.dart';
import 'package:pomodoro/app/controller/bottom_nav_controller.dart';

class InitBinding extends Bindings {
  @override
  void dependencies() {
    // Get.put(AuthController(), permanent: true);
    Get.put(BottomNavController(), permanent: true);
    // Get.put(NewsController(),permanent: true);
    // Get.put(NotificationController(),permanent: true); // 이거 맞나
  }



  // static BottomNavBinding() {
  //   Get.put(BottomNavController(), permanent: true);
  // }

  static additionalBinding() {
    // Get.put(MypageController(), permanent: true);
    // Get.put(PostController(), permanent: true);
    // Get.put(ChatroomController(), permanent: true);
  }

  static commentBinding() {
    // Get.put(CommentController(),permanent: false);
    // Get.lazyPut(() => CommentController());
  }

  static chatroomBinding(String chatroomKey) {
    // Get.lazyPut(() => ChatController(chatroomKey));
  }

}