import 'package:flutter/material.dart';
import 'package:flutter_instagram_storyboard/src/story_button.dart';
import 'package:flutter_instagram_storyboard/src/story_page_container_builder.dart';

import 'story_page_3d_transform.dart';

class StoryRoute extends PageRoute {
  final StoryButtonData buttonData;
  final List<StoryButtonData> allButtonDatas;
  final Offset tapPosition;
  final Curve? curve;
  final Duration? duration;
  /// [pageTransform] defaults to [StoryPage3DTransform]
  /// it affects the way a page transition looks
  final IStoryPageTransform? pageTransform;

  StoryRoute({
    required this.buttonData,
    required this.tapPosition,
    required this.allButtonDatas,
    this.duration,
    this.pageTransform,
    this.curve,
  });

  @override
  Color? get barrierColor => null;

  @override
  String? get barrierLabel => null;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return StoryPageContainerBuilder(
      buttonData: buttonData,
      tapPosition: tapPosition,
      animation: animation,
      curve: curve,
      allButtonDatas: allButtonDatas,
    );
  }

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration => duration ?? kThemeAnimationDuration;
}
