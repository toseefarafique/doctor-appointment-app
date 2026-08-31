import 'package:flutter/material.dart';
import 'appointment_details.dart';

class DoctorAppointments extends StatefulWidget {
  const DoctorAppointments({super.key});

  @override
  State<DoctorAppointments> createState() =>
      _DoctorAppointmentsState();
}

class _DoctorAppointmentsState extends State<DoctorAppointments> {
  int selectedTab = 0;

  static const Color primaryBlue = Color(0xFF1565C0);

  // ================= APPOINTMENTS DATA =================

  final List<Map<String, dynamic>> appointments = [
    {
      "name": "Ali Raza",
      "age": "25 Years",
      "gender": "Male",
      "date": "12 Aug 2025",
      "time": "10:00 AM",
      "type": "Consultation",
      "status": "Confirmed",
    },
    {
      "name": "Fatima Noor",
      "age": "30 Years",
      "gender": "Female",
      "date": "12 Aug 2025",
      "time": "11:30 AM",
      "type": "Follow-up",
      "status": "Upcoming",
    },
    {
      "name": "Ahmed Farooq",
      "age": "40 Years",
      "gender": "Male",
      "date": "12 Aug 2025",
      "time": "02:00 PM",
      "type": "Consultation",
      "status": "Upcoming",
    },
    {
      "name": "Ayesha Malik",
      "age": "28 Years",
      "gender": "Female",
      "date": "11 Aug 2025",
      "time": "04:00 PM",
      "type": "Consultation",
      "status": "Completed",
    },

    // Cancelled example
    {
      "name": "Hassan Ali",
      "age": "35 Years",
      "gender": "Male",
      "date": "10 Aug 2025",
      "time": "01:00 PM",
      "type": "Follow-up",
      "status": "Cancelled",
    },
  ];

  

  List<Map<String, dynamic>> get filteredAppointments {
    if (selectedTab == 0) {
      // All
      return appointments;
    } else if (selectedTab == 1) {
      // Upcoming
      return appointments.where((appointment) {
        return appointment["status"] == "Upcoming";
      }).toList();
    } else if (selectedTab == 2) {
      // Completed
      return appointments.where((appointment) {
        return appointment["status"] == "Completed";
      }).toList();
    } else {
      // Cancelled
      return appointments.where((appointment) {
        return appointment["status"] == "Cancelled";
      }).toList();
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

                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back),

                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),

