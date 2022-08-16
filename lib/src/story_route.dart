import 'package:flutter/material.dart';
import 'package:flutter_instagram_storyboard/src/story_button.dart';
import 'package:flutter_instagram_storyboard/src/story_page.dart';

class StoryRoute extends PageRoute {
  final StoryButtonData buttonData;
  final Offset tapPosition;
  final Curve? curve;
  final Duration? duration;

  StoryRoute({
    required this.buttonData,
    required this.tapPosition,
    this.duration,
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
    return StoryPage(
      buttonData: buttonData,
      tapPosition: tapPosition,
      animation: animation,
      curve: curve,
    );
  }

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration => duration ?? kThemeAnimationDuration;
}
