// dart format width=80
// ignore_for_file: avoid_print

import 'dart:io';
import 'dart:math' as math;
import 'package:image/image.dart' as img;

/// Generates a professional shopping cart icon for FluxMarket.
/// Creates a 1024x1024 PNG with a shopping cart on a gradient background.
void main() {
  const width = 1024;
  const height = 1024;

  // Create a transparent image
  final image = img.Image(width: width, height: height);

  // Draw gradient background (indigo gradient)
  for (int y = 0; y < height; y++) {
    for (int x = 0; x < width; x++) {
      final t = y / height;
      final r = (79 + (99 - 79) * t).round();   // 79 -> 99
      final g = (70 + (102 - 70) * t).round();   // 70 -> 102
      final b = (229 + (241 - 229) * t).round(); // 229 -> 241
      image.setPixelRgba(x, y, r, g, b, 255);
    }
  }

  // Draw shopping cart icon
  final cx = width ~/ 2;   // center x
  final cy = height ~/ 2;  // center y
  final scale = width ~/ 32;

  // Cart body (rounded rectangle)
  _fillRoundedRect(image, cx - 10 * scale, cy - 6 * scale, 20 * scale, 12 * scale, 3 * scale, 255, 255, 255, 255);

  // Cart handle
  _fillRoundedRect(image, cx - 8 * scale, cy - 10 * scale, 16 * scale, 4 * scale, 2 * scale, 255, 255, 255, 255);

  // Left wheel
  _fillCircle(image, cx - 7 * scale, cy + 7 * scale, 3 * scale, 79, 70, 229, 255);
  _fillCircle(image, cx - 7 * scale, cy + 7 * scale, 2 * scale, 255, 255, 255, 255);

  // Right wheel
  _fillCircle(image, cx + 7 * scale, cy + 7 * scale, 3 * scale, 79, 70, 229, 255);
  _fillCircle(image, cx + 7 * scale, cy + 7 * scale, 2 * scale, 255, 255, 255, 255);

  // Horizontal line through cart
  _fillRect(image, cx - 9 * scale, cy - 1 * scale, 18 * scale, 2 * scale, 79, 70, 229, 255);

  // Vertical line through cart
  _fillRect(image, cx - 1 * scale, cy - 5 * scale, 2 * scale, 10 * scale, 79, 70, 229, 255);

  // Save as PNG
  final png = img.encodePng(image);
  final file = File('assets/icons/app_icon.png');
  file.writeAsBytesSync(png);
  print('Icon generated successfully: assets/icons/app_icon.png');
  print('Size: ${file.lengthSync()} bytes');
}

void _fillRoundedRect(img.Image image, int x, int y, int w, int h, int r, int red, int green, int blue, int alpha) {
  for (int py = y; py < y + h; py++) {
    for (int px = x; px < x + w; px++) {
      if (px >= 0 && px < image.width && py >= 0 && py < image.height) {
        // Check if pixel is inside rounded corners
        bool inside = true;
        if (px < x + r && py < y + r) {
          inside = (math.pow(px - (x + r), 2) + math.pow(py - (y + r), 2)) <= math.pow(r, 2);
        } else if (px >= x + w - r && py < y + r) {
          inside = (math.pow(px - (x + w - r - 1), 2) + math.pow(py - (y + r), 2)) <= math.pow(r, 2);
        } else if (px < x + r && py >= y + h - r) {
          inside = (math.pow(px - (x + r), 2) + math.pow(py - (y + h - r - 1), 2)) <= math.pow(r, 2);
        } else if (px >= x + w - r && py >= y + h - r) {
          inside = (math.pow(px - (x + w - r - 1), 2) + math.pow(py - (y + h - r - 1), 2)) <= math.pow(r, 2);
        }
        if (inside) {
          image.setPixelRgba(px, py, red, green, blue, alpha);
        }
      }
    }
  }
}

void _fillRect(img.Image image, int x, int y, int w, int h, int red, int green, int blue, int alpha) {
  for (int py = y; py < y + h; py++) {
    for (int px = x; px < x + w; px++) {
      if (px >= 0 && px < image.width && py >= 0 && py < image.height) {
        image.setPixelRgba(px, py, red, green, blue, alpha);
      }
    }
  }
}

void _fillCircle(img.Image image, int cx, int cy, int r, int red, int green, int blue, int alpha) {
  for (int py = cy - r; py <= cy + r; py++) {
    for (int px = cx - r; px <= cx + r; px++) {
      if (px >= 0 && px < image.width && py >= 0 && py < image.height) {
        if (math.pow(px - cx, 2) + math.pow(py - cy, 2) <= math.pow(r, 2)) {
          image.setPixelRgba(px, py, red, green, blue, alpha);
        }
      }
    }
  }
}