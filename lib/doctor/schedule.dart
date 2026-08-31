import 'package:flutter/material.dart';

class DoctorSchedule extends StatefulWidget {
  const DoctorSchedule({super.key});

  @override
  State<DoctorSchedule> createState() => _DoctorScheduleState();
}

class _DoctorScheduleState extends State<DoctorSchedule> {
  static const Color primaryBlue = Color(0xFF1565C0);

  DateTime selectedDate = DateTime.now();

  final List<Map<String, String>> appointments = [
    {
      "patient": "Ali Raza",
      "time": "10:00 AM",
      "type": "Consultation",
      "status": "Confirmed",
    },
    {
      "patient": "Fatima Noor",
      "time": "10:30 AM",
      "type": "Follow-up",
      "status": "Upcoming",
    },
    {
      "patient": "Ahmed Farooq",
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
      backgroundColor: const Color(0xFFEFF3F8),

      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 600,
            ),

            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),

              child: Scaffold(
                backgroundColor: const Color(0xFFF7F9FC),

                

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

                      

                      const Text(
                        "Select Date",

                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
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
                            ),
                          ),

                          style:
                              OutlinedButton.styleFrom(
                            padding:
                                const EdgeInsets.symmetric(
                              vertical: 13,
                            ),

                            side: const BorderSide(
                              color: Color(0xFFE0E0E0),
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

                      

                      Container(
                        width: double.infinity,

                        padding:
                            const EdgeInsets.all(15),

                        decoration: BoxDecoration(
                          color:
                              primaryBlue.withOpacity(.1),

                          borderRadius:
                              BorderRadius.circular(12),
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
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 25),

                      

                      const Text(
                        "Appointments",

                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
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

        boxShadow: [
          BoxShadow(
            color:
                Colors.black.withOpacity(0.05),

            blurRadius: 6,

            offset: const Offset(0, 2),
          ),
        ],
      ),

      child: Row(
        children: [

          

          CircleAvatar(
            radius: 23,

            backgroundColor:
                const Color(0xFFE3F2FD),

            child: const Icon(
              Icons.person,

              color: primaryBlue,

              size: 27,
            ),
          ),

          const SizedBox(width: 12),

      

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

                      style:
                          const TextStyle(
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

      

          Container(
            padding:
                const EdgeInsets.symmetric(
              horizontal: 9,
              vertical: 5,
            ),

            decoration: BoxDecoration(
              color: isConfirmed
                  ? const Color(0xFFE8F5E9)
                  : const Color(0xFFFFF3E0),

              borderRadius:
                  BorderRadius.circular(20),
            ),

            child: Text(
              status,

              style: TextStyle(
                color: isConfirmed
                    ? Colors.green
                    : Colors.orange,

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