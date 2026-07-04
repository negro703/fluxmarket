import 'package:flutter/material.dart';

/// A centralized helper for showing consistent snackbar messages
/// across the entire application.
///
/// Usage:
/// ```dart
/// SnackMessage.show(context, 'Product added to cart');
/// SnackMessage.showSuccess(context, 'Checkout complete!');
/// SnackMessage.showError(context, 'Something went wrong');
/// ```
class SnackMessage {
  SnackMessage._();

  /// Shows a default informational snackbar.
  static void show(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
  }) {
    _showSnack(context, message, _SnackType.info, duration);
  }

  /// Shows a success snackbar with a check icon.
  static void showSuccess(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
  }) {
    _showSnack(context, message, _SnackType.success, duration);
  }

  /// Shows an error snackbar with an error icon.
  static void showError(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 4),
  }) {
    _showSnack(context, message, _SnackType.error, duration);
  }

  /// Shows a warning snackbar with a warning icon.
  static void showWarning(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
  }) {
    _showSnack(context, message, _SnackType.warning, duration);
  }

  static void _showSnack(
    BuildContext context,
    String message,
    _SnackType type,
    Duration duration,
  ) {
    final colorScheme = Theme.of(context).colorScheme;

    final (Color bgColor, IconData icon) = switch (type) {
      _SnackType.success => (const Color(0xFF16A34A), Icons.check_circle_rounded),
      _SnackType.error => (colorScheme.error, Icons.error_rounded),
      _SnackType.warning => (const Color(0xFFD97706), Icons.warning_rounded),
      _SnackType.info => (colorScheme.primary, Icons.info_rounded),
    };

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(icon, color: Colors.white, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: bgColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          duration: duration,
          action: SnackBarAction(
            label: 'Dismiss',
            textColor: Colors.white.withValues(alpha: 0.8),
            onPressed: () {},
          ),
        ),
      );
  }
}

enum _SnackType { info, success, error, warning }