import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AppointmentDetails extends StatefulWidget {
  final Map<String, dynamic> appointment;

  const AppointmentDetails({
    super.key,
    required this.appointment,
  });

  @override
  State<AppointmentDetails> createState() => _AppointmentDetailsState();
}

class _AppointmentDetailsState extends State<AppointmentDetails> {
  Map<String, dynamic> appointment = {};

  bool loading = true;

  @override
  void initState() {
    super.initState();

    appointment = Map<String, dynamic>.from(widget.appointment);

    _loadAppointmentFromFirebase();
  }

  // ================================================================
  // LOAD APPOINTMENT FROM FIREBASE
  // ================================================================

  Future<void> _loadAppointmentFromFirebase() async {
    try {
      final appointmentId =
          widget.appointment["id"] ??
          widget.appointment["appointmentId"] ??
          widget.appointment["documentId"];

      // If document ID is available, fetch latest data from Firebase
      if (appointmentId != null &&
          appointmentId.toString().trim().isNotEmpty) {
        final doc = await FirebaseFirestore.instance
            .collection("appointments")
            .doc(appointmentId.toString())
            .get();

        if (doc.exists) {
          final firebaseData = doc.data();

          if (firebaseData != null) {
            appointment = {
              ...appointment,
              ...firebaseData,
            };
          }
        }
      }
    } catch (e) {
      debugPrint("Error loading appointment: $e");
    }

    if (mounted) {
      setState(() {
        loading = false;
      });
    }
  }

  // ================================================================
  // GET VALUE WITH MULTIPLE FIELD NAME OPTIONS
  // ================================================================

  String getValue(List<String> keys) {
    for (final key in keys) {
      final value = appointment[key];

      if (value != null &&
          value.toString().trim().isNotEmpty &&
          value.toString().toLowerCase() != "null") {
        return value.toString();
      }
    }

    return "N/A";
  }

  // ================================================================
  // PATIENT NAME
  // ================================================================

  String get patientName {
    return getValue([
      "patientName",
      "patient",
      "name",
      "userName",
      "fullName",
    ]);
  }

  // ================================================================
  // AGE
  // ================================================================

  String get patientAge {
    return getValue([
      "age",
      "patientAge",
    ]);
  }

  // ================================================================
  // GENDER
  // ================================================================

  String get patientGender {
    return getValue([
      "gender",
      "patientGender",
      "sex",
    ]);
  }

  // ================================================================
  // DATE
  // ================================================================

  String get appointmentDate {
    final possibleKeys = [
      "date",
      "appointmentDate",
      "bookingDate",
    ];

    for (final key in possibleKeys) {
      final value = appointment[key];

      if (value == null) {
        continue;
      }

      // Firestore Timestamp
      if (value is Timestamp) {
        return _formatDate(value.toDate());
      }

      // DateTime
      if (value is DateTime) {
        return _formatDate(value);
      }

      final text = value.toString().trim();

      if (text.isNotEmpty && text.toLowerCase() != "null") {
        return text;
      }
    }

    return "N/A";
  }

  // ================================================================
  // FORMAT DATE
  // ================================================================

