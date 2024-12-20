import 'package:flash/flash.dart';
import 'package:flash/flash_helper.dart';
import 'package:flutter/material.dart';
import 'package:testing_flutter_apps_workshop/core/presentation/widgets/app_snackbar.dart';

extension ContextUtils on BuildContext {
  void showSnackBar({
    required String message,
    SnackBarStates state = SnackBarStates.idle,
    FlashPosition position = FlashPosition.top,
    Duration? duration,
    Widget? action,
    // ignore: strict_raw_type
    void Function(FlashController)? controllerBuilder,
  }) =>
      this.showFlash(
        duration: duration ?? const Duration(seconds: 3),
        builder: (_, controller) {
          controllerBuilder?.call(controller);
          return FlashBar(
            padding: EdgeInsets.zero,
            builder: (_, index) => AppSnackBar(
              message: message,
              state: state,
              actionButton: action,
            ),
            controller: controller,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              // side: BorderSide(),
            ),
            elevation: 0,
            position: position,
            margin: const EdgeInsets.symmetric(horizontal: 24),
            clipBehavior: Clip.antiAlias,
            behavior: FlashBehavior.floating,
            content: const SizedBox(),
          );
        },
      );
}
