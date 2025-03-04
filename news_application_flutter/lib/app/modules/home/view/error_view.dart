import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:news_app/app/constants/constants.dart';
import 'package:news_app/app/modules/home/controller/home_controller.dart';

class ErrorView extends StatelessWidget {
  const ErrorView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 20,
          ),
          const Text(
            'Something went wrong',
            style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 30,
            ),
          ),
          Center(
            child: Container(
              color: Colors.red,
              child: Image.asset(
                Constants.errorPng,
              ),
            ),
          ),

          // New section to display the error message
          Obx(() {
            if (controller.hasError.value &&
                controller.errorMessage.isNotEmpty) {
              return Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Text(
                  controller.errorMessage.value,
                  style: const TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.center,
                ),
              );
            }
            return const SizedBox
                .shrink(); // Return an empty widget if no error
          }),

          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: OutlinedButton(
              onPressed: () {
                controller.searchNews(controller
                    .customeSearchController
                    .searchController
                    .text); // Call search on change             controller.fetchInitialNews();
              },
              child: const Text('Retry'),
            ),
          )
        ],
      ),
    );
  }
}