                  title: const Text(
                    "Appointments",

                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                

                body: Column(
                  children: [
                    const SizedBox(height: 12),

                  

                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                      ),

                      child: Row(
                        children: [
                          appointmentTab(
                            "All",
                            0,
                          ),

                          appointmentTab(
                            "Upcoming",
                            1,
                          ),

                          appointmentTab(
                            "Completed",
                            2,
                          ),

                          appointmentTab(
                            "Cancelled",
                            3,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    

                    Expanded(
                      child: filteredAppointments.isEmpty
                          ? const Center(
                              child: Text(
                                "No appointments found",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            )
                          : ListView.builder(
                              padding:
                                  const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),

                              itemCount:
                                  filteredAppointments.length,

                              itemBuilder:
                                  (context, index) {
                                final appointment =
                                    filteredAppointments[index];

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
    );
  }

  

  Widget appointmentTab(
    String title,
    int index,
  ) {
    final bool isSelected =
        selectedTab == index;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedTab = index;
          });
        },

        child: Container(
          margin: const EdgeInsets.symmetric(
            horizontal: 3,
          ),

          padding: const EdgeInsets.symmetric(
            vertical: 9,
          ),

          decoration: BoxDecoration(
            color: isSelected
                ? primaryBlue
                : Colors.white,

            borderRadius:
                BorderRadius.circular(7),

            border: Border.all(
              color: isSelected
                  ? primaryBlue
                  : const Color(0xFFE0E0E0),
            ),
          ),

          child: Text(
            title,

            textAlign: TextAlign.center,

            style: TextStyle(
              fontSize: 10,

              fontWeight: isSelected
                  ? FontWeight.bold
                  : FontWeight.normal,

              color: isSelected
                  ? Colors.white
                  : Colors.black87,
            ),
          ),
        ),
      ),
    );
  }

  

  Widget appointmentCard(
    Map<String, dynamic> appointment,
  ) {
    return Container(
      margin: const EdgeInsets.only(
        bottom: 12,
      ),

      padding: const EdgeInsets.all(12),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(14),

        boxShadow: [
          BoxShadow(
            color:
                Colors.black.withOpacity(0.05),

            blurRadius: 6,

            offset: const Offset(0, 2),
          ),
        ],
      ),

      child: Column(
        children: [

          

          Row(
            children: [

              // Patient Icon
              Container(
                width: 45,
                height: 45,

                decoration:
                    const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFE3F2FD),
                ),

                child: const Icon(
                  Icons.person,

                  color: primaryBlue,

                  size: 28,
                ),
              ),

              const SizedBox(width: 10),

              // Patient Name + Age
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [
                    Text(
                      appointment["name"]
                          .toString(),

                      style:
                          const TextStyle(
                        fontSize: 14,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 3),

                    Text(
                      "${appointment["age"]}, "
                      "${appointment["gender"]}",

                      style:
                          const TextStyle(
                        fontSize: 11,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),

              // Status
              statusBadge(
                appointment["status"]
                    .toString(),
              ),
            ],
          ),

          const SizedBox(height: 12),

          const Divider(
            height: 1,
          ),

          const SizedBox(height: 10),

          

          Row(
            children: [

              const Icon(
                Icons.calendar_today,
                size: 15,
                color: primaryBlue,
              ),

              const SizedBox(width: 7),

              Text(
                appointment["date"]
                    .toString(),

                style:
                    const TextStyle(
                  fontSize: 11,
                ),
              ),

              const SizedBox(width: 18),

              const Icon(
                Icons.access_time,
                size: 15,
                color: primaryBlue,
              ),

              const SizedBox(width: 7),

              Text(
                appointment["time"]
                    .toString(),

                style:
                    const TextStyle(
                  fontSize: 11,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          

          Row(
            children: [

              const Icon(
                Icons.medical_services_outlined,
                size: 15,
                color: primaryBlue,
              ),

              const SizedBox(width: 7),

              Text(
                appointment["type"]
                    .toString(),

                style:
                    const TextStyle(
                  fontSize: 11,
                  color: Colors.blueGrey,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          

          SizedBox(
            width: double.infinity,
            height: 38,

            child: OutlinedButton(
              onPressed: () {
                Navigator.push(
                  context,

                  MaterialPageRoute(
                    builder: (context) =>
                        AppointmentDetails(
                      appointment:
                          appointment,
                    ),
                  ),
                );
              },

              style:
                  OutlinedButton.styleFrom(
                foregroundColor:
                    primaryBlue,

                side: const BorderSide(
                  color: primaryBlue,
                ),

                shape:
                    RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(8),
                ),
              ),

              child: const Text(
                "View Details",

                style: TextStyle(
                  fontSize: 12,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget statusBadge(
    String status,
  ) {
    Color background;
    Color textColor;

    if (status == "Confirmed") {
      background =
          const Color(0xFFE8F5E9);

      textColor = Colors.green;
    } else if (status == "Upcoming") {
      background =
          const Color(0xFFE3F2FD);

      textColor = primaryBlue;
    } else if (status == "Completed") {
      background =
          const Color(0xFFF1F1F1);

      textColor = Colors.grey;
    } else {
      background =
          const Color(0xFFFFEBEE);

      textColor = Colors.red;
    }

    return Container(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 5,
      ),

      decoration: BoxDecoration(
        color: background,

        borderRadius:
            BorderRadius.circular(20),
      ),

      child: Text(
        status,

        style: TextStyle(
          color: textColor,

          fontSize: 9,

          fontWeight:
              FontWeight.bold,
        ),
      ),
    );
  }
}