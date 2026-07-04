import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/widgets/app_error_widget.dart';
import '../../../../core/widgets/staggered_grid_view.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';
import '../bloc/home_state.dart';
import '../widgets/product_card.dart';
import '../widgets/product_grid_shimmer.dart';
import 'product_detail_page.dart';

/// Main home page that displays a grid of products.
///
/// Uses [HomeBloc] to manage the state and triggers [FetchProductsEvent]
/// on initialization.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    // Trigger product fetch on page load
    context.read<HomeBloc>().add(const FetchProductsEvent());
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
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined),
            onPressed: () {
              // TODO: Navigate to cart
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

  Widget _buildProductGrid(BuildContext context, List products) {
    final colorScheme = Theme.of(context).colorScheme;

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
            'Products',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${products.length} items available',
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: StaggeredGridView(
              itemCount: products.length,
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
                final product = products[index];
                return ProductCard(
                  product: product,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => ProductDetailPage(product: product),
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