/// Application-wide constants for the FluxMarket e-commerce app.
class AppConstants {
  AppConstants._();

  // ── App Info ──
  static const String appName = 'FluxMarket';
  static const String appVersion = '1.0.0';

  // ── API Configuration ──
  static const String apiBaseUrl = 'https://api.fluxmarket.com/v1';
  static const Duration apiTimeout = Duration(seconds: 30);
  static const String apiContentType = 'application/json';

  // ── Cache & Storage ──
  static const String cacheBoxName = 'fluxmarket_cache';
  static const Duration cacheExpiry = Duration(hours: 1);

  // ── Pagination ──
  static const int defaultPageSize = 20;
  static const int initialPage = 1;

  // ── UI Constants ──
  static const double defaultPadding = 16.0;
  static const double defaultBorderRadius = 12.0;
  static const double cardBorderRadius = 16.0;
  static const double defaultIconSize = 24.0;
  static const double smallIconSize = 16.0;

  // ── Animation ──
  static const Duration shortAnimationDuration = Duration(milliseconds: 200);
  static const Duration mediumAnimationDuration = Duration(milliseconds: 350);
  static const Duration longAnimationDuration = Duration(milliseconds: 500);
}
