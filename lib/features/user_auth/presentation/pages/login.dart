// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:abhyas/features/user_auth/presentation/pages/signup.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import '../../../../global/common/toast.dart';
import '../widgets/form_container_widget.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'home.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  static const routeName = '/login';

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController msgController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<List<dynamic>?> loginUser(String email, String password) async {
    try{
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {
        final url = "https://merd-api.merakilearn.org/developers/login/$email/$password";      
        final response = await  http.get(Uri.parse(url));
        if (response.statusCode == 200) {
          // If the server did return a 200 OK response, then parse the JSON.
          final data = jsonDecode(response.body);
          Hive.box('user').put('user', data);
          Navigator.push(context, MaterialPageRoute(builder:(context) => const Home() ));
          showToast(message: 'Login Successfull');
        } else {
          // If the server did not return a 200 OK response, then throw an exception.
          showToast(message: 'Failed to load album');
        }
        return [];
      } else {
        throw 'Network error ' ;
      }
    } catch (e) {
      showToast(message: e.toString());
    }
    return null;
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Login Page', style: TextStyle(color: Colors.black),),
        backgroundColor: Colors.deepOrange,
      ),
      body:  Padding(
        padding: const EdgeInsets.symmetric( horizontal:29),
        child:  Column(
          children: [
            const SizedBox(height: 70,),
            const Center(
              child: Text('', style: TextStyle(fontWeight: FontWeight.bold),),
            ),
            FormContainerWidget(controller: emailController ,hintText: 'Email', isPasswordField: false, ),
            const SizedBox(height: 20,),
            FormContainerWidget(controller: passwordController, hintText: 'Password', isPasswordField: true,),
            const SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: (){},
                  child: const Text('Forgot Password?', style: TextStyle(color: Colors.blue),),
                ),
              ],
            ),
            Container(
              width:double.infinity,
              decoration: BoxDecoration(
                color: Colors.deepOrange,
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 5,
                    offset: Offset(0, 5),
                  )
                ],
              ),
              child: TextButton(
                onPressed: (){
                  loginUser(emailController.text, passwordController.text);
                },
                child:  const Text('Login', style: TextStyle(color: Colors.blue),),
              ),
            ),
            const SizedBox(height: 20,),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Text('Don\'t have an account?'),
                TextButton(
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder:(context) => const SignUpPage() ));
                  },
                  child: const Text('SignUp', style: TextStyle(color: Colors.blue),),
                ),
              ],
            ),
          ]
        ),
      ),
    );
  }
}