  String _formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}/"
        "${date.month.toString().padLeft(2, '0')}/"
        "${date.year}";
  }

  // ================================================================
  // TIME
  // ================================================================

  String get appointmentTime {
    return getValue([
      "time",
      "appointmentTime",
    ]);
  }

  // ================================================================
  // TYPE
  // ================================================================

  String get appointmentType {
    return getValue([
      "type",
      "appointmentType",
    ]);
  }

  // ================================================================
  // STATUS
  // ================================================================

  String get appointmentStatus {
    return getValue([
      "status",
    ]);
  }

  // ================================================================
  // REASON
  // ================================================================

  String get reasonForVisit {
    return getValue([
      "reason",
      "reasonForVisit",
      "symptoms",
      "description",
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFCFD),

      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),

            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),

              child: Scaffold(
                backgroundColor: const Color(0xFFF5F3F3),

                // =====================================================
                // APP BAR
                // =====================================================

                appBar: AppBar(
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                  elevation: 0,

                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),

                  title: const Text(
                    "Appointment Details",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                // =====================================================
                // BODY
                // =====================================================

                body: loading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: Colors.blueAccent,
                        ),
                      )
                    : SingleChildScrollView(
                        padding: const EdgeInsets.all(16),

                        child: Column(
                          children: [
                            // =================================================
                            // PATIENT PROFILE CARD
                            // =================================================

                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(18),

                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),

                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.blueAccent.withValues(
                                      alpha: 0.05,
                                    ),
                                    blurRadius: 6,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),

                              child: Column(
                                children: [
                                  const CircleAvatar(
                                    radius: 40,
                                    backgroundColor: Color(0xFFE3F2FD),

                                    child: Icon(
                                      Icons.person,
                                      size: 48,
                                      color: Colors.blueAccent,
                                    ),
                                  ),

                                  const SizedBox(height: 10),

                                  Text(
                                    patientName,

                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  const SizedBox(height: 6),

                                  Text(
                                    "$patientAge • $patientGender",

                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 16),

                            // =================================================
                            // APPOINTMENT INFORMATION
                            // =================================================

                            detailSection(
                              title: "Appointment Information",

                              children: [
                                detailRow(
                                  Icons.calendar_today,
                                  "Date",
                                  appointmentDate,
                                ),

                                const Divider(),

                                detailRow(
                                  Icons.access_time,
                                  "Time",
                                  appointmentTime,
                                ),

                                const Divider(),

                                detailRow(
                                  Icons.medical_services,
                                  "Type",
                                  appointmentType,
                                ),

                                const Divider(),

                                detailRow(
                                  Icons.check_circle,
                                  "Status",
                                  appointmentStatus,
                                ),
                              ],
                            ),

                            const SizedBox(height: 20),

                            // =================================================
                            // PATIENT INFORMATION
                            // =================================================

                            detailSection(
                              title: "Patient Information",

                              children: [
                                detailRow(
                                  Icons.person,
                                  "Name",
                                  patientName,
                                ),

                                const Divider(),

                                detailRow(
                                  Icons.cake,
                                  "Age",
                                  patientAge,
                                ),

                                const Divider(),

                                detailRow(
                                  Icons.person_outline,
                                  "Gender",
                                  patientGender,
                                ),
                              ],
                            ),

                            const SizedBox(height: 20),

                            // =================================================
                            // REASON FOR VISIT
                            // =================================================

                            detailSection(
                              title: "Reason for Visit",

                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,

                                  child: Text(
                                    reasonForVisit == "N/A"
                                        ? "No reason provided."
                                        : reasonForVisit,

                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                      height: 1.5,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 20),

                            // =================================================
                            // START CONSULTATION
                            // =================================================

                            SizedBox(
                              width: double.infinity,
                              height: 45,

                              child: ElevatedButton(
                                onPressed: () {},

                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blueAccent,
                                  foregroundColor: Colors.white,

                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),

                                child: const Text(
                                  "Start Consultation",

                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 10),

                            // =================================================
                            // CANCEL APPOINTMENT
                            // =================================================

                            SizedBox(
                              width: double.infinity,
                              height: 45,

                              child: OutlinedButton(
                                onPressed: () {},

                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.blueAccent,

                                  side: const BorderSide(
                                    color: Colors.blueAccent,
                                  ),

                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),

                                child: const Text(
                                  "Cancel Appointment",

                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ================================================================
  // DETAIL SECTION
  // ================================================================

  static Widget detailSection({
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(15),

        boxShadow: [
          BoxShadow(
            color: Colors.blueAccent.withValues(alpha: 0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Text(
            title,

            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Colors.blueAccent,
            ),
          ),

          const SizedBox(height: 12),

          ...children,
        ],
      ),
    );
  }

  // ================================================================
  // DETAIL ROW
  // ================================================================

  static Widget detailRow(
    IconData icon,
    String title,
    String value,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),

      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,

            decoration: BoxDecoration(
              color: const Color(0xFFE3F2FD),

              borderRadius: BorderRadius.circular(10),
            ),

            child: Icon(
              icon,
              color: Colors.blueAccent,
              size: 20,
            ),
          ),

          const SizedBox(width: 12),

          Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.grey,
            ),
          ),

          const Spacer(),

          Flexible(
            child: Text(
              value,

              textAlign: TextAlign.right,

              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}