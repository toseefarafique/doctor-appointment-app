import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AppointmentBook1 extends StatefulWidget {
  final Map<String, dynamic> doctor;

  const AppointmentBook1({
    super.key,
    required this.doctor,
  });

  @override
  State<AppointmentBook1> createState() => _AppointmentBook1State();
}

class _AppointmentBook1State extends State<AppointmentBook1> {
  String? selectedDay;
String? selectedTime;
final TextEditingController _reasonController =
    TextEditingController();

List<String> availableDays = [];
List<String> availableTimes = [];

void loadSchedule() {
  final schedule = widget.doctor['schedule'];

  if (schedule != null) {
    final Map<String, dynamic> doctorSchedule =
        Map<String, dynamic>.from(schedule);

    setState(() {
      availableDays = doctorSchedule.keys.toList();

      if (availableDays.isNotEmpty) {
        selectedDay = availableDays[0];

        availableTimes = List<String>.from(
          doctorSchedule[selectedDay] ?? [],
        );
      }
    });
  }
}
@override
void initState() {
  super.initState();
  loadSchedule();
}
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
        color: selected ?Colors.blueAccent :Colors.blueAccent,
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
 Future<void> bookAppointment() async {
  try {
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please login first"),
        ),
      );
      return;
    }

    if (selectedDay == null || selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select date and time"),
        ),
      );
      return;
    }

    // Patient data
    DocumentSnapshot patientDoc =
        await FirebaseFirestore.instance
            .collection('patients')
            .doc(user.uid)
            .get();

    if (!patientDoc.exists) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Patient data not found"),
        ),
      );
      return;
    }

    Map<String, dynamic> patientData =
        patientDoc.data() as Map<String, dynamic>;

    String patientName = patientData['name'] ?? '';

    // Save appointment
    await FirebaseFirestore.instance
        .collection('appointments')
        .add({
      'patientId': user.uid,
      'patient': patientName,
      'doctor': widget.doctor['name'] ?? 'Doctor',
      'date': selectedDay,
      'time': selectedTime,
      'reason': _reasonController.text.trim(),
      'status': 'Confirmed',
      'type': 'Consultation',
      'createdAt': FieldValue.serverTimestamp(),
    });

    if (!mounted) return;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text(
            "Appointment Confirmed",
          ),
          content: Text(
            "Your appointment with ${widget.doctor['name'] ?? 'Doctor'} has been booked successfully.",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text(
                "OK",
                style: TextStyle(
                  color: Colors.blueAccent,
                  fontSize: 20,
                ),
              ),
            ),
          ],
        );
      },
    );
  } on FirebaseException catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          e.message ?? "Failed to book appointment",
        ),
      ),
    );
  }
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
           Text(widget.doctor['name'] ?? 'Doctor',
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
              fontSize: 25,
            ),),
            SizedBox(height: 25),
         Wrap(
  spacing: 10,
  runSpacing: 10,
  children: availableDays.map((day) {
    return GestureDetector(
      onTap: () {
        final schedule = widget.doctor['schedule'];

        final Map<String, dynamic> doctorSchedule =
            Map<String, dynamic>.from(schedule ?? {});

        setState(() {
          selectedDay = day;
          availableTimes = List<String>.from(
            doctorSchedule[day] ?? [],
          );
          selectedTime = null;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 12,
        ),
        decoration: BoxDecoration(
          color: selectedDay == day
              ? Colors.blueAccent
              : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Colors.blueAccent,
          ),
        ),
        child: Text(
          day,
          style: TextStyle(
            color: selectedDay == day
                ? Colors.white
                : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }).toList(),
),
           SizedBox(height: 20),
           Text("Select Time",
           style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 25,
           ),
           ),
           SizedBox(height: 20),
         Wrap(
  spacing: 30,
  runSpacing: 10,
  children: availableTimes.map((time) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTime = time;
        });
      },
      child: timeCard(
        time,
        selectedTime == time,
      ),
    );
  }).toList(),
),
            SizedBox(height: 20),
           Text("Reason For Visit",
           style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 25,
           ),
           ),
           SizedBox(height: 20), 
           TextField(
            controller: _reasonController,
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

           SizedBox(height: 40),
          Padding(padding: EdgeInsets.all(15),
          //  child:ElevatedButton(onPressed: (){
          //   showDialog(context: context,
          //    builder: (context){
          //     return AlertDialog(
          //       backgroundColor: Colors.white,
          //       title: Text("Appointment Confirmed"),
          //       content: Text("Your Appointment with ${widget.doctor['name']?? 'Doctor'} Khan has booked successfully",
          //       style: TextStyle(
          //         fontSize: 15,
          //       ),),
          //     actions: [
          //       TextButton(onPressed: (){
          //         Navigator.pop(context);
          //       },
          //        child: Text("OK",
          //        style: TextStyle(
          //         color: Colors.blueAccent,
          //         fontSize: 20,
          //        ),))
          //     ],
          //     );
  
          //    });
             
          //  }, 
          child:ElevatedButton(onPressed: bookAppointment, 
            style: ElevatedButton.styleFrom(
           backgroundColor: Colors.blueAccent,
           foregroundColor: Colors.white,
           minimumSize: Size(double.infinity, 65),
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