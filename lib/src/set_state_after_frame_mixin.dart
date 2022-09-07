import 'package:flutter/material.dart';

mixin SetStateAfterFrame<T extends StatefulWidget> on State<T> {
  void safeSetState(VoidCallback? closure) {
    try {
      if (mounted) {
        setState(() {
          closure?.call();
        });
      }
    } catch (e) {
      setStateAfterFrame(closure);
    }
  }

  /// a little hack to avoid warning on Flutter < 3.0
  dynamic get _widgetsBinding {
    return WidgetsBinding.instance;
  }

  void setStateAfterFrame(VoidCallback? closure) {
    _widgetsBinding?.ensureVisualUpdate();
    _widgetsBinding?.addPostFrameCallback(
      (timeStamp) {
        if (mounted) {
          setState(() {
            closure?.call();
          });
        }
      },
    );
  }
}
