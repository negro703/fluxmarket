import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/widgets/app_error_widget.dart';
import '../../../../core/widgets/staggered_grid_view.dart';
import '../../domain/entities/product_entity.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';
import '../bloc/home_state.dart';
import '../widgets/product_card.dart';
import '../widgets/product_grid_shimmer.dart';
import 'product_detail_page.dart';
import '../../../cart/presentation/bloc/cart_bloc.dart';
import '../../../cart/presentation/bloc/cart_state.dart';
import '../../../cart/presentation/bloc/cart_event.dart';
import '../../../cart/presentation/pages/cart_page.dart';

/// Main home page that displays a grid of products.
///
/// Uses [HomeBloc] to manage the state and triggers [FetchProductsEvent]
/// on initialization. Features a search bar with debounce and cart badge.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    // Trigger product fetch on page load
    context.read<HomeBloc>().add(const FetchProductsEvent());
    // Load cart to show initial badge count
    context.read<CartBloc>().add(const LoadCartEvent());
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    // Debounce mechanism - 500ms delay
    if (_debounceTimer?.isActive ?? false) {
      _debounceTimer!.cancel();
    }
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      setState(() {
        // Filter will be applied in build method
      });
    });
  }

  List<ProductEntity> _applyFilter(List<ProductEntity> products, String query) {
    if (query.isEmpty) return products;
    final lowercaseQuery = query.toLowerCase();
    return products.where((product) {
      return product.title.toLowerCase().contains(lowercaseQuery) ||
          product.category.toLowerCase().contains(lowercaseQuery) ||
          product.description.toLowerCase().contains(lowercaseQuery);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'FluxMarket',
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: colorScheme.primary,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: SearchBar(
              controller: _searchController,
              onChanged: _onSearchChanged,
              leading: const Icon(Icons.search_rounded),
              hintText: 'Search products...',
              elevation: const MaterialStatePropertyAll(0),
            ),
          ),
        ),
        actions: [
          // Cart badge with item count
          BlocBuilder<CartBloc, CartState>(
            builder: (context, state) {
              int itemCount = 0;
              if (state is CartLoaded) {
                itemCount = state.items.fold<int>(
                  0,
                  (sum, item) => sum + item.quantity,
                );
              }
              return Stack(
                alignment: Alignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.shopping_cart_outlined),
                    onPressed: () {
                      // Navigate to cart page
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const CartPage()),
                      );
                    },
                  ),
                  if (itemCount > 0)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: colorScheme.primary,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '$itemCount',
                            style: GoogleFonts.poppins(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          return switch (state) {
            HomeInitial() => const SizedBox.shrink(),
            HomeLoading() => const ProductGridShimmer(),
            HomeLoaded(products: final products) => _buildProductGrid(
              context,
              products,
              _searchController.text,
            ),
            HomeError(message: final message) => _buildErrorState(
              context,
              message,
            ),
          };
        },
      ),
    );
  }

  Widget _buildProductGrid(
    BuildContext context,
    List<ProductEntity> products,
    String query,
  ) {
    final colorScheme = Theme.of(context).colorScheme;

    // Apply search filter
    final displayedProducts = _applyFilter(products, query);

    // Responsive grid columns based on screen width
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = screenWidth > 900
        ? 4
        : screenWidth > 600
        ? 3
        : 2;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          Text(
            query.isEmpty ? 'Products' : 'Search Results',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            query.isEmpty
                ? '${products.length} items available'
                : '${displayedProducts.length} result${displayedProducts.length != 1 ? 's' : ''} found',
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: displayedProducts.isEmpty
                ? Center(
                    child: Text(
                      'No products found',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: colorScheme.onSurface.withValues(alpha: 0.5),
                      ),
                    ),
                  )
                : StaggeredGridView(
                    itemCount: displayedProducts.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      childAspectRatio: 0.65,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    staggerDelayMilliseconds: 60,
                    animationDuration: const Duration(milliseconds: 350),
                    slideOffset: 25,
                    itemBuilder: (context, index) {
                      final product = displayedProducts[index];
                      return ProductCard(
                        product: product,
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) =>
                                  ProductDetailPage(product: product),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    return AppErrorWidget(
      title: 'Oops! Something went wrong',
      message: message,
      icon: Icons.cloud_off_rounded,
      onRetry: () {
        context.read<HomeBloc>().add(const FetchProductsEvent());
      },
    );
  }
}
