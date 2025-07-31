import 'package:flutter/material.dart';
import 'dart:async';

enum SnackbarType { success, info, error }

/// A custom snackbar utility that doesn't rely on ScaffoldMessenger
/// Uses Overlay to display snackbar messages independent of the widget tree
class CustomSnackbar {
  static OverlayEntry? _currentSnackbar;
  static Timer? _snackbarTimer;

  /// Shows a custom snackbar with styling based on the specified type.
  ///
  /// [context] - The BuildContext for showing the Snackbar
  /// [message] - The message to display in the Snackbar
  /// [type] - The type of Snackbar (success, info, error)
  /// [duration] - How long the Snackbar should be displayed
  static void show({
    required BuildContext context,
    required String message,
    SnackbarType type = SnackbarType.info,
    Duration duration = const Duration(seconds: 2),
  }) {
    // Hide any existing snackbar
    _hideCurrentSnackbar();
    
    late final IconData icon;
    late final String semanticLabel;
    late final Color textColor; // Text color based on type

    // Configure based on type
    const Color backgroundColor = Color(0xFFF5F5F5); // Light grey background for all types
    
    switch (type) {
      case SnackbarType.success:
        textColor = const Color(0xFF166534); 
        icon = Icons.check_circle_outline;
        semanticLabel = 'Success';
        break;
      case SnackbarType.error:
        textColor = const Color(0xFF7C2D12); 
        icon = Icons.error_outline;
        semanticLabel = 'Error';
        break;
      case SnackbarType.info:
        textColor = const Color(0xFF1E3A8A); 
        icon = Icons.info_outline;
        semanticLabel = 'Information';
        break;
    }

    // Get the overlay state
    final overlay = Overlay.of(context);
    
    // Create an overlay entry
    _currentSnackbar = OverlayEntry(
      builder: (context) => Positioned(
        bottom: 16.0, // Margin from bottom
        left: 16.0, // Margin from left
        right: 16.0, // Margin from right
        child: Material(
          elevation: 4.0,
          borderRadius: BorderRadius.circular(12),
          color: backgroundColor,
          child: InkWell(
            onTap: () => _hideCurrentSnackbar(), // Dismiss on tap
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Icon(
                    icon,
                    color: textColor,
                    semanticLabel: semanticLabel,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      message,
                      style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    
    // Show the overlay
    overlay.insert(_currentSnackbar!);
    
    // Auto-hide after duration
    _snackbarTimer = Timer(duration, () {
      _hideCurrentSnackbar();
    });
  }
  
  /// Hides the currently displayed snackbar if any
  static void _hideCurrentSnackbar() {
    _snackbarTimer?.cancel();
    _snackbarTimer = null;
    
    _currentSnackbar?.remove();
    _currentSnackbar = null;
  }
  
  /// Manually hide the current snackbar (if needed from outside)
  static void hide() {
    _hideCurrentSnackbar();
  }
}
