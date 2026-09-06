import 'package:doctor_appointment_app/doctor/schedule.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

  bool isLoadingDoctor = true;

  String doctorId = "";
  String doctorName = "";
  String specialization = "";

  @override
  void initState() {
    super.initState();
    loadDoctorData();
  }

  // ============================================================
  // LOAD LOGGED-IN DOCTOR FROM FIRESTORE
  // ============================================================

  Future<void> loadDoctorData() async {
    try {
      final User? user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        setState(() {
          isLoadingDoctor = false;
        });
        return;
      }

      final DocumentSnapshot<Map<String, dynamic>> doctorDoc =
      await FirebaseFirestore.instance
          .collection('doctors')
          .doc(user.uid)
          .get();

      if (doctorDoc.exists) {
        final data = doctorDoc.data();

        if (data != null) {
          setState(() {
            doctorId = user.uid;

            doctorName =
                data['name']?.toString() ?? "Doctor";

            specialization =
                data['specialization']?.toString() ?? "";

            isLoadingDoctor = false;
          });
        } else {
          setState(() {
            isLoadingDoctor = false;
          });
        }
      } else {
        setState(() {
          isLoadingDoctor = false;
        });
      }
    } catch (e) {
      debugPrint("Error loading doctor data: $e");

      if (mounted) {
        setState(() {
          isLoadingDoctor = false;
        });
      }
    }
  }

  // ============================================================
  // DOCTOR SCREENS
  // ============================================================

  List<Widget> get screens {
    return [
      const DoctorDashboard(),

      const DoctorAppointments(),

      const DoctorSchedule(),

      isLoadingDoctor
          ? const Center(
        child: CircularProgressIndicator(
          color: Colors.blueAccent,
        ),
      )
          : DoctorProfile(
        doctorId: doctorId,
        doctorName: doctorName,
        specialization: specialization,
      ),
    ];
  }

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

            // ======================================================
            // BOTTOM NAVIGATION
            // ======================================================

            bottomNavigationBar: SizedBox(
              height: 65,

              child: BottomNavigationBar(
                currentIndex: selectedIndex,

                type: BottomNavigationBarType.fixed,

                selectedItemColor: Colors.blueAccent,

                unselectedItemColor: Colors.grey,

                selectedFontSize: 11,

                unselectedFontSize: 10,

                showUnselectedLabels: true,

                onTap: (index) {
                  // ADMIN
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}