import 'package:flutter/material.dart';

class PatientDetails extends StatelessWidget {
  const PatientDetails({super.key});

  static const Color primaryBlue = Colors.blueAccent;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: Center(
          child: Container(
            width: 600,
            height: 1100,

            clipBehavior: Clip.antiAlias,

            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),

            child: Scaffold(
              backgroundColor: Colors.white,

              // ================= APP BAR =================
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
                  "Patient Detail",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              // ================= BODY =================
              body: SingleChildScrollView(
                padding: const EdgeInsets.all(16),

                child: Column(
                  children: [
                    // ================= PATIENT CARD =================
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18),

                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),

                        border: Border.all(
                          color: Colors.blueAccent.withValues(alpha: 0.12),
                        ),

                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),

                      child: Column(
                        children: [
                          // Patient Icon
                          Container(
                            width: 80,
                            height: 80,

                            decoration: BoxDecoration(
                              shape: BoxShape.circle,

                              color: Colors.blueAccent.withValues(
                                alpha: 0.10,
                              ),

                              border: Border.all(
                                color: primaryBlue,
                                width: 2,
                              ),
                            ),

                            child: const Icon(
                              Icons.person,
                              size: 50,
                              color: primaryBlue,
                            ),
                          ),

                          const SizedBox(height: 10),

                          // Patient Name
                          const Text(
                            "Ali Ahmed",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),

                          const SizedBox(height: 5),

                          // Age & Gender
                          const Text(
                            "25 Years, Male",
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey,
                            ),
                          ),

                          const SizedBox(height: 5),

                          // Phone
                          const Text(
                            "+92 312 1234567",
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // ================= PATIENT INFORMATION =================
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),

                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),

                        border: Border.all(
                          color: Colors.blueAccent.withValues(alpha: 0.12),
                        ),

                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          const Text(
                            "Patient Information",
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: primaryBlue,
                            ),
                          ),

                          const SizedBox(height: 15),

                          infoRow(
                            Icons.location_on,
                            "Address",
                            "Lahore, Pakistan",
                          ),

                          const Divider(),

                          infoRow(
                            Icons.bloodtype,
                            "Blood Group",
                            "O+",
                          ),

                          const Divider(),

                          infoRow(
                            Icons.warning_amber,
                            "Allergies",
                            "None",
                          ),

                          const Divider(),

                          infoRow(
                            Icons.medical_information,
                            "Chronic Condition",
                            "Hypertension",
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // ================= NOTES =================
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),

                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),

                        border: Border.all(
                          color: Colors.blueAccent.withValues(alpha: 0.12),
                        ),

                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),

                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          Text(
                            "Notes",
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: primaryBlue,
                            ),
                          ),

                          SizedBox(height: 12),

                          Text(
                            "Regular exercise and low salt "
                                "diet recommended.",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                              height: 1.5,
                            ),
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
        // Icon Container
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

        // Information
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Text(
                title,

                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),

              const SizedBox(height: 4),

              Text(
                value,

                style: const TextStyle(
                  fontSize: 14,
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