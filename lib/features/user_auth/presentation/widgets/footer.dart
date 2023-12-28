
import 'package:flutter/material.dart';


class FooterWidget extends StatelessWidget {
  const FooterWidget({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const BottomAppBar(
      color: Colors.deepOrange,
      child: Padding(
        padding: EdgeInsets.all(7.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Made with ❤️ by Team Abhyas',
              style: TextStyle(
                fontSize: 14.0,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );    
  }
}