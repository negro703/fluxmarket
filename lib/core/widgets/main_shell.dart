import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import '../../features/cart/presentation/bloc/cart_bloc.dart';
import '../../features/cart/presentation/bloc/cart_event.dart';
import '../../features/cart/presentation/pages/cart_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';

/// Main application shell with bottom navigation bar.
///
/// Provides tab-based navigation between Home, Cart, and Profile pages.
/// This is the main landing page after login/splash.
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  // Lazy load pages to prevent initState from running before BLoCs are ready
  late final List<Widget> _pages = [
    const HomePage(),
    const CartPage(),
    const ProfilePage(),
  ];

  @override
  void initState() {
    super.initState();
    // Load cart data on startup
    // Use post-frame callback to ensure context is available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        try {
          context.read<CartBloc>().add(const LoadCartEvent());
        } catch (e) {
          // BLoC might not be available yet, ignore
          debugPrint('Failed to load cart in main shell: $e');
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: [
          NavigationDestination(
            icon: Icon(
              Icons.store_outlined,
              color: colorScheme.onSurface.withValues(alpha: 0.6),
            ),
            selectedIcon: Icon(Icons.store_rounded, color: colorScheme.primary),
            label: 'Shop',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.shopping_cart_outlined,
              color: colorScheme.onSurface.withValues(alpha: 0.6),
            ),
            selectedIcon: Icon(
              Icons.shopping_cart_rounded,
              color: colorScheme.primary,
            ),
            label: 'Cart',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.person_outline_rounded,
              color: colorScheme.onSurface.withValues(alpha: 0.6),
            ),
            selectedIcon: Icon(
              Icons.person_rounded,
              color: colorScheme.primary,
            ),
            label: 'Profile',
          ),
        ],
        indicatorColor: colorScheme.primary.withValues(alpha: 0.12),
        backgroundColor: colorScheme.surface,
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
      ),
    );
  }
}