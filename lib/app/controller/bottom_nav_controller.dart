import 'package:get/get.dart';

enum PageName{HOME, List, Chat, Setting,}

class BottomNavController extends GetxController {

  RxInt pageIndex = 0.obs;

  void changeBottomNav(int value) {
    var page = PageName.values[value];
    switch(page) {
      case PageName.HOME:
      case PageName.List:
      case PageName.Chat:
      case PageName.Setting:
        _changePage(value);
        break;
    };
    print("페이지 변경");
  }

  void _changePage(int value) {
    pageIndex(value);
  }

}