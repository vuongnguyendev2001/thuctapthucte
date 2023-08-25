import 'package:flutter/material.dart';

enum SnackBarType {
  error,
  warning,
  success,
}

extension SnackBarTypeExt on SnackBarType {
  /// BG Color
  Color getBGColor() {
    switch (this) {
      case SnackBarType.error:
        return Colors.red;
      case SnackBarType.warning:
        return Colors.amber;
      case SnackBarType.success:
        return Colors.green;
    }
  }

  IconData getIconData() {
    switch (this) {
      case SnackBarType.error:
        return Icons.error_outline;
      case SnackBarType.warning:
        return Icons.warning_amber_outlined;
      case SnackBarType.success:
        return Icons.done_outline_outlined;
    }
  }
}
