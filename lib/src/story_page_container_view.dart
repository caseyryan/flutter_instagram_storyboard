import 'package:flutter/material.dart';
import 'package:flutter_instagram_storyboard/flutter_instagram_storyboard.dart';
import 'package:flutter_instagram_storyboard/src/story_timeline.dart';

class StoryPageContainerView extends StatefulWidget {
  final StoryButtonData buttonData;
  final VoidCallback onStoryComplete;

  const StoryPageContainerView({
    Key? key,
    required this.buttonData,
    required this.onStoryComplete,
  }) : super(key: key);

  @override
  State<StoryPageContainerView> createState() => _StoryPageContainerViewState();
}

class _StoryPageContainerViewState extends State<StoryPageContainerView> {
  StoryTimelineController _storyController = StoryTimelineController();

  @override
  void initState() {
    _storyController.addListener(_onTimelineEvent);
    super.initState();
  }

  void _onTimelineEvent(StoryTimelineEvent event) {
    if (event == StoryTimelineEvent.StoryComplete) {
      widget.onStoryComplete.call();
    }
    setState(() {});
  }

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
      child: StoryTimeline(
        controller: _storyController,
        buttonData: widget.buttonData,
      ),
    );
  }

  int get _curSegmentIndex {
    return widget.buttonData.currentSegmentIndex;
  }

  Widget _buildPageContent() {
    if (widget.buttonData.storyPages.isEmpty) {
      return Container(
        color: Colors.orange,
        child: Center(
          child: Text('No pages'),
        ),
      );
    }
    return widget.buttonData.storyPages[_curSegmentIndex];
  }

  Widget _buildPageStructure() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: widget.buttonData.storyPageDecoration,
      child: Stack(
        children: [
          _buildPageContent(),
          SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTimeline(),
                _buildCloseButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.buttonData.storyPageDecoration.color,
      body: _buildPageStructure(),
    );
  }
}
