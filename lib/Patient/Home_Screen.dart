import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'Chat_Screen.dart';
import 'Doctor_Profile1.dart';
import 'My_Appointments.dart';
import 'Profile.dart';
import 'Search_screen.dart';

class homePage extends StatefulWidget {
  const homePage({super.key});

  @override
  State<homePage> createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  String patientName = "Patient";

  @override
  void initState() {
    super.initState();
    loadPatientName();
  }

  // ============================================================
  // GET LOGGED-IN PATIENT NAME FROM FIRESTORE
  // ============================================================

  Future<void> loadPatientName() async {
    try {
      final User? user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        return;
      }

      final DocumentSnapshot<Map<String, dynamic>> patientDoc =
          await FirebaseFirestore.instance
              .collection('patients')
              .doc(user.uid)
              .get();

      if (patientDoc.exists) {
        final data = patientDoc.data();

        if (data != null && data['name'] != null) {
          if (mounted) {
            setState(() {
              patientName = data['name'].toString();
            });
          }
        }
      }
    } catch (e) {
      debugPrint("Error loading patient name: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,

      body: Center(
        child: Container(
          width: 600,
          height: 844,
          clipBehavior: Clip.hardEdge,

          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 20,
                spreadRadius: 2,
              ),
            ],
          ),

          child: Column(
            children: [
              // =====================================================
              // HOME CONTENT
              // =====================================================

              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // =================================================
                      // TOP HEADER
                      // =================================================

                      Container(
                        height: 200,
                        width: double.infinity,

                        decoration: const BoxDecoration(
                          color: Colors.blueAccent,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ),
                        ),

                        child: Padding(
                          padding: const EdgeInsets.all(20),

                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,

                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,

                                  children: [
                                    Text(
                                      "Hi $patientName !",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 25,
                                      ),
                                    ),

                                    const Text(
                                      "How are you today?",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17,
                                      ),
                                    ),

                                    const SizedBox(height: 30),

                                    TextField(
                                      readOnly: true,

                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const Search_screen(),
                                          ),
                                        );
                                      },

                                      decoration: InputDecoration(
                                        hintText: "Search doctors...",

                                        prefixIcon: const Icon(
                                          Icons.search,
                                          color: Colors.blueAccent,
                                          size: 28,
                                        ),

                                        filled: true,
                                        fillColor: Colors.white,

                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                              vertical: 10,
                                            ),

                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          borderSide: BorderSide.none,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(width: 5),

                              IconButton(
                                onPressed: () {},

                                icon: const Icon(
                                  Icons.notifications,
                                  color: Colors.white,
                                  size: 30,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // =================================================
                      // BOOK APPOINTMENT
                      // =================================================
                      Padding(
                        padding: const EdgeInsets.all(18),

                        child: Container(
                          width: double.infinity,

                          decoration: BoxDecoration(
                            color: const Color(0xFFD2DFF7),
                            borderRadius: BorderRadius.circular(12),
                          ),

                          child: Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    left: 18,
                                    top: 12,
                                    bottom: 12,
                                  ),

                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,

                                    children: [
                                      const Text(
                                        "Book Appointment",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                        ),
                                      ),

                                      const SizedBox(height: 4),

                                      const Text(
                                        "Consult with expert doctors",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 12,
                                        ),
                                      ),

                                      const SizedBox(height: 15),

                                      ElevatedButton(
                                        onPressed: () {},

                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.blueAccent,
                                          foregroundColor: Colors.white,

                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 15,
                                            vertical: 8,
                                          ),

                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                        ),

                                        child: const Text(
                                          "Book Now!",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              Image.asset(
                                'assets/images/Doctor_pic.png',

                                height: 125,
                                width: 100,

                                fit: BoxFit.contain,

                                errorBuilder: (context, error, stackTrace) {
                                  return const SizedBox(
                                    height: 125,
                                    width: 90,

                                    child: Icon(
                                      Icons.medical_services,
                                      color: Colors.blueAccent,
                                      size: 50,
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),

                      // =================================================
                      // SPECIALITIES TITLE
                      // =================================================
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),

                        child: Row(
                          children: [
                            const Text(
                              "Specialities",
                              style: TextStyle(
                                fontSize: 21,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const Spacer(),

                            TextButton(
                              onPressed: () {},

                              child: const Text(
                                "See All",
                                style: TextStyle(
                                  color: Colors.blueAccent,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // =================================================
                      // SPECIALITIES
                      // =================================================
                      SizedBox(
                        height: 110,

                        child: ListView(
                          scrollDirection: Axis.horizontal,

                          padding: const EdgeInsets.symmetric(horizontal: 18),

                          children: [
                            _specialityCard(
                              icon: Icons.favorite_border,
                              title: "Cardiologist",
                            ),

                            _specialityCard(
                              icon: Icons.face_retouching_natural,
                              title: "Dermatologist",
                            ),

                            _specialityCard(
                              icon: Icons.psychology,
                              title: "Neurologist",
                            ),

                            _specialityCard(
                              icon: Icons.remove_red_eye,
                              title: "Eye Specialist",
                            ),
                          ],
                        ),
                      ),

                      // =================================================
                      // TOP DOCTORS
                      // =================================================
                      const Padding(
                        padding: EdgeInsets.all(15),

                        child: Align(
                          alignment: Alignment.centerLeft,

                          child: Text(
                            "Top Doctors",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 21,
                            ),
                          ),
                        ),
                      ),

                      // =================================================
                      // DOCTOR 1
                      // =================================================
                      _doctorCard(
                        image: 'assets/images/Doctor1.png',
                        name: "Dr. Ayesha Khan",
                        specialization: "Cardiologist",
                        rating: "4.8",
                        experience: "5 Years Exp.",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Doctor_profile1(),
                            ),
                          );
                        },
                      ),

                      // =================================================
                      // DOCTOR 2
                      // =================================================
                      _doctorCard(
                        image: 'assets/images/Doctor2.png',
                        name: "Dr. Ahmer Malik",
                        specialization: "Opthalmologist",
                        rating: "3.8",
                        experience: "8 Years Exp.",
                      ),

                      // =================================================
                      // DOCTOR 3
                      // =================================================
                      _doctorCard(
                        image: 'assets/images/Doctor3.png',
                        name: "Dr. Sara Khan",
                        specialization: "Dermatologist",
                        rating: "4.6",
                        experience: "4 Years Exp.",
                      ),

                      // =================================================
                      // DOCTOR 4
                      // =================================================
                      _doctorCard(
                        image: 'assets/images/Doctor4.png',
                        name: "Dr. Aliyar Pasha",
                        specialization: "Neurologist",
                        rating: "4.2",
                        experience: "2 Years Exp.",
                      ),

                      const SizedBox(height: 15),
                    ],
                  ),
                ),
              ),

              // =====================================================
              // BOTTOM NAVIGATION
              // =====================================================
              SizedBox(
                height: 65,

                child: BottomNavigationBar(
                  currentIndex: 0,

                  onTap: (index) {
                    // HOME
                    if (index == 0) {
                      return;
                    }

                    // APPOINTMENTS
                    if (index == 1) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MyAppointments(),
                        ),
                      );
                    }

                    // CHAT
                    if (index == 2) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const AiChat()),
                      );
                    }

                    // PROFILE
                    if (index == 3) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const profile(),
                        ),
                      );
                    }
                  },

                  selectedItemColor: Colors.blueAccent,
                  unselectedItemColor: Colors.grey,

                  type: BottomNavigationBarType.fixed,
                  backgroundColor: Colors.white,
                  elevation: 8,

                  items: const [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.home_outlined),
                      activeIcon: Icon(Icons.home),
                      label: "Home",
                    ),

                    BottomNavigationBarItem(
                      icon: Icon(Icons.calendar_month_outlined),
                      activeIcon: Icon(Icons.calendar_month),
                      label: "Appointments",
                    ),

                    BottomNavigationBarItem(
                      icon: Icon(Icons.chat_bubble_outline),
                      activeIcon: Icon(Icons.chat_bubble),
                      label: "Chat",
                    ),

                    BottomNavigationBarItem(
                      icon: Icon(Icons.person_2_outlined),
                      activeIcon: Icon(Icons.person_2),
                      label: "Profile",
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // SPECIALITY CARD
  // ============================================================

  Widget _specialityCard({required IconData icon, required String title}) {
    return Container(
      width: 100,

      margin: const EdgeInsets.only(right: 12),

      decoration: BoxDecoration(
        color: const Color(0xFFE3EDFF),
        borderRadius: BorderRadius.circular(15),
      ),

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [
          Icon(icon, color: Colors.blueAccent, size: 32),

          const SizedBox(height: 7),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),

            child: Text(
              title,

              textAlign: TextAlign.center,

              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // DOCTOR CARD
  // ============================================================

  Widget _doctorCard({
    required String image,
    required String name,
    required String specialization,
    required String rating,
    required String experience,
    VoidCallback? onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 12),

      child: Container(
        width: double.infinity,

        padding: const EdgeInsets.all(12),

        decoration: BoxDecoration(
          color: Colors.white,

          borderRadius: BorderRadius.circular(15),

          border: Border.all(color: Colors.grey.shade200),

          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.15),
              blurRadius: 7,
              spreadRadius: 1,
            ),
          ],
        ),

        child: Row(
          children: [
            // DOCTOR IMAGE
            Container(
              height: 70,
              width: 70,

              decoration: BoxDecoration(
                color: const Color(0xFFE3EDFF),
                borderRadius: BorderRadius.circular(12),
              ),

              child: Image.asset(
                image,

                fit: BoxFit.contain,

                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.person,
                    color: Colors.blueAccent,
                    size: 45,
                  );
                },
              ),
            ),

            const SizedBox(width: 12),

            // DOCTOR DETAILS
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(
                    name,

                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 3),

                  Text(
                    specialization,

                    style: const TextStyle(
                      color: Colors.blueAccent,
                      fontSize: 13,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 17),

                      const SizedBox(width: 3),

                      Text(
                        rating,

                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),

                      const SizedBox(width: 8),

                      Flexible(
                        child: Text(
                          experience,

                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // ARROW
            IconButton(
              onPressed: onTap,

              icon: const Icon(
                Icons.arrow_forward_ios,
                color: Colors.blueAccent,
                size: 17,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
