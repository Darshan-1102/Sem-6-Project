import 'package:book_buddy_5/screens/main_screen.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  static const String id = 'onboard-screen';

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {

  double scrollerPosition = 0;
  final store= GetStorage();

  onButtonPressed(context){
    store.write('onBoarding', true);
    Navigator.pushReplacementNamed(context, MainScreen.id);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
      [
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown
      ]
    );
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            onPageChanged: (val) {
              setState(() {
                scrollerPosition = val.toDouble();
              });
            },
            children: [
              OnBoardPage(
                boardColumn: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 400,
                      width: 500,
                      child: Image.asset('assets/images/variety.png'),
                    ),

                    const Text(
                      'Welcome to\n Book Buddy',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 28,
                        color: Colors.indigo,
                      ),
                    ),
                    const Text(
                      'Over 1 million books',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 28,
                        color: Colors.indigo,
                      ),
                    ),
                    const SizedBox(height: 150,)
                  ],
                ),
              ),
              OnBoardPage(
                boardColumn: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 500,
                      width: 500,
                      child: Image.asset('assets/images/shop_comfort.png'),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      'Shop From Comfort \nof your home',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 28,
                        color: Colors.indigo,
                      ),
                    ),
                    const SizedBox(height: 150,)
                  ],
                ),
              ),
              OnBoardPage(
                boardColumn: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 300,
                      width: 300,
                      child: Image.asset('assets/images/favourite_books.png'),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      'Find your favourite books',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 28,
                        color: Colors.indigo,
                      ),
                    ),
                    const SizedBox(height: 10,),
                    const Text(
                      'At nominal Cost',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 28,
                        color: Colors.indigo,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DotsIndicator(
                  dotsCount: 3,
                  position: scrollerPosition,
                  decorator: const DotsDecorator(activeColor: Colors.purple),
                ),
                const SizedBox(
                  height: 30,
                ),
                scrollerPosition == 2
                    ? Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Colors.indigoAccent)
                        ),
                          onPressed: () {
                          onButtonPressed(context);
                          }, child: const Text('Start Shopping',
                        style: TextStyle(
                          fontSize: 20
                        ),
                      )),
                    )
                    :
                TextButton(
                  onPressed: () {
                    onButtonPressed(context);
                  },
                  child: const Text(
                    'Skip to the app',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
                const SizedBox(
                  height: 50,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class OnBoardPage extends StatelessWidget {
  const OnBoardPage({Key? key, this.boardColumn}) : super(key: key);
  final Column? boardColumn;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          color: Colors.white,
          child: Center(child: boardColumn),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 100,
            decoration: BoxDecoration(
                color: Colors.blueGrey[600],
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(100),
                    topRight: Radius.circular(100))),
          ),
        ),
      ],
    );
  }
}
