import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_instagram_storyboard/flutter_instagram_storyboard.dart';

enum StoryTimelineEvent {
  StoryComplete,
  SegmentComplete,
}

typedef StoryTimelineCallback = Function(StoryTimelineEvent);

class StoryTimelineController {
  _StoryTimelineState? _state;

  int _curSegmentIndex = 0;
  int get curSegmentIndex => _curSegmentIndex;

  HashSet<StoryTimelineCallback> _listeners = HashSet<StoryTimelineCallback>();

  void addListener(StoryTimelineCallback callback) {
    _listeners.add(callback);
  }

  void removeListener(StoryTimelineCallback callback) {
    _listeners.remove(callback);
  }

  void _notifyListeners(StoryTimelineEvent event) {
    _listeners.forEach((e) {
      e.call(event);
    });
  }

  void nextSegment() {
    _state?.nextSegment();
  }

  void previousSegment() {
    _state?.previousSegment();
  }

  void pause() {
    _state?.pause();
  }

  void unpause() {
    _state?.unpause();
  }

  void dispose() {
    _listeners.clear();
  }
}

class StoryTimeline extends StatefulWidget {
  final StoryTimelineController controller;
  final StoryButtonData buttonData;

  const StoryTimeline({
    Key? key,
    required this.controller,
    required this.buttonData,
  }) : super(key: key);

  @override
  State<StoryTimeline> createState() => _StoryTimelineState();
}

class _StoryTimelineState extends State<StoryTimeline> {
  late Timer _timer;
  int _accumulatedTime = 0;
  int _maxAccumulator = 0;
  bool _isPaused = false;

  @override
  void initState() {
    _maxAccumulator = widget.buttonData.segmentDuration.inMilliseconds;
    _timer = Timer.periodic(
      const Duration(
        milliseconds: kStoryTimerTickMillis,
      ),
      _onTimer,
    );
    widget.controller._state = this;
    super.initState();
  }

  void _onTimer(timer) {
    if (_isPaused) {
      return;
    }
    if (_accumulatedTime + kStoryTimerTickMillis <= _maxAccumulator) {
      _accumulatedTime += kStoryTimerTickMillis;
      if (_accumulatedTime >= _maxAccumulator) {
        if (_isLastSegment) {
          _onStoryComplete();
        } else {
          _accumulatedTime = 0;
          _curSegmentIndex++;
          _onSegmentComplete();
        }
      }
      setState(() {});
    }
  }

  void _onStoryComplete() {
    widget.controller._notifyListeners(
      StoryTimelineEvent.StoryComplete,
    );
  }

  void _onSegmentComplete() {
    widget.controller._notifyListeners(
      StoryTimelineEvent.SegmentComplete,
    );
  }

  bool get _isLastSegment {
    return _curSegmentIndex == _numSegments - 1;
  }

  int get _numSegments {
    return widget.buttonData.storyPages.length;
  }

  set _curSegmentIndex(int value) {
    if (value >= _numSegments) {
      value = _numSegments - 1;
    }
    widget.buttonData.currentSegmentIndex = value;
  }

  int get _curSegmentIndex {
    return widget.buttonData.currentSegmentIndex;
  }

  void nextSegment() {}

  void previousSegment() {}

  void pause() {
    _isPaused = true;
  }

  void unpause() {
    _isPaused = false;
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 2.0,
      width: double.infinity,
      child: CustomPaint(
        painter: _TimelinePainter(
          fillColor: widget.buttonData.timelineFillColor,
          backgroundColor: widget.buttonData.timelineBackgroundColor,
          curSegmentIndex: _curSegmentIndex,
          numSegments: _numSegments,
          percent: _accumulatedTime / _maxAccumulator,
          spacing: 8.0,
        ),
      ),
    );
  }
}

class _TimelinePainter extends CustomPainter {
  final Color fillColor;
  final Color backgroundColor;
  final int curSegmentIndex;
  final int numSegments;
  final double percent;
  final double spacing;

  _TimelinePainter({
    required this.fillColor,
    required this.backgroundColor,
    required this.curSegmentIndex,
    required this.numSegments,
    required this.percent,
    required this.spacing,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final bgPaint = Paint()
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 3.0
      ..color = backgroundColor
      ..style = PaintingStyle.stroke;

    final fillPaint = Paint()
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 3.0
      ..color = fillColor
      ..style = PaintingStyle.stroke;

    final maxSpacing = (numSegments - 1) * spacing;
    final maxSegmentLength = (size.width - maxSpacing) / numSegments;

    for (var i = 0; i < numSegments; i++) {
      final start = Offset(
        ((maxSegmentLength + spacing) * i),
        0.0,
      );
      final end = Offset(
        start.dx + maxSegmentLength,
        0.0,
      );

      canvas.drawLine(
        start,
        end,
        bgPaint,
      );
    }

    for (var i = 0; i < numSegments; i++) {
      final start = Offset(
        ((maxSegmentLength + spacing) * i),
        0.0,
      );
      var endValue = start.dx;
      if (curSegmentIndex > i) {
        endValue = start.dx + maxSegmentLength;
      } else if (curSegmentIndex == i) {
        endValue = start.dx + (maxSegmentLength * percent);
      }
      final end = Offset(
        endValue,
        0.0,
      );
      if (endValue == start.dx) {
        continue;
      }
      canvas.drawLine(
        start,
        end,
        fillPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
