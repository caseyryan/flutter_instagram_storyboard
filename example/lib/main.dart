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
                storyPages: [],
              ),
              StoryButtonData(
                child: SizedBox(),
                storyPages: [],
              ),
              StoryButtonData(
                child: SizedBox(),
                storyPages: [],
              ),
              StoryButtonData(
                child: SizedBox(),
                storyPages: [],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
