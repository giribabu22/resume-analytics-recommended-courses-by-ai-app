import 'package:flutter/material.dart';

import '../../../../global/common/toast.dart';
import '../pages/login.dart';

class AppBarWidget extends StatefulWidget {
  final String pageName;
  const AppBarWidget({Key? key, required this.pageName}) : super(key: key);

  @override
  State<AppBarWidget> createState() => _AppBarWidgetState();
}

class _AppBarWidgetState extends State<AppBarWidget> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
        // title: const Text('Home Page', style: TextStyle(color: Colors.black),),
        backgroundColor: Colors.deepOrange,
        actions: [
          Card(
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () {
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder:(context) => const LoginPage() ), (route)=> false);
                  showToast(message: 'Logout Successfull');
                },
              ),
              const SizedBox(
                width: 140,
                child:  TextField(
                  decoration: InputDecoration(
                  hintText: 'Search',
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.search),
                  ),
                ),
              ),
              IconButton(icon: const Icon(Icons.access_alarm_rounded), onPressed: (){
              }),
            ],
          )
        )
        ],
        title: Text(widget.pageName, style: const TextStyle(color: Colors.black54, fontSize: 20, fontWeight: FontWeight.bold, fontFamily: AutofillHints.familyName)),
      );
      
  }
}