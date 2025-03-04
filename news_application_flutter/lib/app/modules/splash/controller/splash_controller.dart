import 'package:get/get.dart';
import 'package:news_app/app/routes/app_pages.dart';

class SplashController extends GetxController {
  @override
  void onInit() async {
    super.onInit();
    _navigateToHomePage();
  }

  Future<void> _navigateToHomePage() async {
    await Future.delayed(const Duration(seconds: 2));
    Get.offAllNamed(Routes.home);
  }
}
