import 'package:get/get.dart';
import '../ui/index_page.dart';

enum PageName{timer, todo, chart}

class BottomNavController extends GetxController {

  @override
  void onInit() {
    super.onInit();
    loadTodoList();
  }


  RxInt pageIndex = 0.obs;

  void changeBottomNav(int value) {
    var page = PageName.values[value];
    switch(page) {
      case PageName.timer:
      case PageName.todo:
      case PageName.chart:
        _changePage(value);
        break;
    };
  }

  void _changePage(int value) {
    pageIndex(value);
  }

}
