import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluxmarket/core/theme/app_theme.dart';
import 'package:fluxmarket/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:fluxmarket/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:fluxmarket/features/home/presentation/bloc/home_bloc.dart';
import 'package:fluxmarket/features/home/presentation/pages/home_page.dart';
import 'package:fluxmarket/injection_container.dart' as di;
import 'package:fluxmarket/injection_container.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize dependency injection
  await di.configureDependencies();

  runApp(const FluxMarketApp());
}

class FluxMarketApp extends StatelessWidget {
  const FluxMarketApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<HomeBloc>(create: (_) => sl<HomeBloc>()),
        BlocProvider<CartBloc>(create: (_) => sl<CartBloc>()),
        BlocProvider<AuthBloc>(create: (_) => sl<AuthBloc>()),
      ],
      child: MaterialApp(
        title: 'FluxMarket',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.light,
        home: const HomePage(),
      ),
    );
  }
}