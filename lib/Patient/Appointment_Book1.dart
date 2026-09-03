import 'package:flutter/material.dart';

class AppointmentBook1 extends StatefulWidget {
  const AppointmentBook1({super.key});

  @override
  State<AppointmentBook1> createState() => _AppointmentBook1State();
}

class _AppointmentBook1State extends State<AppointmentBook1> {
  Widget dateCard(String day,String date,String month,bool selected)
 {
   return Container(
    width: 72,
    height: 89,
    
    decoration: BoxDecoration(
      color: selected ? Colors.blueAccent: Colors.white,
     borderRadius: BorderRadius.circular(10),
     border: Border.all(
     color: selected ? Colors.blueAccent: Colors.grey.shade300,
     ),
     boxShadow: [
      BoxShadow(
        
        color: Colors.grey.withOpacity(0.15),
          blurRadius: 5,
      ),
     ]
     
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(day,
        style: TextStyle(
           color: selected ? Colors.white : Colors.black,
            fontSize: 15,
        ),),
        Text(date,
          style: TextStyle(
            color: selected ? Colors.white : Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),),

        Text(month,
        style: TextStyle(
         color: selected ? Colors.white :Colors.grey, 
         fontSize: 15,
        ),) ,
        
      ],
    ),
      
      
      
   );
 }
 Widget timeCard(String time, bool selected){
  return Container(
    
    width: 120,
    height: 45,
    decoration: BoxDecoration(
      
      color: selected ? Colors.blueAccent :Colors.white,
      borderRadius: BorderRadius.circular(10),
      border: Border.all(
        color: selected ?Colors.blueAccent :Colors.grey.shade300,
      )
    ),
    child: Center(
      child: Text(time,
      style: TextStyle(
        color: selected ?Colors.white :Colors.blueAccent,
        fontWeight: FontWeight.bold,
        fontSize: 15,
      ),),
    ),
  );
 }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar:AppBar(
        backgroundColor: Colors.white,
        leading:IconButton(onPressed: (){
          Navigator.pop(context);
        },
         icon: Icon(Icons.arrow_back,
         color: Colors.black,
         size: 30,)),
        centerTitle: true,
         title: Column(
         crossAxisAlignment: CrossAxisAlignment.center,
          children: [
          Padding(padding: EdgeInsets.only(top: 8),
           child: Text("Book Appointment",
            style: TextStyle(color: Colors.black,
            fontSize: 23,
            fontWeight:FontWeight.bold ),),
          ),
            Text("Dr.Ayesha Khan",
            style: TextStyle(fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black),)
          ],
         ),
      ),
      body: SingleChildScrollView(
        
       child: Padding(padding: EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Select Date",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),),
           Padding(padding: EdgeInsets.all(15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              dateCard("Mon","20","May",false),
              dateCard("Tues","21","May",true),
              dateCard("Thur","23","may",false),
              dateCard("Fri","24","may",false),
              dateCard("Sat","25","may",false),
              
            ],
           )),
           SizedBox(height: 10,),
           Text("Select Time",
           style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 22,
           ),
           ),
           SizedBox(height: 15),
           Wrap(
            
            spacing: 30,
            runSpacing: 10,
            children: [
              timeCard("9:00 AM",false),
              timeCard("10:00 AM",true),
               timeCard("11:00 AM",false),
              timeCard("12:00 PM",false),
               timeCard("3:00 PM",false),
              timeCard("4:00 PM",false),
              timeCard("5:00 PM",false),
              timeCard("6:00 PM",false),
            
              
            ],
           ),

            SizedBox(height: 18),
           Text("Reason For Visit",
           style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 22,
           ),
           ),
           SizedBox(height: 10), 
           TextField(
            
           decoration: InputDecoration(
            hintText: "Enter Reason(Optional)",
            filled: true,
            fillColor: Color(0xFFF5F7FA),
            border: OutlineInputBorder(
              
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            )
           ),
           ),

           SizedBox(height: 30),
          Padding(padding: EdgeInsets.all(15),
           child:ElevatedButton(onPressed: (){
            showDialog(context: context,
             builder: (context){
              return AlertDialog(
                backgroundColor: Colors.white,
                title: Text("Appointment Confirmed"),
                content: Text("Your Appointment with Dr.Ayesha Khan has booked successfully",
                style: TextStyle(
                  fontSize: 15,
                ),),
              actions: [
                TextButton(onPressed: (){
                  Navigator.pop(context);
                },
                 child: Text("OK",
                 style: TextStyle(
                  color: Colors.blueAccent,
                  fontSize: 20,
                 ),))
              ],
              );
  
             });
           }, 
            style: ElevatedButton.styleFrom(
           backgroundColor: Colors.blueAccent,
           foregroundColor: Colors.white,
           minimumSize: Size(double.infinity, 60),
           shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))
           )
          ),
           child: Text("Confirm Appointment",
           style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20
           ),
           )))
          ],
        ),),
      ),
    );
  }
}