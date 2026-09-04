import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'Appointment_Details.dart';

class AppointmentBook1 extends StatefulWidget {
  const AppointmentBook1({super.key});

  @override
  State<AppointmentBook1> createState() => _AppointmentBook1State();
}

class _AppointmentBook1State extends State<AppointmentBook1> {
  int selectedDate = 0;
  int selectedTime = 0;

  bool isBooking = false;

  final TextEditingController reasonController = TextEditingController();

  // ============================================================
  // DATES
  // ============================================================

  late final List<DateTime> dates;

  // ============================================================
  // AVAILABLE TIMES
  // ============================================================

  final List<String> times = [
    "9:00 AM",
    "10:00 AM",
    "11:00 AM",
    "12:00 PM",
    "3:00 PM",
    "4:00 PM",
    "5:00 PM",
    "6:00 PM",
  ];

  // ============================================================
  // INIT
  // ============================================================

  @override
  void initState() {
    super.initState();

    final today = DateTime.now();

    dates = List.generate(
      5,
          (index) => DateTime(
        today.year,
        today.month,
        today.day + index,
      ),
    );
  }

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void dispose() {
    reasonController.dispose();
    super.dispose();
  }

  // ============================================================
  // MONTH NAME
  // ============================================================

  String getMonthName(int month) {
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

    return months[month - 1];
  }

  // ============================================================
  // DAY NAME
  // ============================================================

  String getDayName(int weekday) {
    const days = [
      "Mon",
      "Tue",
      "Wed",
      "Thu",
      "Fri",
      "Sat",
      "Sun",
    ];

    return days[weekday - 1];
  }

  // ============================================================
  // FORMAT DATE
  // ============================================================

  String formatDate(DateTime date) {
    return "${date.day} ${getMonthName(date.month)} ${date.year}";
  }

  // ============================================================
  // DATE CARD
  // ============================================================

