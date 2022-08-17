import 'package:flutter/material.dart';
import 'package:flutter_instagram_storyboard/flutter_instagram_storyboard.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: const StoryExample(),
    );
  }
}

class StoryExample extends StatefulWidget {
  const StoryExample({Key? key}) : super(key: key);

  @override
  State<StoryExample> createState() => _StoryExampleState();
}

class _StoryExampleState extends State<StoryExample> {
  Widget _createDummyPage({
    required String text,
    required Color color,
  }) {
    return Container(
      color: color,
      child: Center(
        child: Text(text),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: const Text('Story Example'),
      ),
      body: Column(
        children: [
          StoryListView(
            buttonDatas: [
              StoryButtonData(
                child: SizedBox(),
                storyPages: [
                  _createDummyPage(
                    text: 'Story 1, page 1',
                    color: Colors.blueAccent,
                  ),
                  _createDummyPage(
                    text: 'Story 1, page 2',
                    color: Colors.pink,
                  ),
                  _createDummyPage(
                    text: 'Story 1, page 3',
                    color: Colors.green,
                  ),
                ],
                segmentDuration: Duration(seconds: 3),
              ),
              StoryButtonData(
                child: SizedBox(),
                storyPages: [
                  _createDummyPage(
                    text: 'Story 2, page 1',
                    color: Colors.amber,
                  ),
                  _createDummyPage(
                    text: 'Story 2, page 2',
                    color: Colors.blue,
                  ),
                ],
                segmentDuration: Duration(seconds: 3),
              ),
              StoryButtonData(
                child: SizedBox(),
                storyPages: [
                  _createDummyPage(
                    text: 'Story 3, page 1',
                    color: Colors.blueAccent,
                  ),
                  _createDummyPage(
                    text: 'Story 3, page 2',
                    color: Colors.pink,
                  ),
                  _createDummyPage(
                    text: 'Story 3, page 3',
                    color: Colors.pinkAccent,
                  ),
                  _createDummyPage(
                    text: 'Story 3, page 4',
                    color: Colors.green,
                  ),
                ],
                segmentDuration: Duration(seconds: 3),
              ),
              StoryButtonData(
                child: SizedBox(),
                storyPages: [
                  _createDummyPage(
                    text: 'Story 4, page 1',
                    color: Colors.amber,
                  ),
                  _createDummyPage(
                    text: 'Story 4, page 2',
                    color: Colors.blue,
                  ),
                ],
                segmentDuration: Duration(seconds: 3),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
