import 'package:flutter/material.dart';
import 'package:login_with_token_post/pages/secondpage.dart';

class FirstPage extends StatelessWidget{

  final String token;
  FirstPage({required this.token});

  @override
  Widget build(BuildContext context){
    return Scaffold(
        appBar: AppBar(
          title: Text('First Page'),
        ),
        body: Container(
          child: Center(
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> SecondPage()));
                    },
                    child: Text('second page'),
                  ),
                  Text('bearer:  $token'),
                ],

              )
          ),
        )
    );
  }
}