import 'package:flutter/material.dart';

class DoctorProfile extends StatelessWidget {
  final String doctorId;
  final String doctorName;
  final String specialization;
  final String location;
  final String about;
  final String experience;
  final String qualification;
  final String hospital;
  final String email;
  final String phone;

  const DoctorProfile({
    super.key,
    required this.doctorId,
    required this.doctorName,
    required this.specialization,
    this.location = "Islamabad, Pakistan",
    this.about = "",
    this.experience = "",
    this.qualification = "",
    this.hospital = "",
    this.email = "",
    this.phone = "",
  });

  static const Color primaryBlue = Colors.blueAccent;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),

            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),

              child: Scaffold(
                backgroundColor: Colors.white,

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
                      // ================= DOCTOR BASIC INFORMATION =================
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),

                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),

                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.08),
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
                                color: Colors.blueAccent.withValues(
                                  alpha: 0.10,
                                ),

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
                              doctorName,
                              textAlign: TextAlign.center,

                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),

                            const SizedBox(height: 12),

                            // Specialization
                            Text(
                              specialization,
                              textAlign: TextAlign.center,

                              style: const TextStyle(
                                fontSize: 19,
                                color: primaryBlue,
                                fontWeight: FontWeight.w600,
                              ),
                            ),

                            const SizedBox(height: 7),

                            // Location
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,

                              children: [
                                const Icon(
                                  Icons.location_on,
                                  size: 16,
                                  color: Colors.grey,
                                ),

                                const SizedBox(width: 3),

                                Text(
                                  location,

                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 17),

                      // ================= ABOUT DOCTOR =================
                      profileSection(
                        title: "About Doctor",

                        child: Text(
                          about.isEmpty
                              ? "No information available."
                              : about,

                          style: const TextStyle(
                            color: Colors.black87,
                            height: 1.5,
                            fontSize: 15,
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // ================= PERSONAL INFORMATION =================
                      profileSection(
                        title: "Personal Information",

                        child: Column(
                          children: [
                            infoRow(
                              Icons.medical_services,
                              "Specialization",
                              specialization,
                            ),

                            const Divider(),

                            infoRow(
                              Icons.work,
                              "Experience",
                              experience,
                            ),

                            const Divider(),

                            infoRow(
                              Icons.school,
                              "Qualification",
                              qualification,
                            ),

                            const Divider(),

                            infoRow(
                              Icons.local_hospital,
                              "Hospital",
                              hospital,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // ================= CONTACT INFORMATION =================
                      profileSection(
                        title: "Contact Information",

                        child: Column(
                          children: [
                            infoRow(
                              Icons.email,
                              "Email",
                              email,
                            ),

                            const Divider(),

                            infoRow(
                              Icons.phone,
                              "Phone",
                              phone,
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

  // ================= PROFILE SECTION =================
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
            color: Colors.black.withValues(alpha: 0.06),
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
              color: primaryBlue,
            ),
          ),

          const SizedBox(height: 12),

          child,
        ],
      ),
    );
  }

  // ================= INFO ROW =================
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
            color: Colors.blueAccent.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(10),
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
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Text(
                title,

                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 13,
                ),
              ),

              const SizedBox(height: 6),

              Text(
                value.isEmpty ? "Not available" : value,

                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}