  Widget dateCard(
      DateTime date,
      bool selected,
      VoidCallback onTap,
      ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 72,
        height: 89,
        decoration: BoxDecoration(
          color: selected ? Colors.blueAccent : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected
                ? Colors.blueAccent
                : Colors.grey.shade300,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.15),
              blurRadius: 5,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              getDayName(date.weekday),
              style: TextStyle(
                color: selected ? Colors.white : Colors.black,
                fontSize: 15,
              ),
            ),
            Text(
              date.day.toString(),
              style: TextStyle(
                color: selected ? Colors.white : Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              getMonthName(date.month).substring(0, 3),
              style: TextStyle(
                color: selected ? Colors.white : Colors.grey,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // TIME CARD
  // ============================================================

  Widget timeCard(
      String time,
      bool selected,
      VoidCallback onTap,
      ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 120,
        height: 45,
        decoration: BoxDecoration(
          color: selected ? Colors.blueAccent : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected
                ? Colors.blueAccent
                : Colors.grey.shade300,
          ),
        ),
        child: Center(
          child: Text(
            time,
            style: TextStyle(
              color: selected ? Colors.white : Colors.blueAccent,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // GET PATIENT NAME FROM FIRESTORE
  // ============================================================

  Future<String> getPatientName(User user) async {
    // ----------------------------------------------------------
    // First try Firebase Authentication displayName
    // ----------------------------------------------------------

    if (user.displayName != null &&
        user.displayName!.trim().isNotEmpty) {
      return user.displayName!.trim();
    }

    // ----------------------------------------------------------
    // Get patient from patients collection using email
    // ----------------------------------------------------------

    if (user.email != null && user.email!.isNotEmpty) {
      final patientQuery = await FirebaseFirestore.instance
          .collection('patients')
          .where(
        'email',
        isEqualTo: user.email,
      )
          .limit(1)
          .get();

      if (patientQuery.docs.isNotEmpty) {
        final patientData = patientQuery.docs.first.data();

        final name = patientData['name']?.toString().trim();

        if (name != null && name.isNotEmpty) {
          return name;
        }
      }
    }

    // ----------------------------------------------------------
    // Fallback
    // ----------------------------------------------------------

    return "Patient";
  }

  // ============================================================
  // SAVE APPOINTMENT TO FIRESTORE
  // ============================================================

  Future<void> confirmAppointment() async {
    final user = FirebaseAuth.instance.currentUser;

    // ----------------------------------------------------------
    // CHECK LOGIN
    // ----------------------------------------------------------

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please login first."),
        ),
      );

      return;
    }

    setState(() {
      isBooking = true;
    });

    final selectedDateValue = dates[selectedDate];
    final selectedTimeValue = times[selectedTime];

    final reason = reasonController.text.trim().isEmpty
        ? 'Regular Checkup'
        : reasonController.text.trim();

    try {
      // --------------------------------------------------------
      // GET PATIENT NAME
      // --------------------------------------------------------

      final patientName = await getPatientName(user);

      // --------------------------------------------------------
      // SAVE APPOINTMENT TO FIRESTORE
      // --------------------------------------------------------

      final appointmentRef = await FirebaseFirestore.instance
          .collection('appointments')
          .add({
        // Doctor information
        'doctor': 'Dr. Ayesha Khan',
        'specialization': 'Cardiologist',

        // ------------------------------------------------------
        // Patient information
        // ------------------------------------------------------

        'patientId': user.uid,
        'patientName': patientName,
        'patientEmail': user.email ?? '',

        // ------------------------------------------------------
        // Appointment information
        // ------------------------------------------------------

        'date': Timestamp.fromDate(selectedDateValue),
        'time': selectedTimeValue,
        'reason': reason,

        // ------------------------------------------------------
        // Status
        // ------------------------------------------------------

        'status': 'Pending',

        // ------------------------------------------------------
        // Creation time
        // ------------------------------------------------------

        'createdAt': FieldValue.serverTimestamp(),
      });

      if (!mounted) return;

      setState(() {
        isBooking = false;
      });

      // --------------------------------------------------------
      // CONFIRMATION DIALOG
      // --------------------------------------------------------

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) {
          return AlertDialog(
            backgroundColor: Colors.white,

            title: const Text(
              "Appointment Confirmed",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),

            content: Text(
              "Your appointment with Dr. Ayesha Khan "
                  "has been booked successfully.\n\n"
                  "Patient: $patientName\n"
                  "Date: ${formatDate(selectedDateValue)}\n"
                  "Time: $selectedTimeValue",
              style: const TextStyle(
                fontSize: 15,
              ),
            ),

            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(dialogContext);

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AppointmentDetails(
                        appointmentId: appointmentRef.id,
                        doctor: 'Dr. Ayesha Khan',
                        specialization: 'Cardiologist',
                        date: selectedDateValue,
                        time: selectedTimeValue,
                        reason: reason,
                        status: 'Pending',
                      ),
                    ),
                  );
                },

                child: const Text(
                  "OK",
                  style: TextStyle(
                    color: Colors.blueAccent,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          );
        },
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isBooking = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Failed to book appointment: $e",
          ),
        ),
      );
    }
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final selectedDateValue = dates[selectedDate];

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
                // ==================================================
                // APP BAR
                // ==================================================

                Container(
                  height: 80,
                  width: double.infinity,

                  decoration: const BoxDecoration(
                    color: Colors.white,

                    border: Border(
                      bottom: BorderSide(
                        color: Color(0xFFE5E5E5),
                      ),
                    ),
                  ),

                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },

                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.black,
                          size: 30,
                        ),
                      ),

                      const SizedBox(width: 8),

                      const Expanded(
                        child: Column(
                          mainAxisAlignment:
                          MainAxisAlignment.center,

                          crossAxisAlignment:
                          CrossAxisAlignment.start,

                          children: [
                            Text(
                              "Book Appointment",

                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 23,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            Text(
                              "Dr. Ayesha Khan",

                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // ==================================================
                // BODY
                // ==================================================

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(25),

                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,

                      children: [
                        // ==================================================
                        // SELECT DATE
                        // ==================================================

                        const Text(
                          "Select Date",

                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          ),
                        ),

                        const SizedBox(height: 15),

                        SizedBox(
                          height: 95,

                          child: ListView.separated(
                            scrollDirection:
                            Axis.horizontal,

                            itemCount: dates.length,

                            separatorBuilder:
                                (context, index) =>
                            const SizedBox(width: 12),

                            itemBuilder:
                                (context, index) {
                              return dateCard(
                                dates[index],
                                selectedDate == index,
                                    () {
                                  setState(() {
                                    selectedDate = index;
                                  });
                                },
                              );
                            },
                          ),
                        ),

                        const SizedBox(height: 25),

                        // ==================================================
                        // SELECT TIME
                        // ==================================================

                        const Text(
                          "Select Time",

                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          ),
                        ),

                        const SizedBox(height: 15),

                        Wrap(
                          spacing: 15,
                          runSpacing: 12,

                          children:
                          List.generate(
                            times.length,
                                (index) {
                              return timeCard(
                                times[index],
                                selectedTime == index,
                                    () {
                                  setState(() {
                                    selectedTime = index;
                                  });
                                },
                              );
                            },
                          ),
                        ),

                        const SizedBox(height: 25),

                        // ==================================================
                        // REASON
                        // ==================================================

                        const Text(
                          "Reason For Visit",

                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          ),
                        ),

                        const SizedBox(height: 10),

                        TextField(
                          controller:
                          reasonController,

                          maxLines: 3,

                          decoration:
                          InputDecoration(
                            hintText:
                            "Enter reason (Optional)",

                            filled: true,

                            fillColor:
                            const Color(
                              0xFFF5F7FA,
                            ),

                            border:
                            OutlineInputBorder(
                              borderRadius:
                              BorderRadius.circular(
                                12,
                              ),

                              borderSide:
                              BorderSide.none,
                            ),

                            focusedBorder:
                            OutlineInputBorder(
                              borderRadius:
                              BorderRadius.circular(
                                12,
                              ),

                              borderSide:
                              const BorderSide(
                                color:
                                Colors.blueAccent,
                                width: 1.5,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 30),

                        // ==================================================
                        // SUMMARY
                        // ==================================================

                        Container(
                          width: double.infinity,

                          padding:
                          const EdgeInsets.all(18),

                          decoration:
                          BoxDecoration(
                            color:
                            const Color(
                              0xFFF5F9FF,
                            ),

                            borderRadius:
                            BorderRadius.circular(
                              12,
                            ),

                            border:
                            Border.all(
                              color: Colors.blueAccent
                                  .withValues(
                                alpha: 0.15,
                              ),
                            ),
                          ),

                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,

                            children: [
                              const Text(
                                "Appointment Summary",

                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight:
                                  FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 12),

                              Text(
                                "Date: ${formatDate(selectedDateValue)}",

                                style:
                                const TextStyle(
                                  fontSize: 16,
                                  fontWeight:
                                  FontWeight.w600,
                                ),
                              ),

                              const SizedBox(height: 6),

                              Text(
                                "Time: ${times[selectedTime]}",

                                style:
                                const TextStyle(
                                  fontSize: 16,
                                  fontWeight:
                                  FontWeight.w600,
                                ),
                              ),

                              const SizedBox(height: 6),

                              const Text(
                                "Doctor: Dr. Ayesha Khan",

                                style:
                                TextStyle(
                                  fontSize: 16,
                                  fontWeight:
                                  FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 30),

                        // ==================================================
                        // CONFIRM BUTTON
                        // ==================================================

                        SizedBox(
                          width: double.infinity,
                          height: 60,

                          child: ElevatedButton(
                            onPressed: isBooking
                                ? null
                                : confirmAppointment,

                            style:
                            ElevatedButton.styleFrom(
                              backgroundColor:
                              Colors.blueAccent,

                              foregroundColor:
                              Colors.white,

                              elevation: 3,

                              shape:
                              RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(
                                  10,
                                ),
                              ),
                            ),

                            child: isBooking
                                ? const SizedBox(
                              height: 25,
                              width: 25,

                              child:
                              CircularProgressIndicator(
                                color:
                                Colors.white,
                                strokeWidth: 3,
                              ),
                            )
                                : const Text(
                              "Confirm Appointment",

                              style:
                              TextStyle(
                                fontWeight:
                                FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),
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
}