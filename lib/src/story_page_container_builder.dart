import 'package:flutter/material.dart';
import 'package:flutter_instagram_storyboard/flutter_instagram_storyboard.dart';
import 'package:flutter_instagram_storyboard/src/first_build_mixin.dart';
import 'package:flutter_instagram_storyboard/src/set_state_after_frame_mixin.dart';

import 'story_page_container_view.dart';

class StoryPageContainerBuilder extends StatefulWidget {
  final Animation<double> animation;
  final StoryContainerSettings settings;

  const StoryPageContainerBuilder({
    Key? key,
    required this.settings,
    required this.animation,
  }) : super(key: key);

  @override
  State<StoryPageContainerBuilder> createState() =>
      _StoryPageContainerBuilderState();
}

class _StoryPageContainerBuilderState extends State<StoryPageContainerBuilder>
    with SetStateAfterFrame, FirstBuildMixin {
  late PageController _pageController;
  late IStoryPageTransform _storyPageTransform;
  static const double kMaxPageOverscroll = .2;
  int _currentPage = 0;
  double _pageDelta = 0.0;
  double _bgOpacityControlValue = 0.0;
  double _totalWidth = 0.0;
  double _pageWidth = 0.0;
  bool _isClosed = false;

  @override
  void initState() {
    _storyPageTransform =
        widget.settings.pageTransform ?? const StoryPage3DTransform();
    _currentPage = widget.settings.allButtonDatas.indexOf(
      widget.settings.buttonData,
    );
    _pageController = PageController(
      initialPage: _currentPage,
    );
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page!.floor();
        _pageDelta = _pageController.page! - _currentPage;
        final isFirst = _currentPage == 0;
        final isLast =
            _currentPage == widget.settings.allButtonDatas.length - 1;
        if (isFirst) {
          final offset = _pageController.offset;
          if (offset < 0) {
            _pageDelta = 1.0 - (offset.abs() / _pageWidth);
            _bgOpacityControlValue = 1.0 - _pageDelta;
            _currentPage = -1;
            if (_pageDelta <= 1.0 - kMaxPageOverscroll) {
              _close();
            }
          }
        } else if (isLast) {
          final offset = _totalWidth - _pageController.offset;
          if (offset < 0) {
            _pageDelta = (offset.abs() / _pageWidth);
            _bgOpacityControlValue = _pageDelta;
            if (_pageDelta > kMaxPageOverscroll) {
              _close();
            }
          }
        }
        _scrollToActiveButton();
        if (_isClosed) {
          _bgOpacityControlValue = 1.0;
        }
      });
    });

    super.initState();
  }

  @override
  void didFirstBuildFinish(BuildContext context) {
    _afterFirstBuild();
  }

  /// This code calculates the position of the story button
  /// relative to the screen and if it's beyond the screen
  /// scrolls the button list in a way that a target button is
  /// always visible. Thus the story will always pop out to
  /// its corresponding button
  void _scrollToActiveButton() {
    if (widget.settings.storyListScrollController.hasClients) {
      final leftPos = _activeButtonData.buttonLeftPosition?.dx;
      final rightPos = _activeButtonData.buttonRightPosition?.dx;
      const additionalMargin = 12.0;
      if (leftPos != null && rightPos != null) {
        final curScrollPosition =
            widget.settings.storyListScrollController.position.pixels;

        if (leftPos < 0.0) {
          widget.settings.storyListScrollController.jumpTo(
            curScrollPosition + leftPos - additionalMargin,
          );
        } else if (rightPos >= _pageWidth) {
          final rightOverlap = rightPos - _pageWidth;
          widget.settings.storyListScrollController.jumpTo(
            curScrollPosition + rightOverlap + additionalMargin,
          );
        }
      }
    }
  }

  Future _close() async {
    if (_isClosed) {
      return;
    }
    _bgOpacityControlValue = 1.0;
    if (mounted) {
      _isClosed = true;
      safeSetState(() {});
      if (mounted) {
        Navigator.of(context).pop(
          widget.settings.buttonData,
        );
      }
    }
  }

  void _afterFirstBuild() {
    if (mounted) {
      _pageWidth = context.size!.width;
      _totalWidth = _pageWidth * (widget.settings.allButtonDatas.length - 1);
    }
  }

  Future _onStoryComplete() async {
    if (_curPageIndex < widget.settings.allButtonDatas.length - 1) {
      _pageController.animateToPage(
        _curPageIndex + 1,
        duration: kThemeAnimationDuration,
        curve: Curves.linear,
      );
    } else {
      _close();
    }
  }

  int get _curPageIndex {
    if (!_pageController.hasClients) {
      return _currentPage;
    }
    return _pageController.page?.floor() ?? 0;
  }

  StoryButtonData get _activeButtonData {
    return widget.settings.allButtonDatas[_curPageIndex];
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: _isClosed,
      child: AnimatedBuilder(
        animation: widget.animation,
        builder: (c, w) {
          final animationValue = Interval(
            0.0,
            1.0,
            curve: widget.settings.curve ?? Curves.linear,
          ).transform(
            1.0 - widget.animation.value,
          );

          double bgOpacity = 1.0 -
              const Interval(
                0.0,
                kMaxPageOverscroll,
              ).transform(
                _bgOpacityControlValue,
              );
          final itemCount = widget.settings.allButtonDatas.length;
          if (_isClosed) {
            bgOpacity = 0.0;
          }

          return ClipRRect(
            clipper: _PageClipper(
              borderRadius:
                  widget.settings.buttonData.borderDecoration.borderRadius
                      ?.resolve(
                        null,
                      )
                      .bottomLeft,
              startX: _activeButtonData.buttonCenterPosition?.dx ??
                  widget.settings.tapPosition.dx,
              startY: _activeButtonData.buttonCenterPosition?.dy ??
                  widget.settings.tapPosition.dy,
              animationValue: animationValue,
            ),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: Container(
                decoration: widget
                    .settings.buttonData.containerBackgroundDecoration
                    .copyWith(
                  color: widget
                      .settings.buttonData.containerBackgroundDecoration.color
                      ?.withOpacity(
                    bgOpacity,
                  ),
                ),
                child: SafeArea(
                  bottom: widget.settings.safeAreaBottom,
                  top: widget.settings.safeAreaTop,
                  child: PageView.builder(
                    physics: _storyPageTransform.pageScrollPhysics,
                    controller: _pageController,
                    itemBuilder: ((context, index) {
                      final childIndex = index % itemCount;
                      final buttonData =
                          widget.settings.allButtonDatas[childIndex];
                      final child = StoryPageContainerView(
                        buttonData: buttonData,
                        onClosePressed: _close,
                        pageController: _pageController,
                        onStoryComplete: _onStoryComplete,
                      );
                      return _storyPageTransform.transform(
                        context,
                        child,
                        childIndex,
                        _currentPage,
                        _pageDelta,
                      );
                    }),
                    itemCount: itemCount,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _PageClipper extends CustomClipper<RRect> {
  final double startX;
  final double startY;
  final Radius? borderRadius;
  final double animationValue;

  _PageClipper({
    required this.startX,
    required this.startY,
    required this.animationValue,
    required this.borderRadius,
  });

  @override
  RRect getClip(Size size) {
    var rightSide = (size.width - startX) * animationValue;
    var leftSide = startX * animationValue;
    var topSide = (size.height - startY) * animationValue;
    var bottomSide = startY * animationValue;
    return RRect.fromLTRBR(
      leftSide,
      bottomSide,
      size.width - rightSide,
      size.height - topSide,
      borderRadius == null ? Radius.zero : (borderRadius! * animationValue),
    );
  }

  @override
  bool shouldReclip(_PageClipper oldClipper) {
    return animationValue != oldClipper.animationValue;
  }
}
