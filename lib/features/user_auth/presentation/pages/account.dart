// ignore_for_file: prefer_interpolation_to_compose_strings

import 'dart:convert';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import '../../../../global/common/toast.dart';
import 'dart:async';
import '../widgets/footer.dart';
import 'chat.dart';
import 'login.dart';

class Account extends StatefulWidget{
  const Account({super.key});
  @override
  State createState() => _AccountState();
}

class _AccountState extends State<Account>{
  late Future<List> items;
  final user = Hive.box('user').get('user');

  Future<List> gettingData() async {
    try{
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {
        final url = "https://merd-api.merakilearn.org/developers/progress/${user['id']}";
        final response = await  http.get(Uri.parse(url));
        var dataOfCourse = jsonDecode(response.body);
        return dataOfCourse; 
      } else {
        showToast(message: 'Network error ');
        return [{'errror':'Network error'}];
      }
    } catch (e) {
      return throw e.toString();
    }
  }

  @override
  void initState() {
    super.initState();
    items = gettingData();
  }
  @override
  Widget build(BuildContext content){
    return   Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        actions: [
          Card(
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.logout),
                  tooltip: "Log-out",
                  onPressed: () {
                    Hive.box('user').delete('user');
                    Hive.box('user').delete('ai_course');          
                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder:(context) => const LoginPage() ), (route)=> false);
                    showToast(message: 'Logout Successfull');
                  },
                ),
               Row(
                  children: [
                    const Text('You can ask your questions? '),
                    IconButton(icon: const Icon(Icons.chat),tooltip: 'AI bot', onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder:(context) => const ChatScreen() ));
                    }),
                  ],
                ),
              ],
            )
          )
        ],
        title: const  Text('Abhyas', style: TextStyle( color: Colors.black54 , fontSize: 20, fontWeight: FontWeight.bold,fontFamily: AutofillHints.familyName),),
      ),
      body: FutureBuilder(
        future: items, 
        builder: ( context, snapshot){
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator.adaptive(),);
          }
          if (snapshot.hasError) {
            return  Center(child: Text(snapshot.error.toString()));
          }

          late List? courses = snapshot.data;
          return SingleChildScrollView(
            child:  Center(
              child: Padding(
                padding: const EdgeInsets.all(1.7),
                child: Column( 
                  children: [
                    SizedBox(
                    child: Column(
                      children: <Widget> [
                          Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          color: Colors.deepOrange, // Add this line
                          child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 10),
                                Text(
                                  "Email: " + user?['email'],
                                  style: const TextStyle(fontSize: 16, color: Colors.white), // Add this line
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  "Interests: " + user?['intrests'],
                                  style: const TextStyle(fontSize: 16, color: Colors.white), // Add this line
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  "Skills: " + user?['skills'],
                                  style: const TextStyle(fontSize: 16, color: Colors.white), // Add this line
                                ),
                                const SizedBox(height: 10),
                                // // Text("Experience: " + profileData?['experience'], style: const TextStyle(fontSize: 16)),
                                // const SizedBox(height: 10),
                                // Text("Programming Languages: " + profileData?['programming_languages'], style: const TextStyle(fontSize: 16)),
                                // const SizedBox(height: 10),
                                // Text("Resonal Language: " + profileData?['resonal_language'], style: const TextStyle(fontSize: 16)),
                                // const SizedBox(height: 10),
                                // Text("Known Frameworks: " + profileData?['known_framworks'], style: const TextStyle(fontSize: 16)),
                                // const SizedBox(height: 10),
                                // Text("Learning Plan: " + profileData?['learning_plan'] , style: const TextStyle(fontSize: 16)),
                              ],
                            ),
                          ),
                        ),
                        Text(
                          courses!.isNotEmpty 
                            ? 'You are interested in these courses!' 
                            : 'No courses selected.',
                          style: const TextStyle(fontSize: 16),
                        )
                        ,
                        for (var course in courses)
                          Card(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                            color: Colors.blueGrey[50], // Adjust the background color as desired
                            child: Padding(
                              padding: const EdgeInsets.all(35),
                              child: SizedBox( // Set card size
                                width: 300, // Adjust card width as needed
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 4),
                                    Text("Course Name: " + course?['course_name'], style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 10),
                                    IconButton(
                                      icon: const Icon(Icons.open_in_new),
                                      onPressed:  () async{
                                        launch(course?['course_url']);
                                      },
                                    ),
                                    const SizedBox(height: 4),
                                    // Text("Course Category: " + course?['course_category'], style: const TextStyle(fontSize: 10)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                      ]
                    )
                  )
                ]
              ),
            ),
          ),
        );
        }
      ),
      bottomNavigationBar: const FooterWidget()
    );
  }
}