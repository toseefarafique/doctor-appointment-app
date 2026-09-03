import 'package:flutter/material.dart';
import 'Appointment_Book1.dart';

class Doctor_profile1 extends StatelessWidget {
  const Doctor_profile1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    
       body: SingleChildScrollView(
       child:Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
       Container(
        height: 250,
        width: double.infinity,
        color: Colors.blueAccent,
        child: Stack(
          alignment: AlignmentGeometry.center,
          children: [
            Positioned(
              left: 10,
              top: 40,
              child: IconButton(onPressed: (){
                Navigator.pop(context);
              },
               icon: Icon(Icons.arrow_back,
               color: Colors.white,
               size: 32)),
            ),
            Positioned(
              right: 10,
              top: 40,
              child: IconButton(onPressed: (){},
               icon: Icon(Icons.favorite_border_sharp,
               color: Colors.white,
               size: 30,))),
               Positioned(
                bottom: 15,
                child:Container(
                  height: 160,
                  width: 160,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 182, 224, 243),
                    shape: BoxShape.circle,

                  ),
                  child: ClipOval(
                    child: Image.asset(
                      'assets/images/Doctor1.png',
                      height: 20,
                      
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                
                ),
          ],
        ),
       ),
      Padding(padding: EdgeInsets.only(left: 20,top: 10),
       child:Text("Dr. Ayesha Khan",
       style: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
        fontSize: 30,
       ),)
           ),
      Padding(padding: EdgeInsets.only(left: 22),
      child: Text("Cardiologist",
      style: TextStyle(fontSize: 20,
      color: Colors.black,
      fontWeight: FontWeight.bold),),),
      Padding(padding: EdgeInsets.all(15),
      child: Row(
        children: [
          Icon(Icons.star,
          color: Colors.amber,
          size: 25,),
          Text(" 4.8",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),),
          Text(" (256 Reviews)",
          style: TextStyle(fontSize: 15),),
        ],
      ),),

      Padding(padding: EdgeInsets.only(left: 20),
      child: Row(
        children: [
         Text(" 5+",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),),
          Text(" Years Experience",
          style: TextStyle(fontSize: 17,
          color: Colors.black87,
          fontWeight: FontWeight.bold),),
        ],
      ),),
      Padding(padding: EdgeInsetsGeometry.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("About:",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),),
         Padding(padding: EdgeInsets.only(top: 10),
          child:Text("Dr. Ayesha is an experienced cardiologist specializing in heart health and cardiovascular care. She provides personalized treatment and focuses on helping patients maintain a healthy heart.",
          style: TextStyle(
            color: Colors.black,
            fontSize: 17,
          ),)),
          Padding(padding: EdgeInsets.only(top: 15),
          child: Text("Consultation Fee",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          )),),
          Padding(padding: EdgeInsets.only(top: 5),
          child: Text("Rs: 1500",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          )),),
         Padding(padding: EdgeInsets.all(15),
          child:ElevatedButton(onPressed: (){
            Navigator.push(context,
            MaterialPageRoute(builder: (context)=>const AppointmentBook1()));
          },
          style: ElevatedButton.styleFrom(
           backgroundColor: Colors.blueAccent,
           foregroundColor: Colors.white,
           minimumSize: Size(double.infinity, 60),
           shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))
           )
          ),
           child: Text("Book Appointment",
           style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20
           ),
           )))
        ],
      
      ),) ,    
          
        
        ]
       )
       ),  
    );
  }
}