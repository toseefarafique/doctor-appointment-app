import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'appointment_details.dart';

class DoctorAppointments extends StatefulWidget {
  /// Optional doctor name.
  ///
  /// If provided, only appointments for this doctor are displayed.
  /// If not provided, the app tries to find the logged-in doctor's
  /// name from the "doctors" collection using the logged-in email.
  final String? doctorName;

  const DoctorAppointments({super.key, this.doctorName});

  @override
  State<DoctorAppointments> createState() => _DoctorAppointmentsState();
}

class _DoctorAppointmentsState extends State<DoctorAppointments> {
  int selectedTab = 0;

  static const Color primaryBlue = Color(0xFF1565C0);

  String? loggedDoctorName;
  bool loadingDoctor = true;

  @override
  void initState() {
    super.initState();
    _loadDoctor();
  }

  // ------------------------------------------------------------
  // LOAD LOGGED-IN DOCTOR
  // ------------------------------------------------------------

  Future<void> _loadDoctor() async {
    // If doctor name was directly provided, use it.
    if (widget.doctorName != null && widget.doctorName!.trim().isNotEmpty) {
      setState(() {
        loggedDoctorName = widget.doctorName!.trim();
        loadingDoctor = false;
      });
      return;
    }

    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null || user.email == null) {
        setState(() {
          loadingDoctor = false;
        });
        return;
      }

      final result = await FirebaseFirestore.instance
          .collection('doctors')
          .where('email', isEqualTo: user.email)
          .limit(1)
          .get();

