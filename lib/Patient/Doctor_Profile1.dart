import 'package:flutter/material.dart';
import 'Appointment_Book1.dart';

class Doctor_profile1 extends StatelessWidget {
  const Doctor_profile1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      body: Center(
        child: Container(
          width: 600,
          constraints: const BoxConstraints(
            minHeight: 700,
            maxHeight: 900,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.12),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),

          child: ClipRRect(
            borderRadius: BorderRadius.circular(25),

            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // =========================
                  // TOP BLUE SECTION
                  // =========================
                  Container(
                    height: 250,
                    width: double.infinity,
                    color: Colors.blueAccent,

                    child: Stack(
                      alignment: Alignment.center,
                      children: [

                        // Back Button
                        Positioned(
                          left: 10,
                          top: 35,
                          child: IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                              size: 32,
                            ),
                          ),
                        ),

                        // Favorite Button
                        Positioned(
                          right: 10,
                          top: 35,
                          child: IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.favorite_border,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                        ),

                        // Doctor Image
                        Positioned(
                          bottom: 15,
                          child: Container(
                            height: 160,
                            width: 160,

                            decoration: const BoxDecoration(
                              color: Color.fromARGB(
                                255,
                                182,
                                224,
                                243,
                              ),
                              shape: BoxShape.circle,
                            ),

                            child: ClipOval(
                              child: Image.asset(
                                'assets/images/Doctor1.png',
                                fit: BoxFit.contain,

                                errorBuilder:
                                    (context, error, stackTrace) {
                                  return const Icon(
                                    Icons.person,
                                    size: 100,
                                    color: Colors.blueAccent,
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // =========================
                  // DOCTOR NAME
                  // =========================
                  const Padding(
                    padding: EdgeInsets.only(
                      left: 20,
                      top: 15,
                    ),
                    child: Text(
                      "Dr. Ayesha Khan",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                      ),
                    ),
                  ),

                  // =========================
                  // SPECIALIZATION
                  // =========================
                  const Padding(
                    padding: EdgeInsets.only(
                      left: 22,
                      top: 3,
                    ),
                    child: Text(
                      "Cardiologist",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  // =========================
                  // RATING
                  // =========================
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 18,
                      top: 15,
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: 25,
                        ),

                        const SizedBox(width: 5),

                        const Text(
                          "4.8",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),

                        const Text(
                          " (256 Reviews)",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // =========================
                  // EXPERIENCE
                  // =========================
                  const Padding(
                    padding: EdgeInsets.only(
                      left: 20,
                      top: 15,
                    ),
                    child: Row(
                      children: [
                        Text(
                          "5+",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),

                        Text(
                          " Years Experience",
                          style: TextStyle(
                            fontSize: 17,
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // =========================
                  // ABOUT SECTION
                  // =========================
                  Padding(
                    padding: const EdgeInsets.all(18),

                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,

                      children: [

                        const Text(
                          "About:",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          ),
                        ),

                        const SizedBox(height: 10),

                        const Text(
                          "Dr. Ayesha is an experienced cardiologist "
                              "specializing in heart health and cardiovascular "
                              "care. She provides personalized treatment and "
                              "focuses on helping patients maintain a healthy heart.",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 17,
                            height: 1.5,
                          ),
                        ),

                        const SizedBox(height: 20),

                        // =========================
                        // CONSULTATION FEE
                        // =========================
                        const Text(
                          "Consultation Fee",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),

                        const SizedBox(height: 5),

                        const Text(
                          "Rs: 1500",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),

                        const SizedBox(height: 20),

                        // =========================
                        // BOOK APPOINTMENT BUTTON
                        // =========================
                        SizedBox(
                          width: double.infinity,
                          height: 60,

                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                  const AppointmentBook1(),
                                ),
                              );
                            },

                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                              Colors.blueAccent,
                              foregroundColor: Colors.white,

                              shape:
                              RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(10),
                              ),
                            ),

                            child: const Text(
                              "Book Appointment",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}