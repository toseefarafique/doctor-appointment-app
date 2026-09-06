
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'Appointment_Book1.dart';

class DoctorProfile extends StatelessWidget {
  final String doctorId;
  final String doctorName;
  final String specialization;

  const DoctorProfile({
    super.key,
    required this.doctorId,
    required this.doctorName,
    required this.specialization,
  });

  static const Color primaryBlue = Color(0xFF1565C0);

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
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                  elevation: 0,

                  leading: IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                    ),

                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),

                  title: Text(
                    doctorName,

                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                // =========================================================
                // FIREBASE DATA
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
                      return const Center(
                        child: Text(
                          "Doctor profile not found.",
                          textAlign: TextAlign.center,
                        ),
                      );
                    }

                    // =====================================================
                    // FIREBASE DATA
                    // =====================================================

                    final Map<String, dynamic> data =
                        snapshot.data!.data() ?? {};

                    // =====================================================
                    // READ DOCTOR INFORMATION
                    // =====================================================

                    final String name = _getString(
                      data,
                      'name',
                      doctorName,
                    );

                    final String doctorSpecialization =
                        _getString(
                      data,
                      'specialization',
                      specialization,
                    );

                    final String location = _getString(
                      data,
                      'location',
                      'Islamabad, Pakistan',
                    );

                    final String about = _getString(
                      data,
                      'about',
                      '',
                    );

                    final String experience = _getString(
                      data,
                      'experience',
                      '',
                    );

                    final String qualification = _getString(
                      data,
                      'qualification',
                      '',
                    );

                    final String hospital = _getString(
                      data,
                      'hospital',
                      '',
                    );

                    final String email = _getString(
                      data,
                      'email',
                      '',
                    );

                    final String phone = _getString(
                      data,
                      'phone',
                      '',
                    );

                    final String image = _getString(
                      data,
                      'image',
                      '',
                    );

                    // =====================================================
                    // MAIN PAGE
                    // =====================================================

                    return SingleChildScrollView(
                      padding: const EdgeInsets.all(20),

                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,

                        children: [

                          // =================================================
                          // DOCTOR IMAGE
                          // =================================================

                          Center(
                            child: Container(
                              width: 110,
                              height: 110,

                              decoration: BoxDecoration(
                                shape: BoxShape.circle,

                                color: Colors.blue.shade100,

                                border: Border.all(
                                  color: primaryBlue,
                                  width: 3,
                                ),
                              ),

                              child: ClipOval(
                                child: image.isNotEmpty
                                    ? Image.asset(
                                        image,
                                        fit: BoxFit.cover,

                                        errorBuilder:
                                            (
                                          context,
                                          error,
                                          stackTrace,
                                        ) {
                                          return const Icon(
                                            Icons.person,
                                            size: 65,
                                            color: primaryBlue,
                                          );
                                        },
                                      )
                                    : const Icon(
                                        Icons.person,
                                        size: 65,
                                        color: primaryBlue,
                                      ),
                              ),
                            ),
                          ),

                          const SizedBox(
                            height: 20,
                          ),

                          // =================================================
                          // DOCTOR NAME
                          // =================================================

                          Center(
                            child: Text(
                              name,

                              textAlign:
                                  TextAlign.center,

                              style:
                                  const TextStyle(
                                fontSize: 24,

                                fontWeight:
                                    FontWeight.bold,

                                color:
                                    primaryBlue,
                              ),
                            ),
                          ),

                          const SizedBox(
                            height: 8,
                          ),

                          // =================================================
                          // SPECIALIZATION
                          // =================================================

                          Center(
                            child: Text(
                              doctorSpecialization.isEmpty
                                  ? "Specialization not available"
                                  : doctorSpecialization,

                              textAlign:
                                  TextAlign.center,

                              style:
                                  const TextStyle(
                                fontSize: 17,
                                color: Colors.grey,
                              ),
                            ),
                          ),

                          const SizedBox(
                            height: 25,
                          ),

                          // =================================================
                          // LOCATION
                          // =================================================

                          _infoCard(
                            icon: Icons.location_on,
                            title: "Location",
                            value: location,
                          ),

                          // =================================================
                          // EXPERIENCE
                          // =================================================

                          _infoCard(
                            icon: Icons.work,
                            title: "Experience",
                            value: experience,
                          ),

                          // =================================================
                          // QUALIFICATION
                          // =================================================

                          _infoCard(
                            icon: Icons.school,
                            title: "Qualification",
                            value: qualification,
                          ),

                          // =================================================
                          // HOSPITAL
                          // =================================================

                          _infoCard(
                            icon: Icons.local_hospital,
                            title: "Hospital",
                            value: hospital,
                          ),

                          // =================================================
                          // EMAIL
                          // =================================================

                          _infoCard(
                            icon: Icons.email,
                            title: "Email",
                            value: email,
                          ),

                          // =================================================
                          // PHONE
                          // =================================================

                          _infoCard(
                            icon: Icons.phone,
                            title: "Phone",
                            value: phone,
                          ),

                          const SizedBox(
                            height: 20,
                          ),

                          // =================================================
                          // ABOUT DOCTOR
                          // =================================================

                          const Text(
                            "About Doctor",

                            style: TextStyle(
                              fontSize: 20,

                              fontWeight:
                                  FontWeight.bold,

                              color: primaryBlue,
                            ),
                          ),

                          const SizedBox(
                            height: 8,
                          ),

                          Text(
                            about.isEmpty
                                ? "No information available."
                                : about,

                            style:
                                const TextStyle(
                              fontSize: 15,

                              color:
                                  Colors.black87,

                              height: 1.5,
                            ),
                          ),

                          const SizedBox(
                            height: 30,
                          ),

                          // =================================================
                          // BOOK APPOINTMENT
                          // =================================================

                          SizedBox(
                            width: double.infinity,
                            height: 52,

                            child:
                                ElevatedButton.icon(
                              onPressed: () {
                                Navigator.push(
                                  context,

                                  MaterialPageRoute(
                                    builder:
                                        (context) =>
                                            AppointmentBook1(
                                      doctorId:
                                          doctorId,

                                      doctorName:
                                          name,

                                      specialization:
                                          doctorSpecialization,
                                    ),
                                  ),
                                );
                              },

                              icon: const Icon(
                                Icons.calendar_month,
                              ),

                              label: const Text(
                                "Book Appointment",

                                style:
                                    TextStyle(
                                  fontSize: 17,

                                  fontWeight:
                                      FontWeight.bold,
                                ),
                              ),

                              style:
                                  ElevatedButton
                                      .styleFrom(
                                backgroundColor:
                                    Colors.blueAccent,

                                foregroundColor:
                                    Colors.white,

                                shape:
                                    RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius
                                          .circular(
                                    12,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(
                            height: 10,
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
  // GET STRING FROM FIREBASE
  // =============================================================

  static String _getString(
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
  // INFORMATION CARD
  // =============================================================

  static Widget _infoCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      width: double.infinity,

      margin: const EdgeInsets.only(
        bottom: 12,
      ),

      padding: const EdgeInsets.all(14),

      decoration: BoxDecoration(
        color: Colors.blue.shade50,

        borderRadius:
            BorderRadius.circular(12),
      ),

      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.center,

        children: [

          // ===================================================
          // ICON
          // ===================================================

          Container(
            width: 42,
            height: 42,

            decoration: BoxDecoration(
              color: Colors.white,

              borderRadius:
                  BorderRadius.circular(10),
            ),

            child: Icon(
              icon,

              color: primaryBlue,

              size: 25,
            ),
          ),

          const SizedBox(
            width: 14,
          ),

          // ===================================================
          // TEXT
          // ===================================================

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [
                Text(
                  title,

                  style:
                      const TextStyle(
                    fontWeight:
                        FontWeight.bold,

                    color: Colors.grey,
                  ),
                ),

                const SizedBox(
                  height: 3,
                ),

                Text(
                  value.isEmpty
                      ? "Not available"
                      : value,

                  style:
                      const TextStyle(
                    fontSize: 15,

                    color:
                        Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

