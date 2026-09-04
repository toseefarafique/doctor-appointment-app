import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'admin_widgets.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  static const Color primaryBlue = Colors.blueAccent;

  // ============================================================
  // FIRESTORE COLLECTION NAMES
  // ============================================================

  static const String patientsCollection = 'patients';
  static const String doctorsCollection = 'doctors';
  static const String appointmentsCollection = 'appointments';
  static const String specializationsCollection = 'specializations';

  // ============================================================
  // BUILD
  // ============================================================

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
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),

          child: Scaffold(
            backgroundColor: Colors.white,

            // ==================================================
            // APP BAR
            // ==================================================
            appBar: const MyAppBar(title: "Admin Dashboard", showMenu: true),

            // ==================================================
            // DRAWER
            // ==================================================
            drawer: const AdminDrawer(),

            // ==================================================
            // BODY
            // ==================================================
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(20),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ==================================================
                  // WELCOME
                  // ==================================================

                  const Text(
                    "Welcome Admin",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    "Manage your doctor appointment system",
                    style: TextStyle(color: Colors.grey.shade600),
                  ),

                  const SizedBox(height: 20),

                  // ==================================================
                  // STATISTICS
                  // ==================================================
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1.8,

                    children: [
                      // ==================================================
                      // PATIENTS COUNT
                      // ==================================================

                      StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                        stream: FirebaseFirestore.instance
                            .collection(patientsCollection)
                            .snapshots(),

                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const StatCard(
                              title: "Total Patients",
                              value: "...",
                              icon: Icons.people,
                              color: Colors.green,
                            );
                          }

                          if (snapshot.hasError) {
                            return const StatCard(
                              title: "Total Patients",
                              value: "0",
                              icon: Icons.people,
                              color: Colors.green,
                            );
                          }

                          final count = snapshot.data?.docs.length ?? 0;

                          return StatCard(
                            title: "Total Patients",
                            value: count.toString(),
                            icon: Icons.people,
                            color: Colors.green,
                          );
                        },
                      ),

                      // ==================================================
                      // DOCTORS COUNT
                      // ==================================================
                      StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                        stream: FirebaseFirestore.instance
                            .collection(doctorsCollection)
                            .snapshots(),

                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const StatCard(
                              title: "Total Doctors",
                              value: "...",
                              icon: Icons.medical_services,
                              color: Colors.orange,
                            );
                          }

                          if (snapshot.hasError) {
                            return const StatCard(
                              title: "Total Doctors",
                              value: "0",
                              icon: Icons.medical_services,
                              color: Colors.orange,
                            );
                          }

                          final count = snapshot.data?.docs.length ?? 0;

                          return StatCard(
                            title: "Total Doctors",
                            value: count.toString(),
                            icon: Icons.medical_services,
                            color: Colors.orange,
                          );
                        },
                      ),

                      // ==================================================
                      // APPOINTMENTS COUNT
                      // ==================================================
                      StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                        stream: FirebaseFirestore.instance
                            .collection(appointmentsCollection)
                            .snapshots(),

                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const StatCard(
                              title: "Appointments",
                              value: "...",
                              icon: Icons.calendar_month,
                              color: Colors.purple,
                            );
                          }

                          if (snapshot.hasError) {
                            return const StatCard(
                              title: "Appointments",
                              value: "0",
                              icon: Icons.calendar_month,
                              color: Colors.purple,
                            );
                          }

                          final count = snapshot.data?.docs.length ?? 0;

                          return StatCard(
                            title: "Appointments",
                            value: count.toString(),
                            icon: Icons.calendar_month,
                            color: Colors.purple,
                          );
                        },
                      ),

                      // ==================================================
                      // SPECIALIZATIONS COUNT
                      // ==================================================
                      StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                        stream: FirebaseFirestore.instance
                            .collection(specializationsCollection)
                            .snapshots(),

                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const StatCard(
                              title: "Specializations",
                              value: "...",
                              icon: Icons.local_hospital,
                              color: Colors.red,
                            );
                          }

                          if (snapshot.hasError) {
                            return const StatCard(
                              title: "Specializations",
                              value: "0",
                              icon: Icons.local_hospital,
                              color: Colors.red,
                            );
                          }

                          final count = snapshot.data?.docs.length ?? 0;

                          return StatCard(
                            title: "Specializations",
                            value: count.toString(),
                            icon: Icons.local_hospital,
                            color: Colors.red,
                          );
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // ==================================================
                  // RECENT APPOINTMENTS
                  // ==================================================
                  const Text(
                    "Recent Appointments",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),

                  const SizedBox(height: 10),

                  StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: FirebaseFirestore.instance
                        .collection(appointmentsCollection)
                        .snapshots(),

                    builder: (context, snapshot) {
                      // ==================================================
                      // LOADING
                      // ==================================================

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(20),
                            child: CircularProgressIndicator(
                              color: primaryBlue,
                            ),
                          ),
                        );
                      }

                      // ==================================================
                      // ERROR
                      // ==================================================

                      if (snapshot.hasError) {
                        return Center(
                          child: Text(
                            "Error loading appointments:\n${snapshot.error}",
                            textAlign: TextAlign.center,
                          ),
                        );
                      }

                      // ==================================================
                      // EMPTY
                      // ==================================================

                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(20),
                            child: Text(
                              "No appointments found.",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        );
                      }

                      final appointments = snapshot.data!.docs;

                      // ==================================================
                      // APPOINTMENT LIST
                      // ==================================================

                      return Column(
                        children: appointments.map((document) {
                          final appointment = document.data();

                          // Patient name
                          final patient =
                              appointment['patientName']?.toString() ??
                              appointment['patient']?.toString() ??
                              'Unknown Patient';

                          // Doctor name
                          final doctor =
                              appointment['doctor']?.toString() ??
                              appointment['doctorName']?.toString() ??
                              'Unknown Doctor';

                          // Appointment time
                          final time =
                              appointment['time']?.toString() ?? 'No time';

                          // Appointment status
                          final status =
                              appointment['status']?.toString() ?? 'Pending';

                          return Card(
                            color: Colors.white,
                            elevation: 1,
                            margin: const EdgeInsets.only(bottom: 10),

                            child: ListTile(
                              // ====================================
                              // PATIENT ICON
                              // ====================================

                              leading: CircleAvatar(
                                backgroundColor: Colors.green.shade50,

                                child: const Icon(
                                  Icons.people,
                                  color: Colors.blueAccent,
                                ),
                              ),

                              // ====================================
                              // PATIENT
                              // ====================================
                              title: Text(
                                patient,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),

                              // ====================================
                              // DOCTOR
                              // ====================================
                              subtitle: Text(
                                doctor,
                                style: const TextStyle(color: Colors.black87),
                              ),

                              // ====================================
                              // TIME + STATUS
                              // ====================================
                              trailing: Column(
                                mainAxisAlignment: MainAxisAlignment.center,

                                crossAxisAlignment: CrossAxisAlignment.end,

                                children: [
                                  Text(
                                    time,
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: Colors.black87,
                                    ),
                                  ),

                                  const SizedBox(height: 4),

                                  StatusBadge(status: status),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      );
                    },
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
