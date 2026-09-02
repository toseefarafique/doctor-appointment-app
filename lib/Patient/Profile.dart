import 'package:flutter/material.dart';

class profile extends StatefulWidget {
  const profile({super.key});

  @override
  State<profile> createState() => _profileState();
}

class _profileState extends State<profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 170,
              decoration: BoxDecoration(
                
                color: Colors.blueAccent,
                borderRadius: BorderRadius.only(
                  bottomLeft:Radius.circular(50),
                  bottomRight: Radius.circular(50)),
              ),
              child: Padding(padding: EdgeInsets.all(20),
           child: Row(
            children: [  
            Expanded(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Profile",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),),
              Text("Manage your Account and Setting",
              style: TextStyle(
                color: Colors.white,
                fontSize: 15
              ),)
                ],
              ),),
             Align(
              alignment: Alignment.topRight,
               child:IconButton(onPressed: (){},
               icon: Icon(Icons.notifications),
               color: Colors.white,
               iconSize: 35,),
             ),
              ],
           ),),
            ),
       Padding(padding: EdgeInsets.only(left: 30,right: 30),
        child:Container(
           decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(padding: EdgeInsetsGeometry.all(20),
         
          child: Row(
            children: [
               Stack(
          alignment: Alignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.blue.shade100,
              child: Icon(Icons.person,
              size: 60,
              color: Colors.blueAccent,),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child:CircleAvatar(
                radius: 18,
                backgroundColor: Colors.blueAccent,
                child: Icon(
                  Icons.edit,
                  color: Colors.white,
                  size: 22,
                ),
              )
            )
          ],
         ),
         SizedBox(width: 20),
         Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Sana Khan",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),),
             Text("Patient",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),),
             Text("Taking Care of your self",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),),
            

          ],
         )
            ],
          ),),
        ),)
          ],
        ),
      ),
    );
  }
}