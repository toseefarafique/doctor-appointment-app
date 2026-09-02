import 'package:doctor_appointment_app/doctor/schedule.dart';
import 'package:flutter/material.dart';

import 'doctor_dashboard.dart';
import 'doctor_profile.dart';
import 'appointment.dart';
import '../admin/admin_dashboard.dart';


class DoctorMainScreen extends StatefulWidget {
  const DoctorMainScreen({super.key});

  @override
  State<DoctorMainScreen> createState() => _DoctorMainScreenState();
}

class _DoctorMainScreenState extends State<DoctorMainScreen> {
  int selectedIndex = 0;

  final List<Widget> screens = [
    const DoctorDashboard(),

    // const Center(
    //   child: Text("Appointments"),
    // ),
    const DoctorAppointments(),

    const DoctorSchedule(),

    const DoctorProfile(),
    

  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFF3F8),

      body: Center(
        child: Container(
          width: 600,
          height: 1100,

          clipBehavior: Clip.antiAlias,

          decoration: BoxDecoration(
            color: const Color(0xFFF7F9FC),
            borderRadius: BorderRadius.circular(20),
          ),

          child: Scaffold(
            body: screens[selectedIndex],

            bottomNavigationBar: SizedBox(
              height: 65,

              child: BottomNavigationBar(
                currentIndex: selectedIndex,

                type: BottomNavigationBarType.fixed,

                selectedItemColor:
                    const Color(0xFF1565C0),

                unselectedItemColor: Colors.grey,

                selectedFontSize: 11,
                unselectedFontSize: 10,

                showUnselectedLabels: true,

                onTap: (index) {
                if (index == 4) {
                 Navigator.push(
                 context,
                  MaterialPageRoute(
                 builder: (_) => const AdminDashboard(),
                   ),
                 );
                 } else {
                  setState(() {
                   selectedIndex = index;
                   });
                  }
                 },

                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.dashboard),
                    label: "Dashboard",
                  ),

                  BottomNavigationBarItem(
                    icon: Icon(Icons.calendar_today),
                    label: "Appointments",
                  ),

                  BottomNavigationBarItem(
                    icon: Icon(Icons.schedule),
                    label: "Schedule",
                  ),

                  BottomNavigationBarItem(
                    icon: Icon(Icons.person),
                    label: "Profile",
                  ),

                  BottomNavigationBarItem(
                    icon: Icon(Icons.admin_panel_settings),
                    label: "Admin",
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}