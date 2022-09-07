import 'dart:math';

import 'package:flutter/material.dart';

import 'story_button.dart';
import 'story_list_view.dart';
import 'story_route.dart';

/// If you need to implement your own transform
/// just implement this interface and add it to
/// [StoryButton] or [StoryRoute]
abstract class IStoryPageTransform {
  Widget transform(
    BuildContext context,
    Widget child,
    int index,
    int pageIndex,
    double delta,
  );

  ScrollPhysics? get pageScrollPhysics;
}

/// If you don't need any transformation between stories
/// just use [StoryPageNoTransform] as a Parameter to [StoryButton]
/// or [StoryListView]
class StoryPageNoTransform implements IStoryPageTransform {
  @override
  Widget transform(
    BuildContext context,
    Widget child,
    int index,
    int pageIndex,
    double delta,
  ) {
    return child;
  }

  @override
  ScrollPhysics? get pageScrollPhysics => null;
}

class StoryPage3DTransform implements IStoryPageTransform {
  final double perspective;
  final double radAngle;

  const StoryPage3DTransform({
    this.perspective = 0.0008,
    double degAngle = 90.0,
  }) : radAngle = pi / 180.0 * degAngle;

  @override
  ScrollPhysics? get pageScrollPhysics => const BouncingScrollPhysics();

  @override
  Widget transform(
    BuildContext context,
    Widget child,
    int index,
    int pageIndex,
    double delta,
  ) {
    if (index == pageIndex) {
      return Transform(
        alignment: Alignment.centerRight,
        transform: Matrix4.identity()
          ..setEntry(3, 2, perspective)
          ..rotateY(radAngle * delta),
        child: child,
      );
    } else if (index == pageIndex + 1) {
      return Transform(
        alignment: Alignment.centerLeft,
        transform: Matrix4.identity()
          ..setEntry(3, 2, perspective)
          ..rotateY(-radAngle * (1.0 - delta)),
        child: child,
      );
    } else {
      return child;
    }
  }
}
