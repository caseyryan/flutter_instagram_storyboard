import 'package:flutter/material.dart';
import 'package:flutter_instagram_storyboard/src/story_page_3d_transform.dart';

import 'story_route.dart';

const int kStoryTimerTickMillis = 50; 

class StoryButtonData {
  /// This affects a border around button
  /// after the story was watched the border will
  /// disappear
  bool isWatched = false;
  int currentSegmentIndex = 0;
  final Curve? pageAnimationCurve;
  final Duration? pageAnimationDuration;
  final double aspectRatio;
  final BoxDecoration buttonDecoration;
  final BoxDecoration borderDecoration;
  final BoxDecoration storyPageDecoration;
  final double borderOffset;
  final InteractiveInkFeatureFactory? inkFeatureFactory;
  final Widget child;
  final List<Widget> storyPages;
  final Widget? closeButton;
  final Duration segmentDuration;
  final BoxDecoration containerBackgroundDecoration;
  final Color timelineFillColor;
  final Color timelineBackgroundColor;

  StoryButtonData({
    this.aspectRatio = 1.0,
    this.inkFeatureFactory,
    this.pageAnimationCurve,
    this.pageAnimationDuration,
    this.timelineFillColor = Colors.white,
    // this.timelineBackgroundColor = const Color.fromARGB(209, 255, 255, 255),
    this.timelineBackgroundColor = Colors.red,
    this.closeButton,
    this.storyPageDecoration = const BoxDecoration(
      color: Color.fromARGB(255, 226, 226, 226),
    ),
    required this.storyPages,
    required this.child,
    required this.segmentDuration,
    this.containerBackgroundDecoration = const BoxDecoration(
      color: Color.fromARGB(255, 0, 0, 0),
    ),
    this.buttonDecoration = const BoxDecoration(
      borderRadius: const BorderRadius.all(
        Radius.circular(12.0),
      ),
      color: Color.fromARGB(255, 226, 226, 226),
    ),
    this.borderDecoration = const BoxDecoration(
      borderRadius: const BorderRadius.all(
        Radius.circular(15.0),
      ),
      border: Border.fromBorderSide(
        BorderSide(
          color: Color.fromARGB(255, 176, 176, 176),
          width: 1.5,
        ),
      ),
    ),
    this.borderOffset = 2.0,
  }) : assert(
          segmentDuration.inMilliseconds % kStoryTimerTickMillis == 0 &&
              segmentDuration.inMilliseconds >= 1000,
          'Segment duration in milliseconds must be a ' +
              'multiple of $kStoryTimerTickMillis and not less than 1000 milliseconds',
        );
}

class StoryButton extends StatefulWidget {
  final StoryButtonData buttonData;

  /// [allButtonDatas] required to be able to page thru
  /// all stories
  final List<StoryButtonData> allButtonDatas;
  final IStoryPageTransform? pageTransform;

  const StoryButton({
    Key? key,
    required this.buttonData,
    required this.allButtonDatas,
    this.pageTransform,
  }) : super(key: key);

  @override
  State<StoryButton> createState() => _StoryButtonState();
}

class _StoryButtonState extends State<StoryButton> {
  Widget _buildChild() {
    return widget.buttonData.child;
  }

  void _onTap() {
    setState(() {
      widget.buttonData.isWatched = true;
    });
    final renderBox = context.findRenderObject() as RenderBox;
    final tapPosition = renderBox.localToGlobal(
      Offset(
        renderBox.paintBounds.width * .5,
        renderBox.paintBounds.height * .5,
      ),
    );
    Navigator.of(context).push(
      StoryRoute(
        buttonData: widget.buttonData,
        tapPosition: tapPosition,
        curve: widget.buttonData.pageAnimationCurve,
        duration: widget.buttonData.pageAnimationDuration,
        allButtonDatas: widget.allButtonDatas,
        pageTransform: widget.pageTransform,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: widget.buttonData.aspectRatio,
      child: Container(
        decoration:
            widget.buttonData.isWatched ? null : widget.buttonData.borderDecoration,
        child: Padding(
          padding: EdgeInsets.all(
            widget.buttonData.borderOffset,
          ),
          child: ClipRRect(
            borderRadius: widget.buttonData.buttonDecoration.borderRadius?.resolve(
              null,
            ),
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: widget.buttonData.buttonDecoration,
                ),
                _buildChild(),
                Material(
                  child: InkWell(
                    splashFactory:
                        widget.buttonData.inkFeatureFactory ?? InkRipple.splashFactory,
                    onTap: _onTap,
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ),
                  color: Colors.transparent,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
