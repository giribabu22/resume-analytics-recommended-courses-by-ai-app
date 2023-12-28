// ignore_for_file: library_private_types_in_public_api

import 'dart:convert';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import '../../../../global/common/toast.dart';
import '../widgets/form_container_widget.dart';
import 'login.dart';
import 'package:http/http.dart' as http;
import 'home.dart';
import 'package:hive/hive.dart';


class SignUpPage extends StatefulWidget {
  static const routeName = '/SignUp';

  const SignUpPage({super.key});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController interestsController = TextEditingController();
  final TextEditingController skillsController = TextEditingController();

  final TextEditingController learningPlanController = TextEditingController();
  final TextEditingController programmingLanguagesController = TextEditingController();
  final TextEditingController experienceController = TextEditingController();
  final TextEditingController knownFramworksController = TextEditingController();
  final TextEditingController roleController = TextEditingController();
  final TextEditingController resonalLanguageController = TextEditingController();
  final TextEditingController educationController = TextEditingController();

   Future<List<dynamic>?> SignUp() async {
    // try{
      final String email = emailController.text;
      final String password = passwordController.text;
      final String name = nameController.text;
      //
      final String learningPlan = learningPlanController.text;
      final String experience = experienceController.text;
      final String role = roleController.text;
      final String education = educationController.text;
      final String resonalLanguage = resonalLanguageController.text;

      final String programmingLanguages = programmingLanguagesController.text;
      final String knownFramworks = knownFramworksController.text;
      //
      final String skills = skillsController.text;
      final String interests = interestsController.text;

      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {
        final url = Uri.parse("https://merd-api.merakilearn.org/developers/create/app?name=$name&email=$email&password=$password&intrests=$interests&skills=$skills");
        final resString = await http.get(url);
        print('resString $resString');
        final res = jsonDecode(resString.body);
        if (res.containsKey('Error') && res?['Error']) {
          showToast(message: res['message']);
        } else {
          Hive.box('user').put('user', res);
          Navigator.push(context, MaterialPageRoute(builder: (context) => const Home()));
          showToast(message: 'Account create successfull');
        }
      }
    // } catch (e) {
    //   print('e $e');
    //    showToast(message: e.toString());
    // }
    return null;
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    interestsController.dispose();
    skillsController.dispose();
    learningPlanController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('SignUp Page', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.deepOrange,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 29),
          child: Column(
            children: [
              const SizedBox(height: 40),
              const Center(
                child: Text('SignUp', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 20),
              FormContainerWidget(controller: nameController, hintText: 'Name', isPasswordField: false),
              const SizedBox(height: 20),
              FormContainerWidget(controller: emailController, hintText: 'Email', isPasswordField: false),
              const SizedBox(height: 20),
              FormContainerWidget(controller: passwordController, hintText: 'Password', isPasswordField: true),
              const SizedBox(height: 20),
              FormContainerWidget(controller: interestsController, hintText: 'Interests', isPasswordField: false),
              const SizedBox(height: 20),
              FormContainerWidget(controller: skillsController, hintText: 'Skills', isPasswordField: false),
              // const SizedBox(height: 20),
              // FormContainerWidget(controller: programmingLanguagesController, hintText: 'Programming languages', isPasswordField: false),
              const SizedBox(height: 20),
              FormContainerWidget(controller: experienceController, hintText: 'Experience', isPasswordField: false),
              // const SizedBox(height: 20),
              // FormContainerWidget(controller: knownFramworksController, hintText: 'Known framworks', isPasswordField: false),
              const SizedBox(height: 20),
              FormContainerWidget(controller: roleController, hintText: 'Role', isPasswordField: false),
              const SizedBox(height: 20),
              FormContainerWidget(controller: educationController, hintText: 'Education', isPasswordField: false),
              const SizedBox(height: 20),
              FormContainerWidget(controller: learningPlanController, hintText: 'Your Learning Plan', isPasswordField: false),
              const SizedBox(height: 20),
              FormContainerWidget(controller: resonalLanguageController, hintText: 'Resonal language', isPasswordField: false),
              GestureDetector(
                onTap: () {
                  SignUp();
                },
                child: Container(
                  width: double.infinity,
                  height: 45,
                  decoration: BoxDecoration(
                    color: Colors.deepOrange,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Center(
                    child: Text('Sign Up', style: TextStyle(color: Colors.blue)),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('You have an account?'),
                  TextButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginPage()));
                    },
                    child: const Text('Login', style: TextStyle(color: Colors.blue)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}