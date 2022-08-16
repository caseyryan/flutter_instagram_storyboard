import 'package:flutter/material.dart';
import 'package:flutter_instagram_storyboard/flutter_instagram_storyboard.dart';

/// https://github.com/UdaraWanasinghe/FlutterCarouselSlider/blob/master/lib/carousel_slider.dart
class StoryPage extends StatefulWidget {
  final StoryButtonData buttonData;
  final Offset tapPosition;
  final Animation<double> animation;
  final Curve? curve;

  const StoryPage({
    Key? key,
    required this.buttonData,
    required this.tapPosition,
    required this.animation,
    required this.curve,
  }) : super(key: key);

  @override
  State<StoryPage> createState() => _StoryPageState();
}

class _StoryPageState extends State<StoryPage> {
  Widget _buildCloseButton() {
    Widget closeButton;
    if (widget.buttonData.closeButton != null) {
      closeButton = widget.buttonData.closeButton!;
    } else {
      closeButton = SizedBox(
        height: 40.0,
        width: 40.0,
        child: MaterialButton(
          padding: EdgeInsets.zero,
          onPressed: () {
            Navigator.of(context).pop();
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40.0),
          ),
          child: Container(
            height: 40.0,
            width: 40.0,
            child: Icon(
              Icons.close,
              size: 28.0,
            ),
          ),
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 10.0,
        vertical: 10.0,
      ),
      child: Row(
        children: [
          Expanded(child: SizedBox()),
          closeButton,
        ],
      ),
    );
  }

  Widget _buildTimeline() {
    return Padding(
      padding: const EdgeInsets.only(
        top: 15.0,
        left: 10.0,
        right: 10.0,
      ),
      child: Container(
        color: Colors.red,
        height: 2.0,
        width: double.infinity,
        child: _buildSegments(),
      ),
    );
  }

  Widget _buildSegments() {
    /// TODO: Сделать сегменты
    return Container();
  }

  Widget _buildPageContent() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: widget.buttonData.storyPageDecoration,
      child: SafeArea(
        child: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTimeline(),
                _buildCloseButton(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.animation,
      builder: (c, w) {
        final animationValue = Interval(
          0.0,
          1.0,
          curve: widget.curve ?? Curves.linear,
        ).transform(
          1.0 - widget.animation.value,
        );

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
            body: _buildPageContent(),
          ),
        );
      },
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
