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
    required String imageName,
    bool addBottomBar = true,
  }) {
    return StoryPageScaffold(
      bottomNavigationBar: addBottomBar
          ? Container(
              width: double.infinity,
              height: kBottomNavigationBarHeight,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: 20.0,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        height: double.infinity,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.white,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(
                            50.0,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.send,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            )
          : SizedBox.shrink(),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/images/$imageName.png',
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                text,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButtonText(String text) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  BoxDecoration _buildButtonDecoration(
    String imageName,
  ) {
    return BoxDecoration(
      image: DecorationImage(
        image: AssetImage(
          'assets/images/$imageName.png',
        ),
        fit: BoxFit.cover,
      ),
    );
  }

  BoxDecoration _buildBorderDecoration(Color color) {
    return BoxDecoration(
      borderRadius: const BorderRadius.all(
        Radius.circular(15.0),
      ),
      border: Border.fromBorderSide(
        BorderSide(
          color: color,
          width: 1.5,
        ),
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
            // pageTransform: StoryNoTransform(),
            pageTransform: StoryPage3DTransform(),
            buttonDatas: [
              StoryButtonData(
                timelineBackgroundColor: Colors.red,
                buttonDecoration: _buildButtonDecoration('car'),
                child: _buildButtonText('Want a new car?'),
                borderDecoration: _buildBorderDecoration(Colors.red),
                storyPages: [
                  _createDummyPage(
                    text:
                        'Want to buy a new car? Get our loan for the rest of your life!',
                    imageName: 'car',
                  ),
                  _createDummyPage(
                    text:
                        'Can\'t return the loan? Don\'t worry, we\'ll take your soul as a collateral ;-)',
                    imageName: 'car',
                  ),
                ],
                segmentDuration: Duration(seconds: 3),
              ),
              StoryButtonData(
                timelineBackgroundColor: Colors.blue,
                buttonDecoration: _buildButtonDecoration('travel_1'),
                borderDecoration:
                    _buildBorderDecoration(Color.fromARGB(255, 134, 119, 95)),
                child: _buildButtonText('Travel whereever'),
                storyPages: [
                  _createDummyPage(
                    text: 'Get a loan',
                    imageName: 'travel_1',
                    addBottomBar: false,
                  ),
                  _createDummyPage(
                    text: 'Select a place where you want to go',
                    imageName: 'travel_2',
                    addBottomBar: false,
                  ),
                  _createDummyPage(
                    text: 'Dream about the place and pay our interest',
                    imageName: 'travel_3',
                    addBottomBar: false,
                  ),
                ],
                segmentDuration: Duration(seconds: 3),
              ),
              StoryButtonData(
                timelineBackgroundColor: Colors.orange,
                borderDecoration: _buildBorderDecoration(Colors.orange),
                buttonDecoration: _buildButtonDecoration('house'),
                child: _buildButtonText('Buy a house anywhere'),
                storyPages: [
                  _createDummyPage(
                    text: 'You cannot buy a house. Live with it',
                    imageName: 'house',
                  ),
                ],
                segmentDuration: Duration(seconds: 5),
              ),
              StoryButtonData(
                timelineBackgroundColor: Colors.red,
                buttonDecoration: _buildButtonDecoration('car'),
                child: _buildButtonText('Want a new car?'),
                borderDecoration: _buildBorderDecoration(Colors.red),
                storyPages: [
                  _createDummyPage(
                    text:
                        'Want to buy a new car? Get our loan for the rest of your life!',
                    imageName: 'car',
                  ),
                  _createDummyPage(
                    text:
                        'Can\'t return the loan? Don\'t worry, we\'ll take your soul as a collateral ;-)',
                    imageName: 'car',
                  ),
                ],
                segmentDuration: Duration(seconds: 3),
              ),
              StoryButtonData(
                buttonDecoration: _buildButtonDecoration('travel_1'),
                borderDecoration:
                    _buildBorderDecoration(Color.fromARGB(255, 134, 119, 95)),
                child: _buildButtonText('Travel whereever'),
                storyPages: [
                  _createDummyPage(
                    text: 'Get a loan',
                    imageName: 'travel_1',
                    addBottomBar: false,
                  ),
                  _createDummyPage(
                    text: 'Select a place where you want to go',
                    imageName: 'travel_2',
                    addBottomBar: false,
                  ),
                  _createDummyPage(
                    text: 'Dream about the place and pay our interest',
                    imageName: 'travel_3',
                    addBottomBar: false,
                  ),
                ],
                segmentDuration: Duration(seconds: 3),
              ),
              StoryButtonData(
                timelineBackgroundColor: Colors.orange,
                borderDecoration: _buildBorderDecoration(Colors.orange),
                buttonDecoration: _buildButtonDecoration('house'),
                child: _buildButtonText('Buy a house anywhere'),
                storyPages: [
                  _createDummyPage(
                    text: 'You cannot buy a house. Live with it',
                    imageName: 'house',
                  ),
                ],
                segmentDuration: Duration(seconds: 5),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
