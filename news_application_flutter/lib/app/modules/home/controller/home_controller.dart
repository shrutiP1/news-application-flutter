import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:news_app/app/constants/constants.dart';
import 'package:news_app/app/constants/news_utils.dart';
import 'package:news_app/app/constants/snackbar_utils.dart';
import 'package:news_app/app/model/news_article_model.dart';
import 'package:news_app/app/modules/detail/view/detail_view.dart';
import 'package:news_app/app/modules/search/controller/search_controller.dart';
import 'package:news_app/app/services/api_exception.dart';
import 'package:news_app/app/services/network_service.dart';
import 'package:news_app/app/services/news_api_service.dart';
import 'package:news_app/app/services/news_storage_utils.dart';

class HomeController extends GetxController {
  final NewsApiService _newsService = NewsApiService();
  final NetworkService _networkService = Get.find<NetworkService>();
  final TextEditingController searchController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();
  final NewsSearchController customeSearchController =
      Get.put(NewsSearchController());

  RxList<NewsArticle> articles = <NewsArticle>[].obs;
  RxBool isLoading = false.obs;
  RxBool isLoadingMore = false.obs;
  RxBool hasError = false.obs;
  RxString errorMessage = ''.obs;
  RxString searchQuery = ''.obs;
  RxInt page = 1.obs;
  RxBool hasMorePages = true.obs;
  final RxBool hasText = false.obs;

  late final NewsStorageUtils _cache;

  @override
  void onInit() async {
    super.onInit();
    _cache = await NewsStorageUtils.initialize();
    fetchInitialNews();
  }

  @override
  void onClose() {
    searchController.dispose();
    searchFocusNode.dispose();
    super.onClose();
  }

  void navigateToDetailView({
    required NewsArticle article,
  }) {
    if (_networkService.isConnected.value) {
      Get.to(() => ArticleDetailScreen(article: article));
    } else {
      hasError.value = true;
      SnackbarUtils.showSnackbar(
        message: "No internet! Cannot navigate to detail page",
        isSuccess: false,
      );
    }
  }

  Future<void> fetchInitialNews() async {
    try {
      isLoading.value = true;
      page.value = 1;
      hasMorePages.value = true;
      hasError.value = false;

      if (!_networkService.isConnected.value) {
        final recentSearches = await _cache.getRecentSearches();
        if (recentSearches.isNotEmpty) {
          final latestQuery = recentSearches.first;
          final cachedArticles = await _cache.getCachedArticles(latestQuery);

          if (cachedArticles != null) {
            articles.value = cachedArticles;
            searchQuery.value = latestQuery;
            hasMorePages.value = false;
            SnackbarUtils.showSnackbar(
              message: "Showing cached results for query: $latestQuery",
              isSuccess: true,
            );
            return;
          }
        }
      }

      // If online or no cache available, proceed with normal search
      final response = await _newsService.searchArticles(
        query: searchQuery.value.isEmpty
            ? NewsUtils.getRandomTopic()
            : searchQuery.value,
        page: page.value,
        useCache: !_networkService.isConnected.value,
      );
      if (response.articles.isNotEmpty) {
        articles.value = response.articles;
        hasMorePages.value = response.articles.length >= Constants.pageSize;
      } else {
        errorMessage.value = 'No News found for this search';
        hasError.value = true;
      }
    } catch (e) {
      if (e is ApiException) {
        errorMessage.value = e.message;
      }
      hasError.value = true;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> pullToRefresh() async {
    searchQuery.value = "";
    searchController.text = "";
    hasText.value = false;
    page.value = 1;
    await fetchInitialNews();
  }

  Future<void> searchNews(String query) async {
    if (!_networkService.isConnected.value) {
      SnackbarUtils.showSnackbar(
        message: "No internet connection. Search is disabled.",
        isSuccess: false,
      );
      return;
    }

    searchQuery.value = query;
    page.value = 1; // Reset to the first page
    await fetchInitialNews(); // Fetch news based on the search query
  }

  Future<void> loadMore() async {
    if (!hasMorePages.value ||
        isLoadingMore.value ||
        !_networkService.isConnected.value) return;

    try {
      isLoadingMore.value = true;
      page.value++;

      final response = await _newsService.searchArticles(
        query: searchQuery.value.isEmpty
            ? NewsUtils.getRandomTopic()
            : searchQuery.value,
        page: page.value,
      );

      articles.addAll(response.articles);
      hasMorePages.value = response.articles.length >= Constants.pageSize;
    } catch (e) {
      if (e is ApiException) {
        errorMessage.value = e.message;
      }
      hasError.value = true;
      SnackbarUtils.showSnackbar(
        message: "Failed to load more news",
        isSuccess: false,
      );
      page.value--;
    } finally {
      isLoadingMore.value = false;
    }
  }
}
