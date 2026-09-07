
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'doctor_dashboard.dart';

class DoctorProfile extends StatelessWidget {
  final String doctorId;
  final String doctorName;
  final String specialization;

  // These are only fallback values
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
            constraints: const BoxConstraints(
              maxWidth: 600,
            ),

            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),

              child: Scaffold(
                backgroundColor: Colors.white,

                // =========================================================
                // APP BAR
                // =========================================================

                appBar: AppBar(
                  backgroundColor: primaryBlue,
                  foregroundColor: Colors.white,
                  elevation: 0,

                  leading: IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                    ),

                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
  context,
  MaterialPageRoute(
    builder: (context) => const DoctorDashboard(),
  ),
  (route) => false,
);
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

                // =========================================================
                // FIREBASE PROFILE
                // =========================================================

                body: StreamBuilder<
                    DocumentSnapshot<Map<String, dynamic>>>(
                  stream: FirebaseFirestore.instance
                      .collection('doctors')
                      .doc(doctorId)
                      .snapshots(),

                  builder: (context, snapshot) {
                    // =====================================================
                    // LOADING
                    // =====================================================

                    if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    // =====================================================
                    // ERROR
                    // =====================================================

                    if (snapshot.hasError) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(20),

                          child: Text(
                            "Error loading doctor profile:\n\n"
                            "${snapshot.error}",

                            textAlign: TextAlign.center,

                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      );
                    }

                    // =====================================================
                    // DOCUMENT NOT FOUND
                    // =====================================================

                    if (!snapshot.hasData ||
                        !snapshot.data!.exists) {
                      debugPrint(
                        "====================================",
                      );

                      debugPrint(
                        "PROFILE DOCUMENT NOT FOUND",
                      );

                      debugPrint(
                        "Doctor ID: $doctorId",
                      );

                      debugPrint(
                        "====================================",
                      );

                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(20),

                          child: Column(
                            mainAxisAlignment:
                                MainAxisAlignment.center,

                            children: [
                              const Icon(
                                Icons.person_off,
                                size: 60,
                                color: Colors.grey,
                              ),

                              const SizedBox(height: 15),

                              const Text(
                                "Doctor profile not found.",

                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 8),

                              Text(
                                "Doctor ID:\n$doctorId",

                                textAlign: TextAlign.center,

                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    // =====================================================
                    // FIREBASE DATA
                    // =====================================================

                    final Map<String, dynamic> data =
                        snapshot.data!.data() ?? {};

                    // =====================================================
                    // DEBUG INFORMATION
                    // =====================================================

                    debugPrint(
                      "====================================",
                    );

                    debugPrint(
                      "DOCTOR PROFILE LOADED",
                    );

                    debugPrint(
                      "Doctor ID: $doctorId",
                    );

                    debugPrint(
                      "Firebase Data: $data",
                    );

                    debugPrint(
                      "Firebase Email: ${data['email']}",
                    );

                    debugPrint(
                      "Firebase Name: ${data['name']}",
                    );

                    debugPrint(
                      "Firebase Specialization: "
                      "${data['specialization']}",
                    );

                    debugPrint(
                      "====================================",
                    );

                    // =====================================================
                    // GET FIREBASE VALUES
                    // =====================================================

                    final String name =
                        _getValue(
                      data,
                      'name',
                      doctorName,
                    );

                    final String doctorSpecialization =
                        _getValue(
                      data,
                      'specialization',
                      specialization,
                    );

                    final String doctorEmail =
                        _getValue(
                      data,
                      'email',
                      email,
                    );

                    final String doctorPhone =
                        _getValue(
                      data,
                      'phone',
                      phone,
                    );

                    final String doctorExperience =
                        _getValue(
                      data,
                      'experience',
                      experience,
                    );

                    final String doctorQualification =
                        _getValue(
                      data,
                      'qualification',
                      qualification,
                    );

                    final String doctorHospital =
                        _getValue(
                      data,
                      'hospital',
                      hospital,
                    );

                    final String doctorAbout =
                        _getValue(
                      data,
                      'about',
                      about,
                    );

                    final String doctorLocation =
                        _getValue(
                      data,
                      'location',
                      location,
                    );

                    final String doctorImage =
                        _getValue(
                      data,
                      'image',
                      '',
                    );

                    // =====================================================
                    // MAIN UI
                    // =====================================================

                    return SingleChildScrollView(
                      padding: const EdgeInsets.all(16),

                      child: Column(
                        children: [

                          // =================================================
                          // DOCTOR BASIC INFORMATION
                          // =================================================

                          Container(
                            width: double.infinity,

                            padding: const EdgeInsets.all(20),

                            decoration: BoxDecoration(
                              color: Colors.white,

                              borderRadius:
                                  BorderRadius.circular(16),

                              boxShadow: [
                                BoxShadow(
                                  color:
                                      Colors.black.withValues(
                                    alpha: 0.08,
                                  ),

                                  blurRadius: 8,

                                  offset:
                                      const Offset(0, 3),
                                ),
                              ],
                            ),

                            child: Column(
                              children: [

                                // ===============================
                                // DOCTOR IMAGE
                                // ===============================

                                Container(
                                  width: 100,
                                  height: 100,

                                  decoration:
                                      BoxDecoration(
                                    shape:
                                        BoxShape.circle,

                                    color: Colors.blueAccent
                                        .withValues(
                                      alpha: 0.10,
                                    ),

                                    border: Border.all(
                                      color:
                                          primaryBlue,

                                      width: 3,
                                    ),
                                  ),

                                  child: ClipOval(
                                    child:
                                        doctorImage
                                                .isNotEmpty
                                            ? Image.asset(
                                                doctorImage,

                                                fit: BoxFit
                                                    .cover,

                                                errorBuilder:
                                                    (
                                                  context,
                                                  error,
                                                  stackTrace,
                                                ) {
                                                  return const Icon(
                                                    Icons.person,

                                                    size: 65,

                                                    color:
                                                        primaryBlue,
                                                  );
                                                },
                                              )
                                            : const Icon(
                                                Icons.person,

                                                size: 65,

                                                color:
                                                    primaryBlue,
                                              ),
                                  ),
                                ),

                                const SizedBox(
                                  height: 12,
                                ),

                                // ===============================
                                // NAME
                                // ===============================

                                Text(
                                  name,

                                  textAlign:
                                      TextAlign.center,

                                  style:
                                      const TextStyle(
                                    fontSize: 22,

                                    fontWeight:
                                        FontWeight.bold,

                                    color:
                                        Colors.black87,
                                  ),
                                ),

                                const SizedBox(
                                  height: 12,
                                ),

                                // ===============================
                                // SPECIALIZATION
                                // ===============================

                                Text(
                                  doctorSpecialization
                                          .isEmpty
                                      ? "Specialization not available"
                                      : doctorSpecialization,

                                  textAlign:
                                      TextAlign.center,

                                  style:
                                      const TextStyle(
                                    fontSize: 19,

                                    color:
                                        primaryBlue,

                                    fontWeight:
                                        FontWeight.w600,
                                  ),
                                ),

                                const SizedBox(
                                  height: 7,
                                ),

                                // ===============================
                                // LOCATION
                                // ===============================

                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment
                                          .center,

                                  children: [
                                    const Icon(
                                      Icons.location_on,

                                      size: 16,

                                      color:
                                          Colors.grey,
                                    ),

                                    const SizedBox(
                                      width: 3,
                                    ),

                                    Flexible(
                                      child: Text(
                                        doctorLocation,

                                        textAlign:
                                            TextAlign
                                                .center,

                                        style:
                                            const TextStyle(
                                          color:
                                              Colors.grey,

                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(
                            height: 17,
                          ),

                          // =================================================
                          // ABOUT DOCTOR
                          // =================================================

                          profileSection(
                            title: "About Doctor",

                            child: Text(
                              doctorAbout.isEmpty
                                  ? "No information available."
                                  : doctorAbout,

                              style:
                                  const TextStyle(
                                color:
                                    Colors.black87,

                                height: 1.5,

                                fontSize: 15,
                              ),
                            ),
                          ),

                          const SizedBox(
                            height: 16,
                          ),

                          // =================================================
                          // PERSONAL INFORMATION
                          // =================================================

                          profileSection(
                            title:
                                "Personal Information",

                            child: Column(
                              children: [

                                infoRow(
                                  Icons
                                      .medical_services,

                                  "Specialization",

                                  doctorSpecialization,
                                ),

                                const Divider(),

                                infoRow(
                                  Icons.work,

                                  "Experience",

                                  doctorExperience,
                                ),

                                const Divider(),

                                infoRow(
                                  Icons.school,

                                  "Qualification",

                                  doctorQualification,
                                ),

                                const Divider(),

                                infoRow(
                                  Icons.local_hospital,

                                  "Hospital",

                                  doctorHospital,
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(
                            height: 16,
                          ),

                          // =================================================
                          // CONTACT INFORMATION
                          // =================================================

                          profileSection(
                            title:
                                "Contact Information",

                            child: Column(
                              children: [

                                // ===============================
                                // EMAIL
                                // ===============================

                                infoRow(
                                  Icons.email,

                                  "Email",

                                  doctorEmail,
                                ),

                                const Divider(),

                                // ===============================
                                // PHONE
                                // ===============================

                                infoRow(
                                  Icons.phone,

                                  "Phone",

                                  doctorPhone,
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // =============================================================
  // GET STRING VALUE FROM FIREBASE
  // =============================================================

  static String _getValue(
    Map<String, dynamic> data,
    String field,
    String fallback,
  ) {
    final dynamic value = data[field];

    if (value == null) {
      return fallback;
    }

    final String result =
        value.toString().trim();

    if (result.isEmpty) {
      return fallback;
    }

    return result;
  }

  // =============================================================
  // PROFILE SECTION
  // =============================================================

  static Widget profileSection({
    required String title,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(14),

        boxShadow: [
          BoxShadow(
            color:
                Colors.black.withValues(
              alpha: 0.06,
            ),

            blurRadius: 6,

            offset:
                const Offset(0, 3),
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

              fontWeight:
                  FontWeight.bold,

              color: primaryBlue,
            ),
          ),

          const SizedBox(
            height: 12,
          ),

          child,
        ],
      ),
    );
  }

  // =============================================================
  // INFORMATION ROW
  // =============================================================

  static Widget infoRow(
    IconData icon,
    String title,
    String value,
  ) {
    final String displayValue =
        value.trim().isEmpty
            ? "Not available"
            : value.trim();

    return Row(
      crossAxisAlignment:
          CrossAxisAlignment.center,

      children: [

        // ===============================
        // ICON
        // ===============================

        Container(
          width: 38,
          height: 38,

          decoration:
              BoxDecoration(
            color:
                Colors.blueAccent
                    .withValues(
              alpha: 0.10,
            ),

            borderRadius:
                BorderRadius.circular(10),
          ),

          child: Icon(
            icon,

            color:
                primaryBlue,

            size: 20,
          ),
        ),

        const SizedBox(
          width: 12,
        ),

        // ===============================
        // TEXT
        // ===============================

        Expanded(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [
              Text(
                title,

                style:
                    const TextStyle(
                  color:
                      Colors.grey,

                  fontSize: 13,
                ),
              ),

              const SizedBox(
                height: 6,
              ),

              Text(
                displayValue,

                style:
                    const TextStyle(
                  fontSize: 15,

                  fontWeight:
                      FontWeight.w600,

                  color:
                      Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

