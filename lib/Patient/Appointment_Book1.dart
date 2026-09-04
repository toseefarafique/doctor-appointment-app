import 'package:flutter/material.dart';

class AppointmentBook1 extends StatefulWidget {
  const AppointmentBook1({super.key});

  @override
  State<AppointmentBook1> createState() => _AppointmentBook1State();
}

class _AppointmentBook1State extends State<AppointmentBook1> {
  int selectedDate = 1;
  int selectedTime = 1;

  final TextEditingController reasonController = TextEditingController();

  final List<Map<String, String>> dates = [
    {"day": "Mon", "date": "20", "month": "May"},
    {"day": "Tue", "date": "21", "month": "May"},
    {"day": "Wed", "date": "22", "month": "May"},
    {"day": "Thu", "date": "23", "month": "May"},
    {"day": "Fri", "date": "24", "month": "May"},
  ];

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

  @override
  void dispose() {
    reasonController.dispose();
    super.dispose();
  }

  // ==============================================================
  // DATE CARD
  // ==============================================================

  Widget dateCard(
    String day,
    String date,
    String month,
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
            color: selected ? Colors.blueAccent : Colors.grey.shade300,
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
              day,
              style: TextStyle(
                color: selected ? Colors.white : Colors.black,
                fontSize: 15,
              ),
            ),

            Text(
              date,
              style: TextStyle(
                color: selected ? Colors.white : Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            Text(
              month,
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

  // ==============================================================
  // TIME CARD
  // ==============================================================

  Widget timeCard(String time, bool selected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,

      child: Container(
        width: 120,
        height: 45,

        decoration: BoxDecoration(
          color: selected ? Colors.blueAccent : Colors.white,

          borderRadius: BorderRadius.circular(10),

          border: Border.all(
            color: selected ? Colors.blueAccent : Colors.grey.shade300,
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

  // ==============================================================
  // CONFIRM APPOINTMENT
  // ==============================================================

  void confirmAppointment() {
    showDialog(
      context: context,

      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,

          title: const Text(
            "Appointment Confirmed",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),

          content: const Text(
            "Your appointment with Dr. Ayesha Khan has been booked successfully.",
            style: TextStyle(fontSize: 15),
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
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
  }

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
                // ====================================================
                // APP BAR
                // ====================================================

                Container(
                  height: 80,
                  width: double.infinity,

                  decoration: const BoxDecoration(
                    color: Colors.white,

                    border: Border(
                      bottom: BorderSide(color: Color(0xFFE5E5E5)),
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
                          mainAxisAlignment: MainAxisAlignment.center,

                          crossAxisAlignment: CrossAxisAlignment.start,

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

                // ====================================================
                // BODY
                // ====================================================
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(25),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

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
                            scrollDirection: Axis.horizontal,

                            itemCount: dates.length,

                            separatorBuilder: (context, index) =>
                                const SizedBox(width: 12),

                            itemBuilder: (context, index) {
                              final date = dates[index];

                              return dateCard(
                                date["day"]!,
                                date["date"]!,
                                date["month"]!,
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

                          children: List.generate(times.length, (index) {
                            return timeCard(
                              times[index],
                              selectedTime == index,
                              () {
                                setState(() {
                                  selectedTime = index;
                                });
                              },
                            );
                          }),
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
                          controller: reasonController,

                          maxLines: 3,

                          decoration: InputDecoration(
                            hintText: "Enter reason (Optional)",

                            filled: true,

                            fillColor: const Color(0xFFF5F7FA),

                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),

                              borderSide: BorderSide.none,
                            ),

                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),

                              borderSide: const BorderSide(
                                color: Colors.blueAccent,
                                width: 1.5,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 30),

                        // ==================================================
                        // APPOINTMENT SUMMARY
                        // ==================================================
                        Container(
                          width: double.infinity,

                          padding: const EdgeInsets.all(18),

                          decoration: BoxDecoration(
                            color: const Color(0xFFF5F9FF),

                            borderRadius: BorderRadius.circular(12),

                            border: Border.all(
                              color: Colors.blueAccent.withValues(alpha: 0.15),
                            ),
                          ),

                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,

                            children: [
                              const Text(
                                "Appointment Summary",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 12),

                              Text(
                                "Date: "
                                "${dates[selectedDate]["date"]} "
                                "${dates[selectedDate]["month"]}",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),

                              const SizedBox(height: 6),

                              Text(
                                "Time: "
                                "${times[selectedTime]}",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),

                              const SizedBox(height: 6),

                              const Text(
                                "Doctor: Dr. Ayesha Khan",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
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
                            onPressed: confirmAppointment,

                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueAccent,

                              foregroundColor: Colors.white,

                              elevation: 3,

                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),

                            child: const Text(
                              "Confirm Appointment",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
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
