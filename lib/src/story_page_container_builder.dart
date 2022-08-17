import 'package:flutter/material.dart';

import 'story_button.dart';
import 'story_page_3d_transform.dart';
import 'story_page_container_view.dart';

class StoryPageContainerBuilder extends StatefulWidget {
  final StoryButtonData buttonData;
  final List<StoryButtonData> allButtonDatas;
  final Offset tapPosition;
  final Animation<double> animation;
  final Curve? curve;
  final IStoryPageTransform? pageTransform;

  const StoryPageContainerBuilder({
    Key? key,
    required this.buttonData,
    required this.allButtonDatas,
    required this.tapPosition,
    required this.animation,
    required this.curve,
    this.pageTransform,
  }) : super(key: key);

  @override
  State<StoryPageContainerBuilder> createState() => _StoryPageContainerBuilderState();
}

class _StoryPageContainerBuilderState extends State<StoryPageContainerBuilder> {
  late PageController _pageController;
  late IStoryPageTransform _storyPageTransform;
  int _currentPage = 0;
  double _pageDelta = 0.0;
  double _totalWidth = 0.0;
  double _pageWidth = 0.0;
  bool _isClosed = false;

  @override
  void initState() {
    _storyPageTransform = widget.pageTransform ?? StoryPage3DTransform();
    _currentPage = widget.allButtonDatas.indexOf(
      widget.buttonData,
    );
    _pageController = PageController(
      initialPage: _currentPage,
    );
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page!.floor();
        _pageDelta = _pageController.page! - _currentPage;
        final isFirst = _currentPage == 0;
        final isLast = _currentPage == widget.allButtonDatas.length - 1;
        if (isFirst) {
          final offset = _pageController.offset;
          if (offset < 0) {
            _pageDelta = 1.0 - (offset.abs() / _pageWidth);
            _currentPage = -1;
            if (_pageDelta <= .8) {
              _close();
            }
          }
        } else if (isLast) {
          final offset = _totalWidth - _pageController.offset;
          if (offset < 0) {
            _pageDelta = (offset.abs() / _pageWidth);
            if (_pageDelta > .2) {
              _close();
            }
          }
        }
      });
    });
    _widgetsBinding?.addPostFrameCallback((timeStamp) {
      _afterFirstBuild();
    });
    super.initState();
  }

  Future _close() async {
    if (_isClosed) {
      return;
    }

    if (mounted) {
      _isClosed = true;
      setState(() {});
      await Future.delayed(const Duration(
        milliseconds: 400,
      ));
      if (mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  void _afterFirstBuild() {
    if (mounted) {
      _pageWidth = context.size!.width;
      _totalWidth = _pageWidth * (widget.allButtonDatas.length - 1);
    }
  }

  /// a little hack to avoid warning on flutter < 3.0
  dynamic get _widgetsBinding {
    return WidgetsBinding.instance;
  }

  Future _onStoryComplete() async {
    if (_curPage < widget.allButtonDatas.length - 1) {
      _pageController.animateToPage(
        _curPage + 1,
        duration: kThemeAnimationDuration,
        curve: Curves.linear,
      );
    } else {
      _close();
    }
  }

  int get _curPage {
    return _pageController.page?.floor() ?? 0;
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
            curve: widget.curve ?? Curves.linear,
          ).transform(
            1.0 - widget.animation.value,
          );
          final itemCount = widget.allButtonDatas.length;
          return ClipRRect(
            clipper: _PageClipper(
              borderRadius: widget.buttonData.borderDecoration.borderRadius
                  ?.resolve(
                    null,
                  )
                  .bottomLeft,
              startX: widget.tapPosition.dx,
              startY: widget.tapPosition.dy,
              animationValue: animationValue,
            ),
            child: Scaffold(
              backgroundColor: widget.buttonData.storyPageDecoration.color,
              body: Container(
                decoration: widget.buttonData.containerBackgroundDecoration,
                child: PageView.builder(
                  physics: BouncingScrollPhysics(),
                  controller: _pageController,
                  itemBuilder: ((context, index) {
                    final childIndex = index % itemCount;
                    final buttonData = widget.allButtonDatas[childIndex];
                    final child = StoryPageContainerView(
                      buttonData: buttonData,
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
