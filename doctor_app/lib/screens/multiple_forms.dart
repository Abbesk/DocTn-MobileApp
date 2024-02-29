import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class AjoutRdvScreen extends StatefulWidget {
  const AjoutRdvScreen({Key? key}) : super(key: key);

  @override
  _AjoutRdvScreenState createState() => _AjoutRdvScreenState();
}

class _AjoutRdvScreenState extends State<AjoutRdvScreen> {

 PageController _controller = PageController();
 bool onLastPage =false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _controller,
            onPageChanged: (value) {
              setState(() {
                onLastPage = (value == 2);
              });
            },
            children: [
              Container(
                color: Colors.blueGrey,
              ),
              Container(
                color: Colors.redAccent,
              ),
              Container(
                color: Colors.greenAccent,
              )
            ],
          ),
          Container(
            alignment: Alignment(0, 0.75),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  child: Text('skip'),
                  onTap: () {
                    _controller.jumpToPage(1);
                  },
                ),
                SmoothPageIndicator(
                  controller: _controller,
                  count: 3,
                ),
                if (onLastPage)
                  GestureDetector(
                    child: Text("next"),
                    onTap: () {
                      _controller.nextPage(
                          duration: Duration(milliseconds: 500),
                          curve: Curves.easeIn);
                    },
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}