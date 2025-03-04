import 'package:get/get.dart';
import 'package:news_app/app/modules/search/controller/search_controller.dart';

class SearchBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(NewsSearchController());
  }
}
