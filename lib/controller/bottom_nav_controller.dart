import 'package:get/get.dart';
import '../ui/index_page.dart';

class BottomNavController extends GetxController {

  //IndexScreen 클래스에서 메인 화면으로 표시되는 Canvas 위젯의 하단부인 BottomNavigationBar의 Item을 클릭시 어플이 페이지를 이동할 수 있게 도와주는 역할을 합니다.
  @override
  void onInit() {
    super.onInit();
    loadTodoList();
  }

  RxInt pageIndex = 0.obs;

  void changeBottomNav(int value) {
    switch(value) {
      case 0:
      case 1:
      case 2:
        _changePage(value);
        break;
    };
  }

  void _changePage(int value) {
    pageIndex(value);
  }

}
