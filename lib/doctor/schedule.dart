import 'package:flutter/material.dart';

class DoctorSchedule extends StatefulWidget {
  const DoctorSchedule({super.key});

  @override
  State<DoctorSchedule> createState() => _DoctorScheduleState();
}

class _DoctorScheduleState extends State<DoctorSchedule> {
  static const Color primaryBlue = Colors.blueAccent;

  DateTime selectedDate = DateTime.now();

  final List<Map<String, String>> appointments = [
    {
      "patient": "Ali Ahmed",
      "time": "10:00 AM",
      "type": "Consultation",
      "status": "Confirmed",
    },
    {
      "patient": "Asma Noor",
      "time": "11:00 AM",
      "type": "Follow-up",
      "status": "Upcoming",
    },
    {
      "patient": "Hina Fatima",
      "time": "02:00 PM",
      "type": "Consultation",
      "status": "Upcoming",
    },
  ];

  Future<void> pickDate() async {
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.blueAccent,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black87,
            ),
          ),
          child: child!,
        );
      },
    );

    if (date != null) {
      setState(() {
        selectedDate = date;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 600,
            ),

            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),

              child: Scaffold(
                backgroundColor: Colors.white,

                appBar: AppBar(
                  backgroundColor: primaryBlue,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  centerTitle: true,

                  leading: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },

                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                  ),

                  title: const Text(
                    "Schedule",

                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                body: Padding(
                  padding: const EdgeInsets.all(20),

                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,

                    children: [
                      // ================= SELECT DATE =================

                      const Text(
                        "Select Date",

                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),

                      const SizedBox(height: 10),

                      SizedBox(
                        width: double.infinity,

                        child: OutlinedButton.icon(
                          onPressed: pickDate,

                          icon: const Icon(
                            Icons.calendar_month,
                            color: primaryBlue,
                          ),

                          label: Text(
                            "${selectedDate.day}/"
                                "${selectedDate.month}/"
                                "${selectedDate.year}",

                            style: const TextStyle(
                              color: Colors.black87,
                              fontSize: 14,
                            ),
                          ),

                          style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.white,

                            padding:
                            const EdgeInsets.symmetric(
                              vertical: 13,
                            ),

                            side: const BorderSide(
                              color: Colors.blueAccent,
                              width: 1,
                            ),

                            shape:
                            RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 25),

                      // ================= WORKING HOURS =================

                      Container(
                        width: double.infinity,

                        padding:
                        const EdgeInsets.all(15),

                        decoration: BoxDecoration(
                          color: Colors.blueAccent
                              .withValues(alpha: 0.10),

                          borderRadius:
                          BorderRadius.circular(12),

                          border: Border.all(
                            color: Colors.blueAccent
                                .withValues(alpha: 0.20),
                          ),
                        ),

                        child: const Row(
                          children: [
                            Icon(
                              Icons.access_time,
                              color: primaryBlue,
                            ),

                            SizedBox(width: 10),

                            Expanded(
                              child: Text(
                                "Working Hours: "
                                    "09:00 AM - 05:00 PM",

                                style: TextStyle(
                                  fontWeight:
                                  FontWeight.bold,
                                  fontSize: 13,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 25),

                      // ================= APPOINTMENTS =================

                      const Text(
                        "Appointments",

                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),

                      const SizedBox(height: 15),

                      Expanded(
                        child: appointments.isEmpty
                            ? const Center(
                          child: Text(
                            "No appointments for this date",

                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                        )
                            : ListView.builder(
                          itemCount:
                          appointments.length,

                          itemBuilder:
                              (context, index) {
                            final appointment =
                            appointments[index];

                            return appointmentCard(
                              appointment,
                            );
                          },
                        ),
                      ),
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

  // ================= APPOINTMENT CARD =================

  Widget appointmentCard(
      Map<String, String> appointment,
      ) {
    final String status =
    appointment["status"]!;

    final bool isConfirmed =
        status == "Confirmed";

    return Container(
      margin:
      const EdgeInsets.only(bottom: 12),

      padding:
      const EdgeInsets.all(12),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
        BorderRadius.circular(12),

        border: Border.all(
          color: Colors.blueAccent
              .withValues(alpha: 0.12),
        ),

        boxShadow: [
          BoxShadow(
            color:
            Colors.black.withValues(alpha: 0.05),

            blurRadius: 6,

            offset: const Offset(0, 2),
          ),
        ],
      ),

      child: Row(
        children: [
          // ================= PATIENT ICON =================

          CircleAvatar(
            radius: 23,

            backgroundColor:
            Colors.blueAccent.withValues(alpha: 0.10),

            child: const Icon(
              Icons.person,

              color: primaryBlue,

              size: 27,
            ),
          ),

          const SizedBox(width: 12),

          // ================= PATIENT DETAILS =================

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [
                Text(
                  appointment["patient"]!,

                  style: const TextStyle(
                    fontWeight:
                    FontWeight.bold,

                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),

                const SizedBox(height: 5),

                Row(
                  children: [
                    const Icon(
                      Icons.access_time,
                      size: 14,
                      color: primaryBlue,
                    ),

                    const SizedBox(width: 5),

                    Text(
                      appointment["time"]!,

                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 4),

                Text(
                  appointment["type"]!,

                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.blueGrey,
                  ),
                ),
              ],
            ),
          ),

          // ================= STATUS =================

          Container(
            padding:
            const EdgeInsets.symmetric(
              horizontal: 9,
              vertical: 5,
            ),

            decoration: BoxDecoration(
              color: isConfirmed
                  ? Colors.green.withValues(alpha: 0.10)
                  : Colors.blueAccent.withValues(alpha: 0.10),

              borderRadius:
              BorderRadius.circular(20),
            ),

            child: Text(
              status,

              style: TextStyle(
                color: isConfirmed
                    ? Colors.green
                    : primaryBlue,

                fontSize: 9,

                fontWeight:
                FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}