      if (result.docs.isNotEmpty) {
        final data = result.docs.first.data();

        setState(() {
          loggedDoctorName = data['name']?.toString();
          loadingDoctor = false;
        });
      } else {
        setState(() {
          loadingDoctor = false;
        });
      }
    } catch (e) {
      debugPrint('Error loading doctor: $e');

      setState(() {
        loadingDoctor = false;
      });
    }
  }

  // ------------------------------------------------------------
  // FIRESTORE APPOINTMENT STREAM
  // ------------------------------------------------------------

  Stream<QuerySnapshot<Map<String, dynamic>>> _appointmentStream() {
    return FirebaseFirestore.instance.collection('appointments').snapshots();
  }

  // ------------------------------------------------------------
  // GET STRING VALUE
  // ------------------------------------------------------------

  String _getString(
    Map<String, dynamic> data,
    List<String> keys, {
    String fallback = '',
  }) {
    for (final key in keys) {
      final value = data[key];

      if (value != null && value.toString().trim().isNotEmpty) {
        return value.toString();
      }
    }

    return fallback;
  }

  // ------------------------------------------------------------
  // GET PATIENT NAME
  // ------------------------------------------------------------

  String _getPatientName(Map<String, dynamic> data) {
    return _getString(data, [
      'patientName',
      'patient',
      'name',
    ], fallback: 'Unknown Patient');
  }

  // ------------------------------------------------------------
  // GET DOCTOR NAME
  // ------------------------------------------------------------

  String _getDoctorName(Map<String, dynamic> data) {
    return _getString(data, [
      'doctor',
      'doctorName',
    ], fallback: 'Unknown Doctor');
  }

  // ------------------------------------------------------------
  // GET STATUS
  // ------------------------------------------------------------

  String _getStatus(Map<String, dynamic> data) {
    return _getString(data, ['status'], fallback: 'Pending');
  }

  // ------------------------------------------------------------
  // CHECK WHETHER APPOINTMENT BELONGS TO DOCTOR
  // ------------------------------------------------------------

  bool _belongsToDoctor(Map<String, dynamic> data) {
    // If no doctor name is available, show the appointment.
    //
    // This also keeps the screen working if your current doctor
    // login does not use Firebase Authentication.
    if (loggedDoctorName == null || loggedDoctorName!.trim().isEmpty) {
      return true;
    }

    final appointmentDoctor = _getDoctorName(data).trim();
    final currentDoctor = loggedDoctorName!.trim();

    return appointmentDoctor.toLowerCase() == currentDoctor.toLowerCase();
  }

  // ------------------------------------------------------------
  // DATE FORMAT
  // ------------------------------------------------------------

  String _formatDate(dynamic value) {
    if (value == null) {
      return 'No date';
    }

    DateTime? date;

    if (value is Timestamp) {
      date = value.toDate();
    } else if (value is DateTime) {
      date = value;
    }

    if (date != null) {
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
        'Dec',
      ];

      return '${date.day} ${months[date.month - 1]} ${date.year}';
    }

    return value.toString();
  }

  // ------------------------------------------------------------
  // TIME FORMAT
  // ------------------------------------------------------------

  String _formatTime(dynamic value) {
    if (value == null) {
      return 'No time';
    }

    if (value is Timestamp) {
      final date = value.toDate();

      final hour = date.hour > 12
          ? date.hour - 12
          : date.hour == 0
          ? 12
          : date.hour;

      final minute = date.minute.toString().padLeft(2, '0');

      final period = date.hour >= 12 ? 'PM' : 'AM';

      return '$hour:$minute $period';
    }

    if (value is DateTime) {
      final hour = value.hour > 12
          ? value.hour - 12
          : value.hour == 0
          ? 12
          : value.hour;

      final minute = value.minute.toString().padLeft(2, '0');

      final period = value.hour >= 12 ? 'PM' : 'AM';

      return '$hour:$minute $period';
    }

    return value.toString();
  }

  // ------------------------------------------------------------
  // CONVERT FIRESTORE DOCUMENT TO UI MAP
  // ------------------------------------------------------------

  Map<String, dynamic> _convertAppointment(
    DocumentSnapshot<Map<String, dynamic>> document,
  ) {
    final data = document.data() ?? {};

    final patientName = _getPatientName(data);
    final doctorName = _getDoctorName(data);
    final status = _getStatus(data);

    final dateValue =
        data['date'] ?? data['appointmentDate'] ?? data['bookingDate'];

    final timeValue = data['time'] ?? data['appointmentTime'];

    final appointmentType = _getString(data, [
      'type',
      'appointmentType',
    ], fallback: 'Consultation');

    return {
      // Firestore document ID
      'id': document.id,

      // Original Firestore data
      ...data,

      // UI-compatible fields
      'name': patientName,
      'patientName': patientName,
      'doctor': doctorName,
      'age': _getString(data, ['age'], fallback: 'N/A'),
      'gender': _getString(data, ['gender'], fallback: 'N/A'),
      'date': _formatDate(dateValue),
      'time': _formatTime(timeValue),
      'type': appointmentType,
      'status': status,
    };
  }

  // ------------------------------------------------------------
  // FILTER APPOINTMENTS
  // ------------------------------------------------------------

  List<Map<String, dynamic>> _filterAppointments(
    List<Map<String, dynamic>> appointments,
  ) {
    final doctorAppointments = appointments.where(_belongsToDoctor).toList();

    switch (selectedTab) {
      case 0:
        // ALL
        return doctorAppointments;

      case 1:
        // UPCOMING
        //
        // Both Pending and Confirmed appointments are upcoming.
        return doctorAppointments.where((appointment) {
          final status = appointment['status'].toString().toLowerCase();

          return status == 'pending' ||
              status == 'confirmed' ||
              status == 'upcoming';
        }).toList();

      case 2:
        // COMPLETED
        return doctorAppointments.where((appointment) {
          return appointment['status'].toString().toLowerCase() == 'completed';
        }).toList();

      case 3:
        // CANCELLED
        return doctorAppointments.where((appointment) {
          return appointment['status'].toString().toLowerCase() == 'cancelled';
        }).toList();

      default:
        return doctorAppointments;
    }
  }

  // ------------------------------------------------------------
  // MAIN BUILD
  // ------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: primaryBlue,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Appointments',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),

      body: Column(
        children: [
          _buildTabs(),

          const SizedBox(height: 8),

          Expanded(
            child: loadingDoctor
                ? const Center(child: CircularProgressIndicator())
                : StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: _appointmentStream(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting &&
                          !snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (snapshot.hasError) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Text(
                              'Error loading appointments:\n${snapshot.error}',
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.red),
                            ),
                          ),
                        );
                      }

                      final documents = snapshot.data?.docs ?? [];

                      final appointments = documents
                          .map(_convertAppointment)
                          .toList();

                      final filtered = _filterAppointments(appointments);

                      if (filtered.isEmpty) {
                        return _buildEmptyState();
                      }

                      return ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
                        itemCount: filtered.length,
                        itemBuilder: (context, index) {
                          return appointmentCard(filtered[index]);
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // TABS
  // ------------------------------------------------------------

  Widget _buildTabs() {
    final tabs = ['All', 'Upcoming', 'Completed', 'Cancelled'];

    return Container(
      height: 55,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: List.generate(tabs.length, (index) {
          final selected = selectedTab == index;

          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  selectedTab = index;
                });
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  color: selected ? primaryBlue : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: Text(
                  tabs[index],
                  style: TextStyle(
                    color: selected ? Colors.white : Colors.grey.shade700,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  // ------------------------------------------------------------
  // EMPTY STATE
  // ------------------------------------------------------------

  Widget _buildEmptyState() {
    String message;

    switch (selectedTab) {
      case 1:
        message = 'No upcoming appointments';
        break;

      case 2:
        message = 'No completed appointments';
        break;

      case 3:
        message = 'No cancelled appointments';
        break;

      default:
        message = 'No appointments found';
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.calendar_month_outlined,
            size: 70,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 15),
          Text(
            message,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // APPOINTMENT CARD
  // ------------------------------------------------------------

  Widget appointmentCard(Map<String, dynamic> appointment) {
    final name = appointment['name'] ?? 'Unknown Patient';

    final age = appointment['age'] ?? 'N/A';

    final gender = appointment['gender'] ?? 'N/A';

    final date = appointment['date'] ?? 'No date';

    final time = appointment['time'] ?? 'No time';

    final type = appointment['type'] ?? 'Consultation';

    final status = appointment['status'] ?? 'Pending';

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --------------------------------------------------
          // PATIENT HEADER
          // --------------------------------------------------

          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: primaryBlue.withOpacity(0.10),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.person, color: primaryBlue, size: 28),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name.toString(),
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      '$age • $gender',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),

              _statusBadge(status.toString()),
            ],
          ),

          const SizedBox(height: 18),

          const Divider(),

          const SizedBox(height: 10),

          // --------------------------------------------------
          // DATE
          // --------------------------------------------------
          Row(
            children: [
              Icon(Icons.calendar_today, size: 18, color: primaryBlue),

              const SizedBox(width: 10),

              Expanded(
                child: Text(
                  date.toString(),
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // --------------------------------------------------
          // TIME
          // --------------------------------------------------
          Row(
            children: [
              Icon(Icons.access_time, size: 18, color: primaryBlue),

              const SizedBox(width: 10),

              Expanded(
                child: Text(
                  time.toString(),
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // --------------------------------------------------
          // TYPE
          // --------------------------------------------------
          Row(
            children: [
              Icon(
                Icons.medical_services_outlined,
                size: 18,
                color: primaryBlue,
              ),

              const SizedBox(width: 10),

              Expanded(
                child: Text(
                  type.toString(),
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),

          const SizedBox(height: 15),

          // --------------------------------------------------
          // VIEW DETAILS
          // --------------------------------------------------
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        AppointmentDetails(appointment: appointment),
                  ),
                );
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: primaryBlue,
                side: const BorderSide(color: primaryBlue),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: const Text(
                'View Details',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // STATUS BADGE
  // ------------------------------------------------------------

  Widget _statusBadge(String status) {
    Color backgroundColor;
    Color textColor;

    switch (status.toLowerCase()) {
      case 'confirmed':
        backgroundColor = Colors.green.shade100;
        textColor = Colors.green.shade700;
        break;

      case 'pending':
        backgroundColor = Colors.orange.shade100;
        textColor = Colors.orange.shade700;
        break;

      case 'upcoming':
        backgroundColor = Colors.blue.shade100;
        textColor = Colors.blue.shade700;
        break;

      case 'completed':
        backgroundColor = Colors.grey.shade200;
        textColor = Colors.grey.shade700;
        break;

      case 'cancelled':
        backgroundColor = Colors.red.shade100;
        textColor = Colors.red.shade700;
        break;

      default:
        backgroundColor = Colors.grey.shade200;
        textColor = Colors.grey.shade700;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: textColor,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
