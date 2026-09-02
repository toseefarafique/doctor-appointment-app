import 'package:flutter/material.dart';

class AppointmentDetails extends StatelessWidget {
  const AppointmentDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        },
         icon: Icon(Icons.arrow_back,
         color: Colors.white,
         size: 30,)),
         title:Text("Appointment Details",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),),
         
      ),
      body: Center(
        child: Container(
          child: Padding(padding: EdgeInsets.all(20),
          child: Column(
            children: [
              CircleAvatar(
                radius: 55,
                backgroundColor: Colors.blueAccent,
                child: Icon(Icons.calendar_month,
                size: 70,
                color: Colors.white,),
              ),
              SizedBox(height: 12),
            TextButton(onPressed: (){},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 229, 255, 200)
            ),
             child: Text("Confirmed",
             style: TextStyle(
              color: const Color.fromARGB(255, 149, 235, 52),
              fontWeight: FontWeight.bold,
              fontSize: 18,
             ),)),
             SizedBox(height: 5),
             Text("Dr.Ayesha Khan",
             style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
             ),),
             SizedBox(height: 5),
             Text("Cardiologist",
             style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
             ),),
             SizedBox(height: 20),
             Row(
              children: [
                Padding(padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                      Icon(Icons.calendar_view_month_outlined,
                      color: Colors.blueAccent,
                      size: 28),
                      SizedBox(width: 10),
                      Text("Date",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),),
                        
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(Icons.timer,
                        color: Colors.blueAccent,
                        size: 28),
                        SizedBox(width: 11),
                        Text("Time",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),)
                      ],
                    ),
                     SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(Icons.medical_services,
                        color: Colors.blueAccent,
                        size: 28),
                        SizedBox(width: 11),
                        Text("Consultation Fee",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),)
                      ],
                    ),
                     SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(Icons.location_on,
                        color: Colors.blueAccent,
                        size: 28),
                        SizedBox(width: 11),
                        Text("Location",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),)
                      ],
                    ),
                     SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(Icons.upload,
                        color: Colors.blueAccent,
                        size: 28),
                        SizedBox(width: 11),
                        Text("Reason",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),)
                      ],
                    )
                  ],
                ),),
              Expanded(child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                    Text("25 May 2026",
                style: TextStyle(color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 20),),
                SizedBox(height: 10),
                 Text("10:00 AM",
                style: TextStyle(color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 20),),
                SizedBox(height: 10),
                 Text("Rs.1500",
                style: TextStyle(color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 20),),
                SizedBox(height: 10),
                 Text("City,Hospital,Room 305",
                style: TextStyle(color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 20),),
                SizedBox(height: 10),
                 Text("Regular Checkup",
                style: TextStyle(color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 20),),

                ],
              ))
              ],
             ),
             SizedBox(height: 40),
             ElevatedButton(onPressed: (){
              showDialog(context: context,
               builder: (context){
                return AlertDialog(
                  title: Text("Cencel Appointment"),
                  content: Text("Are you sure you want to cencel this appointment"),
                  actions: [
                    TextButton(onPressed: (){
                      Navigator.pop(context);
                    },
                     child: Text("No")),
                     TextButton(onPressed: (){
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar
                      (content:Text("Appointment Cenceled")));
                     },
                      child: Text("Yes"))
                  ],);
               });
             },
             style: ElevatedButton.styleFrom(
              minimumSize: Size(double.infinity, 55),
              side: BorderSide(
                color: Colors.red,
                width: 2,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)
              )
             ),
              child: Text("Cancel Appointment",
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
              ))
            ],
          ),),
        ),
      ),
    
      
        
    
    );
  }
}