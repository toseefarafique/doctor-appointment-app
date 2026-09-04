import 'package:flutter/material.dart';

class AppointmentDetails extends StatelessWidget {
  final Map<String, dynamic> appointment;

  const AppointmentDetails({super.key, required this.appointment});

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

                  title: const Text(
                    "Appointment Details",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),

                // =====================================================
                // BODY
                // =====================================================
                body: SingleChildScrollView(
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
                              color: Colors.blueAccent.withValues(alpha: 0.05),
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
                              (appointment["name"] ?? "").toString(),

                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 6),

                            Text(
                              "${appointment["age"] ?? ""} • "
                              "${appointment["gender"] ?? ""}",

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
                            (appointment["date"] ?? "").toString(),
                          ),

                          const Divider(),

                          detailRow(
                            Icons.access_time,
                            "Time",
                            (appointment["time"] ?? "").toString(),
                          ),

                          const Divider(),

                          detailRow(
                            Icons.medical_services,
                            "Type",
                            (appointment["type"] ?? "").toString(),
                          ),

                          const Divider(),

                          detailRow(
                            Icons.check_circle,
                            "Status",
                            (appointment["status"] ?? "").toString(),
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
                            (appointment["name"] ?? "").toString(),
                          ),

                          const Divider(),

                          detailRow(
                            Icons.cake,
                            "Age",
                            (appointment["age"] ?? "").toString(),
                          ),

                          const Divider(),

                          detailRow(
                            Icons.person_outline,
                            "Gender",
                            (appointment["gender"] ?? "").toString(),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // =================================================
                      // REASON FOR VISIT
                      // =================================================
                      detailSection(
                        title: "Reason for Visit",

                        children: const [
                          Align(
                            alignment: Alignment.centerLeft,

                            child: Text(
                              "General medical consultation "
                              "and patient check-up.",

                              style: TextStyle(
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
                      // START CONSULTATION BUTTON
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
                      // CANCEL APPOINTMENT BUTTON
                      // =================================================
                      SizedBox(
                        width: double.infinity,
                        height: 45,

                        child: OutlinedButton(
                          onPressed: () {},

                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.blueAccent,

                            side: const BorderSide(color: Colors.blueAccent),

                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),

                          child: const Text(
                            "Cancel Appointment",

                            style: TextStyle(fontWeight: FontWeight.bold),
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

  static Widget detailRow(IconData icon, String title, String value) {
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

            child: Icon(icon, color: Colors.blueAccent, size: 20),
          ),

          const SizedBox(width: 12),

          Text(title, style: const TextStyle(fontSize: 13, color: Colors.grey)),

          const Spacer(),

          Flexible(
            child: Text(
              value,

              textAlign: TextAlign.right,

              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
