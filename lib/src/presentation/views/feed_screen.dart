import 'package:flutter/material.dart';
import 'package:iteco_test_zadanie/src/data/datasources/fake_store_remote_data_source.dart';
import 'package:iteco_test_zadanie/src/data/repositories/product_repository_impl.dart';
import 'package:iteco_test_zadanie/src/domain/usecases/get_products_page_use_case.dart';
import 'package:iteco_test_zadanie/src/presentation/viewmodels/feed_view_model.dart';
import 'package:iteco_test_zadanie/src/presentation/widgets/product_card.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  static const String routeName = '/feed';

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  late final FeedViewModel _viewModel;
  final ScrollController _scrollController = ScrollController();
  bool _isAutoFillScheduled = false;

  @override
  void initState() {
    super.initState();
    _viewModel = FeedViewModel(
      GetProductsPageUseCase(
        ProductRepositoryImpl(
          FakeStoreRemoteDataSource(),
        ),
      ),
    );
    _viewModel.addListener(_scheduleAutoFillCheck);
    _viewModel.loadInitial();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _viewModel.removeListener(_scheduleAutoFillCheck);
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    _viewModel.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) {
      return;
    }
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _viewModel.loadMore();
    }
  }

  void _scheduleAutoFillCheck() {
    if (_isAutoFillScheduled) {
      return;
    }
    _isAutoFillScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _isAutoFillScheduled = false;
      _autoFillUntilScrollable();
    });
  }

  void _autoFillUntilScrollable() {
    if (!_scrollController.hasClients) {
      return;
    }
    if (_viewModel.isInitialLoading || _viewModel.isLoadingMore || !_viewModel.hasMore) {
      return;
    }
    if (_scrollController.position.maxScrollExtent <= 0) {
      _viewModel.loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Каталог товаров'),
        centerTitle: true,
      ),
      body: AnimatedBuilder(
        animation: _viewModel,
        builder: (context, _) {
          if (_viewModel.isInitialLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (_viewModel.products.isEmpty) {
            return Center(
              child: Text(_viewModel.errorMessage ?? 'Товары не найдены'),
            );
          }

          return RefreshIndicator(
            onRefresh: _viewModel.loadInitial,
            child: ListView.builder(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: _viewModel.products.length + (_viewModel.isLoadingMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index >= _viewModel.products.length) {
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                return ProductCard(product: _viewModel.products[index]);
              },
            ),
          );
        },
      ),
    );
  }
}
