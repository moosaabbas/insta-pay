import 'package:flutter/material.dart';

class MyHeaderDrawer extends StatefulWidget{

  // final String name;
  // String imageURL;
  const MyHeaderDrawer({super.key, required this.imageURL, required this.name, required this.email});
  final String name;
  final String email;
  final String imageURL;
  @override
  State<MyHeaderDrawer> createState() => _MyHeaderDrawerState();
}

class _MyHeaderDrawerState extends State<MyHeaderDrawer> {
  
  late final String imageURL;
  late final String name;
  late final String email;
  _MyHeaderDrawerState();
  
  @override

  void initState(){
    imageURL = widget.imageURL;
    name = widget.name;
    email = widget.email;
    super.initState();

  }

  @override
  Widget build(BuildContext context){
    return SafeArea(
      child: Column(
        children: [
          Container(
            color: Colors.blue[900],
            width: double.infinity,
            height: 200,
            padding: const EdgeInsets.only(top:20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  height: 70,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: imageURL == 'NULL'? const AssetImage('assets/images/profile_avatar.png') as ImageProvider: NetworkImage(imageURL),
                    ),
                    ),
                  ),
                  
                  Text(name, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600)),
                  
                  Text(email, style: TextStyle(color: Colors.grey[200]),)
                
                ]),
            ),
            const SizedBox(height: 10.0,),
            
            TextButton(
              onPressed: ((() {
                Navigator.popUntil(context, (route) => route.isFirst);
              })), 
              child: Text('Logout', 
              style:TextStyle(
                fontSize: 25.0,
                color: Colors.red[500],
              ) ,
              ))
            
        ],
      ),
    );
  }
}