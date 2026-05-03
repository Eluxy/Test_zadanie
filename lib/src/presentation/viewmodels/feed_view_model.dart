import 'package:flutter/foundation.dart';
import 'package:iteco_test_zadanie/src/domain/entities/product.dart';
import 'package:iteco_test_zadanie/src/domain/usecases/get_products_page_use_case.dart';

class FeedViewModel extends ChangeNotifier {
  FeedViewModel(this._getProductsPageUseCase);

  final GetProductsPageUseCase _getProductsPageUseCase;
  final List<Product> _products = <Product>[];

  List<Product> get products => List<Product>.unmodifiable(_products);

  bool isInitialLoading = false;
  bool isLoadingMore = false;
  bool hasMore = true;
  String? errorMessage;

  static const int _pageSize = 6;
  int _currentPage = 1;

  Future<void> loadInitial() async {
    _products.clear();
    _currentPage = 1;
    hasMore = true;
    errorMessage = null;
    isInitialLoading = true;
    notifyListeners();

    try {
      final items = await _getProductsPageUseCase(page: _currentPage, limit: _pageSize);
      _products.addAll(items);
      hasMore = items.isNotEmpty;
      _currentPage++;
    } catch (_) {
      errorMessage = 'Не удалось загрузить данные';
    } finally {
      isInitialLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadMore() async {
    if (isLoadingMore || !hasMore || isInitialLoading) {
      return;
    }

    isLoadingMore = true;
    errorMessage = null;
    notifyListeners();

    try {
      final items = await _getProductsPageUseCase(page: _currentPage, limit: _pageSize);
      _products.addAll(items);
      hasMore = items.isNotEmpty;
      _currentPage++;
    } catch (_) {
      errorMessage = 'Ошибка при подгрузке';
    } finally {
      isLoadingMore = false;
      notifyListeners();
    }
  }
}
