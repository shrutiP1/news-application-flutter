import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:news_app/app/modules/home/controller/home_controller.dart';
import 'package:news_app/app/services/news_storage_utils.dart';

class NewsSearchController extends GetxController {
  final RxList<String> recentSearches = <String>[].obs;
  TextEditingController searchController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();
  Timer? _debounce; // Timer for debouncing

  @override
  void onInit() {
    super.onInit();
    _loadRecentSearches();
  }

  Future<void> _loadRecentSearches() async {
    final cache = await NewsStorageUtils.initialize();
    recentSearches.value = await cache.getRecentSearches();
  }

  void addSearchQuery(String query) {
    if (query.isNotEmpty && !recentSearches.contains(query)) {
      if (recentSearches.length >= 5) {
        recentSearches.removeAt(0);
      }
      recentSearches.add(query);
    }
  }

  /// Method to print recent searches
  void printRecentSearches() {
    ///recentSearches as all the data to show in future that which are last 5 recent seaches of the user
    // print("Recent Searches: ${recentSearches.join(', ')}");
  }

  void searchNews(String query) {
    final HomeController homeController = Get.find<HomeController>();
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    // Start a new timer
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      if (query.length < 3) return; // Only search if 3 or more characters

      // Update recent searches
      if (query.isNotEmpty && !recentSearches.contains(query)) {
        if (recentSearches.length >= 5) {
          recentSearches.removeAt(0); // Remove the oldest search
        }
        recentSearches.add(query); // Add the new search
        homeController
            .searchNews(query); // Call the search method from HomeController
      }
    });
  }

  void clearRecentSearches() async {
    final cache = await NewsStorageUtils.initialize();
    await cache.clearCache();
    recentSearches.clear();
  }
}
