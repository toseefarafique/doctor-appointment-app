import 'package:doctor_appointment_app/doctor/appointment.dart';
import 'package:flutter/material.dart';
import 'doctor_profile.dart';
// import 'doctor_bottom_nav.dart';
import 'schedule.dart';
import 'time_slots.dart';
import 'patient_details.dart';
import 'appointment_details.dart';


class DoctorDashboard extends StatelessWidget {
  const DoctorDashboard({super.key});

  static const Color primaryBlue = Color(0xFF1565C0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFF3F8),

      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            // Maximum width on Web
            constraints: const BoxConstraints(
              maxWidth: 600,
              
            ),

            child: Scaffold(
              backgroundColor: const Color(0xFFF7F9FC),

              
              appBar: AppBar(
                backgroundColor: primaryBlue,
                foregroundColor: Colors.white,
                elevation: 0,

                title: const Text(
                  "Doctor Dashboard",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                actions: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.notifications_none,
                    ),
                  ),
                ],
              ),

              
              drawer: Drawer(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    DrawerHeader(
                      decoration: const BoxDecoration(
                        color: primaryBlue,
                      ),
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: const [
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.white,
                            child: Icon(
                              Icons.person,
                              size: 38,
                              color: primaryBlue,
                            ),
                          ),

                          SizedBox(height: 10),

                          Text(
                            "Dr. Sarah Khan",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          Text(
                            "Darmatalogist",
                            style: TextStyle(
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Dashboard
                    ListTile(
                      leading: const Icon(Icons.dashboard),
                      title: const Text("Dashboard"),
                      onTap: () {},
                    ),

                    // Appointments
                    ListTile(
                      leading:
                          const Icon(Icons.calendar_today),
                      title: const Text("Appointments"),
                      onTap: () {
                        Navigator.push(context,
                         MaterialPageRoute(builder:
                          (context)=>const DoctorAppointments()),
                          );


                      },
                    ),

                    // Schedule
                    

                    // Time Slots
                    
                  

                    // Profile
                    ListTile(
                      leading: const Icon(Icons.person),
                      title: const Text("Profile"),
                      onTap: () {
                        Navigator.push(context,
                         MaterialPageRoute(builder:
                          (context)=>const DoctorProfile()),
                          );
                      },
                    ),
                    ListTile(
  leading: const Icon(Icons.schedule),
  title: const Text("Schedule"),
  onTap: () {
    Navigator.pop(context);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const DoctorSchedule(),
      ),
    );
  },
),
ListTile(
  leading: const Icon(Icons.person_search),
  title: const Text("Patient Detail"),

  onTap: () {
    Navigator.pop(context);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const PatientDetails(),
      ),
    );
  },
),
ListTile(
  leading: const Icon(Icons.access_time),
  title: const Text("Time Slots"),
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const DoctorTimeSlots(),
      ),
    );
  },
),

                    const Divider(),

                    // Logout
                    ListTile(
                      leading: const Icon(Icons.logout),
                      title: const Text("Logout"),
                      onTap: () {},
                    ),
                  ],
                ),
              ),

              // ================= BODY =================
              body: SingleChildScrollView(
                padding: const EdgeInsets.all(20),

                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [
                    // ================= DOCTOR INFO =================
                    Row(
                      children: [
                        Container(
                          width: 100,
                          height: 100,

                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFFE3F2FD),

                            border: Border.all(
                              color: Colors.white,
                              width: 3,
                            ),
                          ),

                          child: const Icon(
                            Icons.person,
                            size: 70,
                            color: primaryBlue,
                          ),
                        ),

                        const SizedBox(width: 40),

                        const Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,

                            children: [
                              Text(
                                "Good Morning",
                                style: TextStyle(
                                  color: Color.fromARGB(
                                    255,
                                    20,
                                    19,
                                    19,
                                  ),
                                  fontSize: 20,
                                ),
                              ),

                              SizedBox(height: 5),

                              Text(
                                "Dr. Sara Khan",
                                style: TextStyle(
                                  color: Color.fromARGB(
                                    255,
                                    20,
                                    19,
                                    19,
                                  ),
                                  fontSize: 26,
                                  fontWeight:
                                      FontWeight.bold,
                                ),
                              ),

                              Text(
                                "Darmatalogist",
                                style: TextStyle(
                                  color: primaryBlue,
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 40),

                  
                    Row(
                      children: [
                        Expanded(
                          child: statCard(
                            icon:
                                Icons.calendar_today,
                            number: "12",
                            title:
                                "Today's\nAppointments",
                          ),
                        ),

                        const SizedBox(width: 10),

                        Expanded(
                          child: statCard(
                            icon:
                                Icons.pending_actions,
                            number: "5",
                            title:
                                "Pending\nRequests",
                          ),
                        ),

                        const SizedBox(width: 10),

                        Expanded(
                          child: statCard(
                            icon: Icons.people,
                            number: "8",
                            title:
                                "Total\nPatients",
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Today Schedule",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                        TextButton(onPressed:(){},
                          child: Text("View All",
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.w600,
                          ),)),
          
                      ],
                    ),
                    const SizedBox(height: 29,),
                     Card(
  child: Padding(
    padding: const EdgeInsets.all(16),
    child: Row(
      children: [
        Text(
          "10:00 AM",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(width: 20),

        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Ali Raza",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: 15),

              Text("Consultation"),
            ],
          ),
        ),

        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 6,
          ),
          decoration: BoxDecoration(
            color: Colors.green.shade50,
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Text(
            "Confirmed",
            style: TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    ),
  ),
),
Card(
  child: Padding(
    padding: const EdgeInsets.all(16),
    child: Row(
      children: [
        Text(
          "10:30 AM",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(width: 20),

        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Fatima Noor",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: 10),

              Text("Follow-up"),
            ],
          ),
        ),

        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 6,
          ),
          decoration: BoxDecoration(
            color: Colors.green.shade50,
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Text(
            "Upcoming",
            style: TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    ),
  ),
),
Card(
  child: Padding(
    padding: const EdgeInsets.all(16),
    child: Row(
      children: [
        Text(
          "02:00 PM",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(width: 15),

        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Ahmed Farooq",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: 10),

              Text("Consultation"),
            ],
          ),
        ),

        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 6,
          ),
          decoration: BoxDecoration(
            color: Colors.green.shade50,
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Text(
            "Upcoming",
            style: TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    ),
  ),
),
                   
                  ], 
                ),
              ),
              
            ),
          ),
        ),
        
      ),
  //     bottomNavigationBar: const DoctorBottomNav(
  //   currentIndex: 0,
  // ),

    );
  }

  
  Widget statCard({
    required IconData icon,
    required String number,
    required String title,
  }) {
    return Card(
      elevation: 2,

      child: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [
            Icon(
              icon,
              color: primaryBlue,
              size: 30,
            ),

            const SizedBox(height: 8),

            Text(
              number,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            Text(
              title,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}