import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluxmarket/firebase_options.dart';
import 'package:fluxmarket/injection_container.dart';

import 'core/theme/app_theme.dart';
import 'core/widgets/splash_screen.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/cart/presentation/bloc/cart_bloc.dart';
import 'features/checkout/presentation/bloc/checkout_bloc.dart';
import 'features/home/presentation/bloc/home_bloc.dart';
import 'features/profile/presentation/bloc/profile_bloc.dart';
import 'features/profile/presentation/bloc/profile_state.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize dependency injection
  try {
    await configureDependencies();
    runApp(const FluxMarketApp());
  } catch (e, stack) {
    // Print error for debugging
    print('Dependency initialization error: $e');
    print('Stack trace: $stack');
    runApp(
      const MaterialApp(
        home: Scaffold(body: Center(child: Text('Initialization Error'))),
      ),
    );
  }
}

class FluxMarketApp extends StatefulWidget {
  const FluxMarketApp({super.key});

  @override
  State<FluxMarketApp> createState() => _FluxMarketAppState();
}

class _FluxMarketAppState extends State<FluxMarketApp> {
  ThemeMode _themeMode = ThemeMode.light;

  @override
  void initState() {
    super.initState();
    // Load theme preference from ProfileBloc
    final profileBloc = sl<ProfileBloc>();
    _themeMode = profileBloc.currentTheme;
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<HomeBloc>(create: (_) => sl<HomeBloc>()),
        BlocProvider<CartBloc>(create: (_) => sl<CartBloc>()),
        BlocProvider<AuthBloc>(create: (_) => sl<AuthBloc>()),
        BlocProvider<CheckoutBloc>(create: (_) => sl<CheckoutBloc>()),
        BlocProvider<ProfileBloc>(create: (_) => sl<ProfileBloc>()),
      ],
      child: BlocListener<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileLoaded) {
            setState(() {
              _themeMode = state.themeMode;
            });
          }
        },
        child: MaterialApp(
          title: 'FluxMarket',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: _themeMode,
          home: const SplashScreen(),
        ),
      ),
    );
  }
}
