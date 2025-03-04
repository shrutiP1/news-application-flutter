import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:news_app/app/services/network_service.dart';
import 'package:news_app/app/services/news_api_service.dart';

import 'app/routes/app_pages.dart';


void main() async {
  await handleInitializations();
  runApp(const MainApp());
}

Future<void> handleInitializations() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await dotenv.load(fileName: "assets/.env");
  Get.put(NetworkService(), permanent: true);
  await NewsApiService().initialize();
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    );
  }
}
