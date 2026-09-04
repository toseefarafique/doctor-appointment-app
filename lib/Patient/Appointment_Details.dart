import 'package:flutter/material.dart';

class AppointmentDetails extends StatelessWidget {
  const AppointmentDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,

      body: SafeArea(
        child: Center(
          child: Container(
            width: 600,
            constraints: const BoxConstraints(minHeight: 700, maxHeight: 900),
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
                // APP BAR
                // =====================================================

                Container(
                  height: 70,
                  width: double.infinity,
                  color: Colors.blueAccent,

                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),

                      const SizedBox(width: 8),

                      const Text(
                        "Appointment Details",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                    ],
                  ),
                ),

                // =====================================================
                // BODY
                // =====================================================
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(25),

                    child: Column(
                      children: [
                        // =================================================
                        // APPOINTMENT ICON
                        // =================================================

                        const CircleAvatar(
                          radius: 55,
                          backgroundColor: Colors.blueAccent,

                          child: Icon(
                            Icons.calendar_month,
                            size: 70,
                            color: Colors.white,
                          ),
                        ),

                        const SizedBox(height: 15),

                        // =================================================
                        // STATUS
                        // =================================================
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 8,
                          ),

                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 229, 255, 200),
                            borderRadius: BorderRadius.circular(20),
                          ),

                          child: const Text(
                            "Confirmed",
                            style: TextStyle(
                              color: Color.fromARGB(255, 100, 190, 30),
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),

                        const SizedBox(height: 12),

                        // =================================================
                        // DOCTOR NAME
                        // =================================================
                        const Text(
                          "Dr. Ayesha Khan",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        ),

                        const SizedBox(height: 5),

                        const Text(
                          "Cardiologist",
                          style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),

                        const SizedBox(height: 25),

                        // =================================================
                        // APPOINTMENT INFORMATION CARD
                        // =================================================
                        Container(
                          width: double.infinity,

                          padding: const EdgeInsets.all(20),

                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 245, 249, 255),

                            borderRadius: BorderRadius.circular(15),

                            border: Border.all(
                              color: Colors.blueAccent.withValues(alpha: 0.15),
                            ),
                          ),

                          child: Column(
                            children: [
                              // DATE
                              _appointmentInfo(
                                icon: Icons.calendar_month_outlined,
                                title: "Date",
                                value: "25 May 2026",
                              ),

                              const Divider(height: 25),

                              // TIME
                              _appointmentInfo(
                                icon: Icons.access_time,
                                title: "Time",
                                value: "10:00 AM",
                              ),

                              const Divider(height: 25),

                              // FEE
                              _appointmentInfo(
                                icon: Icons.medical_services_outlined,
                                title: "Consultation Fee",
                                value: "Rs. 1500",
                              ),

                              const Divider(height: 25),

                              // LOCATION
                              _appointmentInfo(
                                icon: Icons.location_on_outlined,
                                title: "Location",
                                value: "City Hospital, Room 305",
                              ),

                              const Divider(height: 25),

                              // REASON
                              _appointmentInfo(
                                icon: Icons.description_outlined,
                                title: "Reason",
                                value: "Regular Checkup",
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 35),

                        // =================================================
                        // CANCEL APPOINTMENT
                        // =================================================
                        SizedBox(
                          width: double.infinity,
                          height: 55,

                          child: OutlinedButton(
                            onPressed: () {
                              showDialog(
                                context: context,

                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text(
                                      "Cancel Appointment",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),

                                    content: const Text(
                                      "Are you sure you want to cancel this appointment?",
                                    ),

                                    actions: [
                                      // NO
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },

                                        child: const Text(
                                          "No",
                                          style: TextStyle(
                                            color: Colors.blueAccent,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),

                                      // YES
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);

                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                "Appointment Cancelled",
                                              ),
                                            ),
                                          );
                                        },

                                        child: const Text(
                                          "Yes",
                                          style: TextStyle(
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },

                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(
                                color: Colors.red,
                                width: 2,
                              ),

                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),

                            child: const Text(
                              "Cancel Appointment",
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 15),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ===============================================================
  // APPOINTMENT INFORMATION WIDGET
  // ===============================================================

  static Widget _appointmentInfo({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        // ICON
        Container(
          height: 45,
          width: 45,

          decoration: BoxDecoration(
            color: Colors.blueAccent.withValues(alpha: 0.10),

            borderRadius: BorderRadius.circular(10),
          ),

          child: Icon(icon, color: Colors.blueAccent, size: 25),
        ),

        const SizedBox(width: 15),

        // TITLE
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),

              const SizedBox(height: 3),

              Text(
                value,
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
