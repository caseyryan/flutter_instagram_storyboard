library after_layout;

import 'package:flutter/widgets.dart';

mixin FirstBuildMixin<T extends StatefulWidget> on State<T> {
  @override
  void initState() {
    super.initState();
    _widgetsBinding?.addPostFrameCallback(
      (timeStamp) {
        if (mounted) {
          didFirstBuildFinish(context);
        }
      },
    );
  }

  dynamic get _widgetsBinding {
    return WidgetsBinding.instance;
  }

  void didFirstBuildFinish(BuildContext context);
}
