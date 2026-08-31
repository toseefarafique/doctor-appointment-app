import 'package:flutter/material.dart';

class DoctorProfile extends StatelessWidget {
  const DoctorProfile({super.key});

  static const Color primaryBlue = Color(0xFF1565C0);

  

  static const Map<String, String> doctor = {
    "name": "Dr. Sarah Khan",
    "specialization": "Darmatalologist",
    "location": "Islamabad, Pakistan",
    "about":
        "Dr. Sarah Khan is an experienced Darmataologist "
        "specializing in heart health, diagnosis and patient "
        "care. She provides professional medical consultation "
        "and follow-up services.",
    "experience": "8 Years",
    "qualification": "MBBS, FCPS",
    "hospital": "City Medical Center",
    "email": "sarah@example.com",
    "phone": "+92 300 1234567",
  };

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
                    "Doctor Profile",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

              

                body: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),

                  child: Column(
                    children: [

                      

                      Container(
                        width: double.infinity,

                        padding: const EdgeInsets.all(20),

                        decoration: BoxDecoration(
                          color: Colors.white,

                          borderRadius:
                              BorderRadius.circular(16),

                          boxShadow: [
                            BoxShadow(
                              color: Colors.black
                                  .withOpacity(0.06),

                              blurRadius: 8,

                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),

                        child: Column(
                          children: [

                            // Doctor Image
                            Container(
                              width: 100,
                              height: 100,

                              decoration: BoxDecoration(
                                shape: BoxShape.circle,

                                color:
                                    const Color(0xFFE3F2FD),

                                border: Border.all(
                                  color: primaryBlue,
                                  width: 3,
                                ),
                              ),

                              child: const Icon(
                                Icons.person,
                                size: 65,
                                color: primaryBlue,
                              ),
                            ),

                            const SizedBox(height: 12),

                            // Doctor Name
                            Text(
                              doctor["name"]!,

                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 12),

                            // Specialization
                            Text(
                              doctor["specialization"]!,

                              style: const TextStyle(
                                fontSize: 19,
                                color: primaryBlue,
                              ),
                            ),

                            const SizedBox(height: 7),

                            // Location
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.center,

                              children: [
                                const Icon(
                                  Icons.location_on,
                                  size: 16,
                                  color: Colors.grey,
                                ),

                                const SizedBox(width: 3),

                                Text(
                                  doctor["location"]!,

                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 17),

                      

                      profileSection(
                        title: "About Doctor",

                        child: Text(
                          doctor["about"]!,

                          style: const TextStyle(
                            color: Color.fromARGB(
                              255,
                              20,
                              19,
                              19,
                            ),

                            height: 1.5,
                            fontSize: 15,
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      

                      profileSection(
                        title: "Personal Information",

                        child: Column(
                          children: [

                            infoRow(
                              Icons.medical_services,
                              "Specialization",
                              doctor["specialization"]!,
                            ),

                            const Divider(),

                            infoRow(
                              Icons.work,
                              "Experience",
                              doctor["experience"]!,
                            ),

                            const Divider(),

                            infoRow(
                              Icons.school,
                              "Qualification",
                              doctor["qualification"]!,
                            ),

                            const Divider(),

                            infoRow(
                              Icons.local_hospital,
                              "Hospital",
                              doctor["hospital"]!,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      

                      profileSection(
                        title: "Contact Information",

                        child: Column(
                          children: [

                            infoRow(
                              Icons.email,
                              "Email",
                              doctor["email"]!,
                            ),

                            const Divider(),

                            infoRow(
                              Icons.phone,
                              "Phone",
                              doctor["phone"]!,
                            ),
                          ],
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

  

  static Widget profileSection({
    required String title,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(14),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),

            blurRadius: 6,

            offset: const Offset(0, 3),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
          Text(
            title,

            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: primaryBlue,
            ),
          ),

          const SizedBox(height: 12),

          child,
        ],
      ),
    );
  }

  

  static Widget infoRow(
    IconData icon,
    String title,
    String value,
  ) {
    return Row(
      children: [

        Container(
          width: 38,
          height: 38,

          decoration: BoxDecoration(
            color: const Color(0xFFE3F2FD),

            borderRadius:
                BorderRadius.circular(10),
          ),

          child: Icon(
            icon,
            color: primaryBlue,
            size: 20,
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [

              Text(
                title,

                style: const TextStyle(
                  color: Color.fromARGB(
                    255,
                    151,
                    129,
                    129,
                  ),

                  fontSize: 13,
                ),
              ),

              const SizedBox(height: 6),

              Text(
                value,

                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}