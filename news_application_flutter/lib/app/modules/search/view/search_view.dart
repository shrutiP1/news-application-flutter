// lib/app/modules/search/view/search_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:news_app/app/modules/home/controller/home_controller.dart';

class SearchView extends StatelessWidget {
  const SearchView({super.key});

  @override
  Widget build(BuildContext context) {
    final homeController = Get.find<HomeController>();
    final customeSearchController = homeController.customeSearchController;

    return Padding(
      padding: const EdgeInsets.all(15),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: customeSearchController.searchController,
              focusNode: customeSearchController.searchFocusNode,
              decoration: InputDecoration(
                hintText: 'Search news...',
                hintStyle: const TextStyle(color: Colors.white),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(color: Colors.white),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(color: Colors.white),
                ),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.clear,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        customeSearchController.searchController.clear();
                        homeController.searchQuery.value = '';
                        customeSearchController.searchFocusNode
                            .unfocus(); // Remove focus
                        homeController.searchNews(homeController
                            .customeSearchController.searchController.text);
                      },
                    ),
                  ],
                ),
              ),
              style: const TextStyle(color: Colors.white),
              onChanged: (value) {
                customeSearchController.searchNews(value);
              },
              onSubmitted: (value) {
                customeSearchController.searchNews(value);
                customeSearchController.printRecentSearches();
              },
            ),
          ),
        ],
      ),
    );
  }
}
