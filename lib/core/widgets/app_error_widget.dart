import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// A reusable global error widget that can be used across all pages.
///
/// Provides a consistent error UI with:
/// - An animated error icon
/// - Custom error message
/// - Optional retry action
/// - Optional custom illustration
class AppErrorWidget extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback? onRetry;
  final IconData icon;
  final String? retryLabel;
  final Widget? customIllustration;

  const AppErrorWidget({
    super.key,
    this.title = 'Oops! Something went wrong',
    required this.message,
    this.onRetry,
    this.icon = Icons.cloud_off_rounded,
    this.retryLabel,
    this.customIllustration,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ── Custom or default icon ──
            if (customIllustration != null)
              SizedBox(
                width: 120,
                height: 120,
                child: customIllustration,
              )
            else
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: colorScheme.error.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 48,
                  color: colorScheme.error,
                ),
              ),

            const SizedBox(height: 24),

            // ── Title ──
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 12),

            // ── Message ──
            Text(
              message,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: colorScheme.onSurface.withValues(alpha: 0.6),
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),

            // ── Retry Button ──
            if (onRetry != null) ...[
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh_rounded, size: 20),
                label: Text(retryLabel ?? 'Try Again'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 28,
                    vertical: 14,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}