// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'dart:math';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import '../../../../global/common/toast.dart';

class Product extends StatefulWidget{
  final String course_title;
  final String url;
  final String sub_titles;
  const Product({super.key, required this.course_title, required this.url, required this.sub_titles});

  @override
  State<Product> createState() => _ProductState();
}

class _ProductState extends State<Product> {
    Future<Map<String,dynamic>?> postData(String course_name, String  course_url) async {
    try{

      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {
        final user = Hive.box('user').get('user');
        
        final url = "https://merd-api.merakilearn.org/developers/courses/resource?course_name=$course_name&developers_id=${user['id']}&course_url=$course_url";
        final response = await  http.get(Uri.parse(url));
        var data = jsonDecode(response.body);
        return data; 
      } else {
        showToast(message: 'Network error ');
        return {'errror':'Network error'};
      }
    } catch (e) {
      return throw e.toString();
    }
  }
 

  @override
  Widget build(BuildContext context){
    return SizedBox(
      width:max(300, min(MediaQuery.of(context).size.width, 500)),
      child: Row(
        children: [
          Expanded(
            child:Card(
              elevation: 6,
                child:  ListTile(
                  title: Text('Course Title: ${widget.course_title}',style: const TextStyle(fontWeight: FontWeight.bold),),
                  subtitle: Text(widget.sub_titles),
                  trailing: IconButton(
                    icon: const Icon(Icons.open_in_new),
                    onPressed:  () async{
                      await postData(widget.course_title, widget.url);
                      // ignore: deprecated_member_use
                      launch(widget.url);
                    },
                  ),
                ),
              )
          ),
          const SizedBox(height: 10, width: 10,),
        ],
      ),
    );
  }
}