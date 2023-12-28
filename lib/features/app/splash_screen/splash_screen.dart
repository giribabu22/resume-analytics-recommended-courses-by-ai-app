import 'package:abhyas/features/user_auth/presentation/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../../user_auth/presentation/pages/Account.dart';
import '../../user_auth/presentation/pages/login.dart';

class SplashScreen extends StatefulWidget {
  final Widget? child;
  const SplashScreen({Key? key, this.child}) : super(key: key);
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 3), () {
      final user = Hive.box('user').get('user');
      if(user == null){
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder:(context) => const LoginPage() ), (route)=> false);
      } else {
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder:(context) => const Home() ), (route)=> false);
      }
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.book_online_outlined, color: Colors.deepOrange, size: 50,),
                    Text('Abhyas', style: TextStyle(color: Colors.deepOrange, fontSize: 50, fontWeight: FontWeight.bold),),
                  ]
              ),
              Text('Loading....'),
            ],
          )
      ),
    );
  }
}