import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'Appointment_Details.dart';

class MyAppointments extends StatefulWidget {
  const MyAppointments({super.key});

  @override
  State<MyAppointments> createState() => _MyAppointmentsState();
}

class _MyAppointmentsState extends State<MyAppointments> {
  int selectedTab = 0;

  // ============================================================
  // GET CURRENT PATIENT APPOINTMENTS
  // ============================================================

  Stream<QuerySnapshot<Map<String, dynamic>>> getAppointments() {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Stream.empty();
    }

    return FirebaseFirestore.instance
        .collection('appointments')
        .where(
      'patientId',
      isEqualTo: user.uid,
    )
        .snapshots();
  }

  // ============================================================
  // FORMAT DATE
  // ============================================================

  String formatDate(DateTime date) {
    const months = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December",
    ];

    return "${date.day} ${months[date.month - 1]} ${date.year}";
  }

  // ============================================================
  // GET FIRESTORE DATE
  // ============================================================

  DateTime getAppointmentDate(
      Map<String, dynamic> data,
      ) {
    final date = data['date'];

    if (date is Timestamp) {
      return date.toDate();
    }

    if (date is DateTime) {
      return date;
    }

    return DateTime.now();
  }

  // ============================================================
  // UPCOMING
  // ============================================================

  bool isUpcoming(
      Map<String, dynamic> data,
      ) {
    final status =
    (data['status'] ?? 'Pending')
        .toString()
        .toLowerCase();

    return status != 'completed' &&
        status != 'cancelled' &&
        status != 'rejected';
  }

  // ============================================================
  // PAST
  // ============================================================

  bool isPast(
      Map<String, dynamic> data,
      ) {
    final status =
    (data['status'] ?? 'Pending')
        .toString()
        .toLowerCase();

    return status == 'completed' ||
        status == 'cancelled' ||
        status == 'rejected';
  }

  // ============================================================
  // OPEN DETAILS
  // ============================================================

  void openAppointmentDetails(
      String appointmentId,
      Map<String, dynamic> data,
      ) {
    final appointmentDate =
    getAppointmentDate(data);

    Navigator.push(
      context,

      MaterialPageRoute(
        builder: (context) =>
            AppointmentDetails(
              appointmentId: appointmentId,

              doctor:
              data['doctor']?.toString() ??
                  'Dr. Ayesha Khan',

              specialization:
              data['specialization']
                  ?.toString() ??
                  'Cardiologist',

              date: appointmentDate,

              time:
              data['time']?.toString() ??
                  'Not specified',

              reason:
              data['reason']?.toString() ??
                  'Regular Checkup',

              status:
              data['status']?.toString() ??
                  'Pending',
            ),
      ),
    );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,

      body: Center(
        child: Container(
          width: 600,
          height: 1100,

          clipBehavior: Clip.hardEdge,

          decoration: BoxDecoration(
            color: Colors.white,

            borderRadius:
            BorderRadius.circular(25),

            boxShadow: [
              BoxShadow(
                color: Colors.black
                    .withValues(alpha: 0.15),

                blurRadius: 20,
                spreadRadius: 2,
              ),
            ],
          ),

          child: Column(
            children: [
              // ==================================================
              // APP BAR
              // ==================================================

              Container(
                height: 70,

                decoration:
                const BoxDecoration(
                  color: Colors.blueAccent,
                ),

                child: SafeArea(
                  bottom: false,

                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(
                            context,
                          );
                        },

                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),

                      const SizedBox(width: 5),

                      const Text(
                        "My Appointments",

                        style: TextStyle(
                          color: Colors.white,
                          fontWeight:
                          FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ==================================================
              // CONTENT
              // ==================================================

              Expanded(
                child:
                SingleChildScrollView(
                  padding:
                  const EdgeInsets.all(10),

                  child: Column(
                    children: [
                      const SizedBox(height: 5),

                      // ==================================================
                      // TABS
                      // ==================================================

                      Row(
                        children: [
                          Expanded(
                            child:
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedTab =
                                  0;
                                });
                              },

                              child:
                              Container(
                                height: 45,

                                decoration:
                                BoxDecoration(
                                  color:
                                  selectedTab ==
                                      0
                                      ? Colors
                                      .blueAccent
                                      : Colors
                                      .white,

                                  borderRadius:
                                  BorderRadius
                                      .circular(
                                    10,
                                  ),

                                  border:
                                  Border.all(
                                    color: Colors
                                        .blueAccent,
                                  ),
                                ),

                                child: Center(
                                  child: Text(
                                    "Upcoming",

                                    style:
                                    TextStyle(
                                      color:
                                      selectedTab ==
                                          0
                                          ? Colors
                                          .white
                                          : Colors
                                          .blueAccent,

                                      fontWeight:
                                      FontWeight
                                          .bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(
                            width: 15,
                          ),

                          Expanded(
                            child:
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedTab =
                                  1;
                                });
                              },

                              child:
                              Container(
                                height: 45,

                                decoration:
                                BoxDecoration(
                                  color:
                                  selectedTab ==
                                      1
                                      ? Colors
                                      .blueAccent
                                      : Colors
                                      .white,

                                  borderRadius:
                                  BorderRadius
                                      .circular(
                                    10,
                                  ),

                                  border:
                                  Border.all(
                                    color: Colors
                                        .blueAccent,
                                  ),
                                ),

                                child: Center(
                                  child: Text(
                                    "Past",

                                    style:
                                    TextStyle(
                                      color:
                                      selectedTab ==
                                          1
                                          ? Colors
                                          .white
                                          : Colors
                                          .blueAccent,

                                      fontWeight:
                                      FontWeight
                                          .bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(
                        height: 20,
                      ),

                      // ==================================================
                      // FIRESTORE
                      // ==================================================

                      StreamBuilder<
                          QuerySnapshot<
                              Map<String,
                                  dynamic>>>(
                        stream:
                        getAppointments(),

                        builder:
                            (context, snapshot) {
                          if (snapshot
                              .connectionState ==
                              ConnectionState
                                  .waiting) {
                            return const Padding(
                              padding:
                              EdgeInsets.all(
                                40,
                              ),

                              child:
                              CircularProgressIndicator(
                                color: Colors
                                    .blueAccent,
                              ),
                            );
                          }

                          if (snapshot.hasError) {
                            return Padding(
                              padding:
                              const EdgeInsets
                                  .all(
                                30,
                              ),

                              child: Text(
                                "Error loading appointments:\n${snapshot.error}",

                                textAlign:
                                TextAlign.center,

                                style:
                                const TextStyle(
                                  color: Colors.red,
                                ),
                              ),
                            );
                          }

                          if (!snapshot.hasData ||
                              snapshot
                                  .data!
                                  .docs
                                  .isEmpty) {
                            return _emptyAppointments();
                          }

                          final documents =
                              snapshot.data!.docs;

                          final filteredDocuments =
                          documents.where(
                                (doc) {
                              final data =
                              doc.data();

                              if (selectedTab ==
                                  0) {
                                return isUpcoming(
                                  data,
                                );
                              } else {
                                return isPast(
                                  data,
                                );
                              }
                            },
                          ).toList();

                          if (filteredDocuments
                              .isEmpty) {
                            return _emptyAppointments();
                          }

                          return Column(
                            children:
                            filteredDocuments
                                .map(
                                  (doc) {
                                return _appointmentCard(
                                  doc.id,
                                  doc.data(),
                                );
                              },
                            ).toList(),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // APPOINTMENT CARD
  // ============================================================

  Widget _appointmentCard(
      String appointmentId,
      Map<String, dynamic> data,
      ) {
    final date =
    getAppointmentDate(data);

    final doctor =
        data['doctor']?.toString() ??
            'Dr. Ayesha Khan';

    final specialization =
        data['specialization']?.toString() ??
            'Cardiologist';

    final time =
        data['time']?.toString() ??
            'Not specified';

    final status =
        data['status']?.toString() ??
            'Pending';

    return Container(
      width: double.infinity,

      margin:
      const EdgeInsets.only(bottom: 15),

      padding:
      const EdgeInsets.all(15),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
        BorderRadius.circular(15),

        border: Border.all(
          color: Colors.grey.shade300,
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.black
                .withValues(alpha: 0.05),

            blurRadius: 5,
          ),
        ],
      ),

      child: Column(
        children: [
          Row(
            crossAxisAlignment:
            CrossAxisAlignment.start,

            children: [
              // ==================================================
              // DOCTOR IMAGE
              // ==================================================

              Container(
                height: 90,
                width: 90,

                decoration:
                BoxDecoration(
                  color:
                  const Color(0xFFE3EDFF),

                  borderRadius:
                  BorderRadius.circular(
                    12,
                  ),
                ),

                child: ClipRRect(
                  borderRadius:
                  BorderRadius.circular(
                    12,
                  ),

                  child: Image.asset(
                    'assets/images/Doctor1.png',

                    fit: BoxFit.contain,

                    errorBuilder:
                        (context, error,
                        stackTrace) {
                      return const Icon(
                        Icons.person,
                        color:
                        Colors.blueAccent,
                        size: 55,
                      );
                    },
                  ),
                ),
              ),

              const SizedBox(width: 15),

              // ==================================================
              // INFORMATION
              // ==================================================

              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,

                  children: [
                    Text(
                      doctor,

                      style:
                      const TextStyle(
                        color: Colors.black,
                        fontWeight:
                        FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      specialization,

                      style:
                      const TextStyle(
                        color: Colors.black87,
                        fontWeight:
                        FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),

                    const SizedBox(height: 5),

                    Text(
                      formatDate(date),

                      style:
                      const TextStyle(
                        color: Colors.black87,
                        fontWeight:
                        FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),

                    const SizedBox(height: 3),

                    Text(
                      time,

                      style:
                      const TextStyle(
                        color: Colors.black87,
                        fontWeight:
                        FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 15),

          // ==================================================
          // BUTTON
          // ==================================================

          SizedBox(
            width: double.infinity,
            height: 42,

            child: ElevatedButton(
              onPressed: () {
                openAppointmentDetails(
                  appointmentId,
                  data,
                );
              },

              style:
              ElevatedButton.styleFrom(
                backgroundColor:
                selectedTab == 0
                    ? Colors.blueAccent
                    .shade100
                    : Colors.grey.shade200,

                foregroundColor:
                Colors.blueAccent,

                elevation: 0,

                shape:
                RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(
                    10,
                  ),
                ),
              ),

              child: Text(
                status,

                style: TextStyle(
                  color: selectedTab == 0
                      ? Colors.blueAccent
                      : Colors.grey.shade700,

                  fontWeight:
                  FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // EMPTY
  // ============================================================

  Widget _emptyAppointments() {
    return Padding(
      padding:
      const EdgeInsets.only(
        top: 60,
        left: 20,
        right: 20,
      ),

      child: Column(
        children: [
          Icon(
            Icons.calendar_month_outlined,

            size: 80,

            color: Colors.grey.shade400,
          ),

          const SizedBox(height: 15),

          Text(
            selectedTab == 0
                ? "No upcoming appointments"
                : "No past appointments",

            style: const TextStyle(
              fontSize: 18,
              fontWeight:
              FontWeight.bold,
              color: Colors.grey,
            ),

            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}