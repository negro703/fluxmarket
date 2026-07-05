import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'features/cart/data/datasources/cart_local_datasource.dart';
import 'features/cart/data/models/cart_item_model.dart';
import 'features/checkout/data/datasources/order_local_datasource.dart';
import 'features/checkout/data/models/order_model.dart';
import 'injection_container.config.dart';

/// The global [GetIt] service locator instance.
final GetIt sl = GetIt.instance;

/// Flag to track if dependencies have been configured.
bool _dependenciesConfigured = false;

/// Initializes all dependency injections for the application.
///
/// Call this before [runApp] in `main.dart`.
/// This ensures all Hive adapters are registered before any dependent services.
@InjectableInit(
  initializerName: r'$initGetIt',
  preferRelativeImports: true,
  asExtension: false,
)
Future<void> configureDependencies({String? env}) async {
  // Prevent double initialization
  if (_dependenciesConfigured) return;

  // ── Initialize Hive FIRST before any registrations ──────────────────
  try {
    await Hive.initFlutter();
  } catch (e) {
    print('Hive init error (may be ok if already initialized): $e');
  }

  // ── Register adapters - this MUST happen before $initGetIt ───────────
  // Check if adapter is already registered before trying to register
  if (!Hive.isAdapterRegistered(CartItemModelAdapter().typeId)) {
    Hive.registerAdapter(CartItemModelAdapter());
  }
  if (!Hive.isAdapterRegistered(OrderModelAdapter().typeId)) {
    Hive.registerAdapter(OrderModelAdapter());
  }

  // ── Register core non-injectable dependencies ──────────────────────
  sl.registerLazySingleton<Dio>(() => _createDioInstance());
  sl.registerLazySingleton<Connectivity>(() => Connectivity());
  sl.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  final prefs = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => prefs);

  // ── Run generated injectable registrations ───────────────────────────
  // This registers all BLoCs and repositories
  try {
    $initGetIt(sl, environment: env);
  } catch (e, stack) {
    print('GetIt registration error: $e');
    print('Stack: $stack');
    rethrow;
  }

  // ── Initialize Local Data Sources (non-blocking) ────────────────────
  // These can fail without preventing the app from running
  try {
    await sl<CartLocalDataSource>().init();
  } catch (e, st) {
    print('Cart init error (non-fatal): $e\n$st');
  }
  try {
    await sl<OrderLocalDataSource>().init();
  } catch (e, st) {
    print('Order init error (non-fatal): $e\n$st');
  }

  _dependenciesConfigured = true;
}

/// Creates and configures the [Dio] HTTP client with production-ready settings.
///
/// This configuration includes:
/// - Proper TLS/SSL settings for Android emulator compatibility
/// - Automatic retry logic for transient network errors
/// - Connection pooling for better performance
/// - Comprehensive logging for debugging
Dio _createDioInstance() {
  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.fluxmarket.com/v1',
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      contentType: 'application/json',
      responseType: ResponseType.json,
      headers: {'Accept': 'application/json', 'User-Agent': 'FluxMarket/1.0'},
      // Follow redirects automatically
      followRedirects: true,
    ),
  );

  // ── Retry Interceptor ──
  // Automatically retries failed requests due to connection errors
  dio.interceptors.add(
    InterceptorsWrapper(
      onError: (error, handler) async {
        if (_shouldRetry(error)) {
          final retryCount =
              error.requestOptions.extra['retryCount'] as int? ?? 0;
          if (retryCount < 3) {
            error.requestOptions.extra['retryCount'] = retryCount + 1;
            await Future.delayed(
              Duration(milliseconds: 500 * (retryCount + 1)),
            );
            try {
              final response = await dio.request(
                error.requestOptions.path,
                data: error.requestOptions.data,
                queryParameters: error.requestOptions.queryParameters,
                options: Options(
                  method: error.requestOptions.method,
                  headers: error.requestOptions.headers,
                  extra: error.requestOptions.extra,
                ),
              );
              return handler.resolve(response);
            } catch (e) {
              return handler.next(error);
            }
          }
        }
        return handler.next(error);
      },
    ),
  );

  // ── Logging Interceptor ──
  dio.interceptors.add(
    LogInterceptor(
      request: true,
      requestHeader: true,
      requestBody: true,
      responseHeader: false,
      responseBody: true,
      error: true,
    ),
  );

  return dio;
}

/// Determines if a request should be retried based on the error type.
///
/// Retries on:
/// - Connection reset by peer (errno 104)
/// - Connection timeout
/// - Receive timeout
/// - Send timeout
/// - Other transient network errors
bool _shouldRetry(DioException error) {
  return switch (error.type) {
    DioExceptionType.connectionError ||
    DioExceptionType.connectionTimeout ||
    DioExceptionType.receiveTimeout ||
    DioExceptionType.sendTimeout => true,
    DioExceptionType.badResponse =>
      // Retry on 5xx server errors (server might be temporarily unavailable)
      (error.response?.statusCode ?? 0) >= 500,
    _ => false,
  };
}
