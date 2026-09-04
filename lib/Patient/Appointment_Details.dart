import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AppointmentDetails extends StatelessWidget {
  final String appointmentId;
  final String doctor;
  final String specialization;
  final DateTime date;
  final String time;
  final String reason;
  final String status;

  const AppointmentDetails({
    super.key,
    required this.appointmentId,
    required this.doctor,
    required this.specialization,
    required this.date,
    required this.time,
    required this.reason,
    required this.status,
  });

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

  Color getStatusColor() {
    switch (status.toLowerCase()) {
      case 'completed':
        return Colors.green.shade700;
      case 'rejected':
      case 'cancelled':
        return Colors.red;
      case 'pending':
        return Colors.orange;
      default:
        return Colors.green;
    }
  }

  Future<void> cancelAppointment(BuildContext context) async {
    try {
      await FirebaseFirestore.instance
          .collection('appointments')
          .doc(appointmentId)
          .update({
        'status': 'Cancelled',
      });

      if (!context.mounted) return;

      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Appointment Cancelled"),
        ),
      );
    } catch (e) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to cancel appointment: $e"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: SafeArea(
        child: Center(
          child: Container(
            width: 600,
            constraints: const BoxConstraints(
              minHeight: 700,
              maxHeight: 900,
            ),
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
                // APP BAR
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

                // BODY
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(25),
                    child: Column(
                      children: [
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

                        // STATUS
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: getStatusColor()
                                .withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            status,
                            style: TextStyle(
                              color: getStatusColor(),
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),

                        const SizedBox(height: 12),

                        Text(
                          doctor,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        ),

                        const SizedBox(height: 5),

                        Text(
                          specialization,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),

                        const SizedBox(height: 25),

                        // INFORMATION CARD
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5F9FF),
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: Colors.blueAccent
                                  .withValues(alpha: 0.15),
                            ),
                          ),
                          child: Column(
                            children: [
                              _appointmentInfo(
                                icon: Icons.calendar_month_outlined,
                                title: "Date",
                                value: formatDate(date),
                              ),

                              const Divider(height: 25),

                              _appointmentInfo(
                                icon: Icons.access_time,
                                title: "Time",
                                value: time,
                              ),

                              const Divider(height: 25),

                              _appointmentInfo(
                                icon: Icons.medical_services_outlined,
                                title: "Consultation Fee",
                                value: "Rs. 1500",
                              ),

                              const Divider(height: 25),

                              _appointmentInfo(
                                icon: Icons.location_on_outlined,
                                title: "Location",
                                value: "City Hospital, Room 305",
                              ),

                              const Divider(height: 25),

                              _appointmentInfo(
                                icon: Icons.description_outlined,
                                title: "Reason",
                                value: reason,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 35),

                        // CANCEL
                        if (status.toLowerCase() != 'cancelled' &&
                            status.toLowerCase() != 'completed')
                          SizedBox(
                            width: double.infinity,
                            height: 55,
                            child: OutlinedButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (dialogContext) {
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
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(dialogContext);
                                          },
                                          child: const Text(
                                            "No",
                                            style: TextStyle(
                                              color: Colors.blueAccent,
                                              fontWeight:
                                              FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(dialogContext);
                                            cancelAppointment(context);
                                          },
                                          child: const Text(
                                            "Yes",
                                            style: TextStyle(
                                              color: Colors.red,
                                              fontWeight:
                                              FontWeight.bold,
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
                                  borderRadius:
                                  BorderRadius.circular(10),
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

  static Widget _appointmentInfo({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 45,
          width: 45,
          decoration: BoxDecoration(
            color: Colors.blueAccent.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: Colors.blueAccent,
            size: 25,
          ),
        ),

        const SizedBox(width: 15),

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