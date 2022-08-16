import 'package:flutter/material.dart';
import 'package:flutter_instagram_storyboard/src/story_button.dart';

class StoryListView extends StatelessWidget {
  final List<StoryButtonData> buttonDatas;
  final double buttonSpacing;
  final double paddingLeft;
  final double paddingRight;
  final double paddingTop;
  final double paddingBottom;
  final ScrollPhysics? physics;

  const StoryListView({
    Key? key,
    required this.buttonDatas,
    this.buttonSpacing = 10.0,
    this.paddingLeft = 10.0,
    this.paddingRight = 10.0,
    this.paddingTop = 10.0,
    this.paddingBottom = 10.0,
    this.physics,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120.0,
      child: Padding(
        padding: EdgeInsets.only(
          top: paddingTop,
          bottom: paddingBottom,
        ),
        child: ListView.builder(
          physics: physics,
          scrollDirection: Axis.horizontal,
          itemBuilder: (c, int index) {
            final isLast = index == buttonDatas.length - 1;
            final isFirst = index == 0;
            final buttonData = buttonDatas[index];
            return Padding(
              padding: EdgeInsets.only(
                left: isFirst ? paddingLeft : 0.0,
                right: isLast ? paddingRight : buttonSpacing,
              ),
              child: StoryButton(
                buttonData: buttonData,
              ),
            );
          },
          itemCount: buttonDatas.length,
        ),
      ),
    );
  }
}
