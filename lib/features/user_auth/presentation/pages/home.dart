import 'dart:convert';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import '../../../../global/common/toast.dart';
import '../widgets/prodect_widget.dart';
import 'dart:async';
import 'Account.dart';
import 'login.dart';

class Home extends StatefulWidget{
  const Home({super.key});
  @override
  State createState() => _HomeState();
}

class _HomeState extends State<Home>{
  late Future<List<dynamic>?> items;

  Future<List<dynamic>?> gettingData() async {
    try{
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {
        final course =  Hive.box('user').get('ai_course');
        if (course != null) {
          return course;
        }
        final user = Hive.box('user').get('user');
        print('user $user');
        final url = "https://merd-api.merakilearn.org/developers/recommended/courses/${user['id']}";      
        final response = await  http.get(Uri.parse(url));
        var dataOfCourse = jsonDecode(response.body);
        Hive.box('user').put('ai_course', dataOfCourse);
        return dataOfCourse;
      } else {
        showToast(message: 'Network error ');
        return ['Network error'];
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
        // title: const Text('Home Page', style: TextStyle(color: Colors.black),),
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
              IconButton(icon: const Icon(Icons.account_box_sharp), onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder:(context) => const Account() ));
              }),
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
            return const Center(child: CircularProgressIndicator(
              semanticsLabel: 'Circular progress indicator',
              color: Colors.deepOrange,
            ),);
          }
          if (snapshot.hasError) {
            return  Center(child: Text(snapshot.error.toString()));
          }
          return SingleChildScrollView(
            child:  Center(
              child: Padding(
                padding: const EdgeInsets.all(16.7),
                child: Column( 
                  children: [
                    const Text('Welcome to Abhyas learning platform', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                    SizedBox(
                    child: Column(
                      children: <Widget> [
                        for (var item in snapshot.data!)                        
                          Product(
                            course_title: item['course_title'],
                            url: item['url'],
                            sub_titles : 'Category: ${item['category']}\nRating: ${item['rating']}\nEnrolled Students: ${item['enrolledStudents']}\nReviews: ${item['reviews']}\nCertificate: ${item['Certificate']}\nPrice: ${item['Price']}'
                          ),]
                    )
                  )
                ]
              ),
            ),
          ),
        );
        }
      ),
    );
  }
}