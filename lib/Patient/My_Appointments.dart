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

  Stream<QuerySnapshot> getAppointments() {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Stream.empty();
    }

    return FirebaseFirestore.instance
        .collection('appointments')
        .where('patientId', isEqualTo: user.uid)
        .snapshots();
  }

  String formatDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];

    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  DateTime getAppointmentDate(Map<String, dynamic> data) {
    final date = data['date'];

    if (date is Timestamp) {
      return date.toDate();
    }

    if (date is DateTime) {
      return date;
    }

    return DateTime.now();
  }

  bool isUpcoming(Map<String, dynamic> data) {
    final status = data['status']?.toString().toLowerCase() ?? '';

    return status != 'completed' &&
        status != 'cancelled' &&
        status != 'rejected';
  }

  bool isPast(Map<String, dynamic> data) {
    final status = data['status']?.toString().toLowerCase() ?? '';

    return status == 'completed' ||
        status == 'cancelled' ||
        status == 'rejected';
  }

  // ---------------------------------------------------------
  // GET DOCTOR IMAGE USING FIRESTORE DOCTOR ID
  // ---------------------------------------------------------
  String getDoctorImage(Map<String, dynamic> data) {
    final doctorId = data['doctorId']?.toString() ?? '';

    switch (doctorId) {
    // Ayesha Khan
      case 'zOJ2C6NpTgdZ982DI9MIYolqmdK2':
        return 'assets/images/Doctor1.png';

    // Ahmer Malik
      case 'OCyIqBfiA3UYeYQTz9wGrjrFBIt2':
        return 'assets/images/Doctor2.png';

    // Sara Khan
      case 'ErGXk9aKdjQbVZhMGY6gxMlm2eS2':
        return 'assets/images/Doctor3.png';

    // Aliyar Pasha
      case 'aTdxLOoY2Mes3RnwzTWMh3yiT5P2':
        return 'assets/images/Doctor4.png';

    // Default
      default:
        return 'assets/images/Doctor1.png';
    }
  }

  void openAppointmentDetails(
      BuildContext context,
      String appointmentId,
      Map<String, dynamic> data,
      ) {
    final appointmentDate = getAppointmentDate(data);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AppointmentDetails(
          appointmentId: appointmentId,
          doctor: data['doctor']?.toString() ?? 'Ayesha Khan',
          specialization:
          data['specialization']?.toString() ?? 'Cardiologist',
          date: appointmentDate,
          time: data['time']?.toString() ?? 'Not specified',
          reason: data['reason']?.toString() ?? 'Regular Checkup',
          status: data['status']?.toString() ?? 'Pending',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Center(
        child: Container(
          width: 600,
          height: 1100,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              // ---------------------------------------------------------
              // APP BAR
              // ---------------------------------------------------------
              Container(
                height: 80,
                color: Colors.blueAccent,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'My Appointments',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              // ---------------------------------------------------------
              // TABS
              // ---------------------------------------------------------
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 15,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedTab = 0;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: selectedTab == 0
                                ? Colors.blueAccent
                                : Colors.grey[200],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            'Upcoming',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: selectedTab == 0
                                  ? Colors.white
                                  : Colors.black87,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedTab = 1;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: selectedTab == 1
                                ? Colors.blueAccent
                                : Colors.grey[200],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            'Past',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: selectedTab == 1
                                  ? Colors.white
                                  : Colors.black87,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // ---------------------------------------------------------
              // APPOINTMENTS LIST
              // ---------------------------------------------------------
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: getAppointments(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Colors.blueAccent,
                        ),
                      );
                    }

                    if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          'Error: ${snapshot.error}',
                          style: const TextStyle(
                            color: Colors.red,
                          ),
                        ),
                      );
                    }

                    if (!snapshot.hasData ||
                        snapshot.data!.docs.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.calendar_today_outlined,
                              size: 70,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 15),
                            Text(
                              selectedTab == 0
                                  ? 'No upcoming appointments'
                                  : 'No past appointments',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    final appointments =
                    snapshot.data!.docs.where((doc) {
                      final data =
                      doc.data() as Map<String, dynamic>;

                      return selectedTab == 0
                          ? isUpcoming(data)
                          : isPast(data);
                    }).toList();

                    if (appointments.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.calendar_today_outlined,
                              size: 70,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 15),
                            Text(
                              selectedTab == 0
                                  ? 'No upcoming appointments'
                                  : 'No past appointments',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.all(20),
                      itemCount: appointments.length,
                      itemBuilder: (context, index) {
                        final doc = appointments[index];

                        final data =
                        doc.data() as Map<String, dynamic>;

                        return _appointmentCard(
                          context,
                          doc.id,
                          data,
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------
  // APPOINTMENT CARD
  // ---------------------------------------------------------
  Widget _appointmentCard(
      BuildContext context,
      String appointmentId,
      Map<String, dynamic> data,
      ) {
    final doctor =
        data['doctor']?.toString() ?? 'Ayesha Khan';

    final specialization =
        data['specialization']?.toString() ?? 'Cardiologist';

    final appointmentDate =
    getAppointmentDate(data);

    final time =
        data['time']?.toString() ?? 'Not specified';

    final status =
        data['status']?.toString() ?? 'Pending';

    // Get correct image from doctorId
    final doctorImage = getDoctorImage(data);

    return GestureDetector(
      onTap: () {
        openAppointmentDetails(
          context,
          appointmentId,
          data,
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.15),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
          border: Border.all(
            color: Colors.grey.shade200,
          ),
        ),
        child: Row(
          children: [
            // ---------------------------------------------------------
            // DOCTOR IMAGE
            // ---------------------------------------------------------
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Image.asset(
                doctorImage,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.person,
                    color: Colors.blueAccent,
                    size: 55,
                  );
                },
              ),
            ),

            const SizedBox(width: 15),

            // ---------------------------------------------------------
            // APPOINTMENT INFORMATION
            // ---------------------------------------------------------
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    doctor,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    specialization,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.blueAccent,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today,
                        size: 15,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        formatDate(appointmentDate),
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 5),

                  Row(
                    children: [
                      const Icon(
                        Icons.access_time,
                        size: 15,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        time,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // ---------------------------------------------------------
            // STATUS
            // ---------------------------------------------------------
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: status.toLowerCase() == 'confirmed'
                    ? Colors.green.shade50
                    : status.toLowerCase() == 'completed'
                    ? Colors.green.shade100
                    : status.toLowerCase() == 'rejected'
                    ? Colors.red.shade50
                    : Colors.orange.shade50,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                status,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: status.toLowerCase() == 'confirmed'
                      ? Colors.green
                      : status.toLowerCase() == 'completed'
                      ? Colors.green.shade700
                      : status.toLowerCase() == 'rejected'
                      ? Colors.red
                      : Colors.orange,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}