import 'package:get/get.dart';

enum PageName{HOME, List, Chat,}

class BottomNavController extends GetxController {

  RxInt pageIndex = 0.obs;

  void changeBottomNav(int value) {
    var page = PageName.values[value];
    switch(page) {
      case PageName.HOME:
      case PageName.List:
      case PageName.Chat:
        _changePage(value);
        break;
    };
  }

  void _changePage(int value) {
    pageIndex(value);
  }

}
