import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../Patient/login_screen.dart';
import 'appointment.dart';
import 'doctor_profile.dart';
import 'schedule.dart';
import 'time_slots.dart';
import 'patient_details.dart';

class DoctorDashboard extends StatefulWidget {
  const DoctorDashboard({super.key});

  @override
  State<DoctorDashboard> createState() => _DoctorDashboardState();
}

class _DoctorDashboardState extends State<DoctorDashboard> {
  static const Color primaryBlue = Colors.blueAccent;

  // ============================================================
  // DOCTOR INFORMATION
  // ============================================================

  String doctorId = '';
  String doctorName = '';
  String specialization = '';
  String doctorImage = '';
  String doctorEmail = '';

  bool loadingDoctor = true;

  // ============================================================
  // INIT
  // ============================================================

  @override
  void initState() {
    super.initState();
    _loadDoctor();
  }

  // ============================================================
  // LOAD LOGGED-IN DOCTOR
  // ============================================================

  Future<void> _loadDoctor() async {
    try {
      final User? user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        if (!mounted) return;

        setState(() {
          doctorId = '';
          doctorName = 'Doctor';
          specialization = '';
          doctorImage = '';
          doctorEmail = '';
          loadingDoctor = false;
        });

        return;
      }

      final String uid = user.uid;

      debugPrint('======================================');
      debugPrint('LOGGED-IN DOCTOR');
      debugPrint('UID: $uid');
      debugPrint('Email: ${user.email}');
      debugPrint('======================================');

      // ==========================================================
      // GET DOCTOR DOCUMENT
      // ==========================================================

      final doctorDoc = await FirebaseFirestore.instance
          .collection('doctors')
          .doc(uid)
          .get();

      if (doctorDoc.exists) {
        final Map<String, dynamic> data =
            doctorDoc.data() ?? {};

        // ========================================================
        // DEBUG FIRESTORE DATA
        // ========================================================

        debugPrint('======================================');
        debugPrint('DOCTOR DOCUMENT FOUND');
        debugPrint('Doctor document ID: ${doctorDoc.id}');
        debugPrint('Doctor data: $data');
        debugPrint('Doctor name: ${data['name']}');
        debugPrint('Doctor specialization: ${data['specialization']}');
        debugPrint('Doctor image: ${data['image']}');
        debugPrint('Doctor email: ${data['email']}');
        debugPrint('======================================');

        if (!mounted) return;

        setState(() {
          doctorId = uid;

          doctorName =
          data['name']?.toString().trim().isNotEmpty == true
              ? data['name'].toString().trim()
              : 'Doctor';

          specialization =
              data['specialization']?.toString().trim() ?? '';

          doctorImage =
              data['image']?.toString().trim() ?? '';

          doctorEmail =
          data['email']?.toString().trim().isNotEmpty == true
              ? data['email'].toString().trim()
              : user.email ?? '';

          loadingDoctor = false;
        });

        // ========================================================
        // DEBUG FINAL VALUES
        // ========================================================

        debugPrint('======================================');
        debugPrint('FINAL DOCTOR VALUES');
        debugPrint('doctorId: $doctorId');
        debugPrint('doctorName: $doctorName');
        debugPrint('specialization: $specialization');
        debugPrint('doctorImage: $doctorImage');
        debugPrint('doctorEmail: $doctorEmail');
        debugPrint('======================================');
      } else {
        debugPrint(
          'Doctor document NOT FOUND for UID: $uid',
        );

        if (!mounted) return;

        setState(() {
          doctorId = uid;
          doctorName = 'Doctor';
          specialization = '';
          doctorImage = '';
          doctorEmail = user.email ?? '';
          loadingDoctor = false;
        });
      }
    } catch (e) {
      debugPrint('======================================');
      debugPrint('ERROR LOADING DOCTOR');
      debugPrint('$e');
      debugPrint('======================================');

      if (!mounted) return;

      setState(() {
        doctorId = '';
        doctorName = 'Doctor';
        specialization = '';
        doctorImage = '';
        doctorEmail = '';
        loadingDoctor = false;
      });
    }
  }

  // ============================================================
  // CHECK IMAGE TYPE
  // ============================================================

  bool _isNetworkImage(String image) {
    return image.startsWith('http://') ||
        image.startsWith('https://');
  }

  // ============================================================
  // DOCTOR IMAGE WIDGET
  // ============================================================

  Widget doctorImageWidget({
    double size = 76,
  }) {
    final String image = doctorImage.trim();

    // ----------------------------------------------------------
    // NO IMAGE
    // ----------------------------------------------------------

    if (image.isEmpty) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.person,
          size: 40,
          color: primaryBlue,
        ),
      );
    }

    // ----------------------------------------------------------
    // NETWORK IMAGE
    // ----------------------------------------------------------

    if (_isNetworkImage(image)) {
      return ClipOval(
        child: SizedBox(
          width: size,
          height: size,
          child: Image.network(
            image,
            width: size,
            height: size,
            fit: BoxFit.cover,
            errorBuilder: (
                context,
                error,
                stackTrace,
                ) {
              debugPrint(
                'NETWORK IMAGE ERROR: $error',
              );

              debugPrint(
                'NETWORK IMAGE URL: $image',
              );

              return Container(
                width: size,
                height: size,
                color: Colors.blue.shade50,
                child: const Icon(
                  Icons.person,
                  size: 40,
                  color: primaryBlue,
                ),
              );
            },
          ),
        ),
      );
    }

    // ----------------------------------------------------------
    // LOCAL ASSET IMAGE
    // ----------------------------------------------------------

    return ClipOval(
      child: SizedBox(
        width: size,
        height: size,
        child: Image.asset(
          image,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (
              context,
              error,
              stackTrace,
              ) {
            debugPrint(
              '======================================',
            );

            debugPrint(
              'ASSET IMAGE ERROR',
            );

            debugPrint(
              'Image path: $image',
            );

            debugPrint(
              'Error: $error',
            );

            debugPrint(
              '======================================',
            );

            return Container(
              width: size,
              height: size,
              color: Colors.blue.shade50,
              child: const Icon(
                Icons.person,
                size: 40,
                color: primaryBlue,
              ),
            );
          },
        ),
      ),
    );
  }

  // ============================================================
  // APPOINTMENTS STREAM
  // ============================================================

  Stream<QuerySnapshot<Map<String, dynamic>>>
  _appointmentStream() {
    final User? user =
        FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Stream.empty();
    }

    return FirebaseFirestore.instance
        .collection('appointments')
        .where(
      'doctorId',
      isEqualTo: user.uid,
    )
        .snapshots();
  }

  // ============================================================
  // GET PATIENT NAME
  // ============================================================

  String _getPatientName(
      Map<String, dynamic> data,
      ) {
    final String? patientName =
    data['patientName']?.toString();

    if (patientName != null &&
        patientName.trim().isNotEmpty) {
      return patientName.trim();
    }

    final String? patient =
    data['patient']?.toString();

    if (patient != null &&
        patient.trim().isNotEmpty) {
      return patient.trim();
    }

    final String? name =
    data['name']?.toString();

    if (name != null &&
        name.trim().isNotEmpty) {
      return name.trim();
    }

    return 'Unknown Patient';
  }

  // ============================================================
  // GET STATUS
  // ============================================================

  String _getStatus(
      Map<String, dynamic> data,
      ) {
    final String? status =
    data['status']?.toString();

    if (status != null &&
        status.trim().isNotEmpty) {
      return status.trim();
    }

    return 'Pending';
  }

  // ============================================================
  // GET DATE
  // ============================================================

  DateTime? _getDate(dynamic value) {
    if (value is Timestamp) {
      return value.toDate();
    }

    if (value is DateTime) {
      return value;
    }

    return null;
  }

  // ============================================================
  // GET APPOINTMENT DATE
  // ============================================================

  dynamic _getAppointmentDate(
      Map<String, dynamic> appointment,
      ) {
    return appointment['date'] ??
        appointment['appointmentDate'] ??
        appointment['bookingDate'];
  }

  // ============================================================
  // GET APPOINTMENT TIME
  // ============================================================

  dynamic _getAppointmentTime(
      Map<String, dynamic> appointment,
      ) {
    return appointment['time'] ??
        appointment['appointmentTime'];
  }

  // ============================================================
  // FORMAT DATE
  // ============================================================

  String _formatDate(dynamic value) {
    final DateTime? date =
    _getDate(value);

    if (date == null) {
      if (value != null &&
          value.toString().trim().isNotEmpty) {
        return value.toString();
      }

      return 'No date';
    }

    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    return '${date.day} '
        '${months[date.month - 1]} '
        '${date.year}';
  }

  // ============================================================
  // FORMAT TIME
  // ============================================================

  String _formatTime(dynamic value) {
    final DateTime? date =
    _getDate(value);

    if (date == null) {
      if (value != null &&
          value.toString().trim().isNotEmpty) {
        return value.toString();
      }

      return 'No time';
    }

    final int hour =
    date.hour > 12
        ? date.hour - 12
        : date.hour == 0
        ? 12
        : date.hour;

    final String minute =
    date.minute.toString().padLeft(
      2,
      '0',
    );

    final String period =
    date.hour >= 12 ? 'PM' : 'AM';

    return '$hour:$minute $period';
  }

  // ============================================================
  // CHECK TODAY
  // ============================================================

  bool _isToday(dynamic value) {
    final DateTime? date =
    _getDate(value);

    if (date == null) {
      return false;
    }

    final DateTime now =
    DateTime.now();

    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  // ============================================================
  // MOBILE FRAME
  // ============================================================

  Widget mobileFrame({
    required Widget child,
  }) {
    return Container(
      color: Colors.grey.shade300,
      alignment: Alignment.center,
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 600,
        ),
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: child,
        ),
      ),
    );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return mobileFrame(
      child: Scaffold(
        backgroundColor:
        Colors.grey.shade100,

        drawer: buildDrawer(),

        appBar: AppBar(
          backgroundColor:
          primaryBlue,
          foregroundColor:
          Colors.white,
          elevation: 0,

          title: const Text(
            'Doctor Dashboard',
            style: TextStyle(
              fontWeight:
              FontWeight.bold,
            ),
          ),

          centerTitle: true,

          actions: [
            IconButton(
              icon: const Icon(
                Icons.notifications_none,
              ),
              onPressed: () {},
            ),
          ],
        ),

        body: dashboardContent(),
      ),
    );
  }

  // ============================================================
  // DRAWER
  // ============================================================

  Widget buildDrawer() {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration:
            const BoxDecoration(
              color: primaryBlue,
            ),

            currentAccountPicture:
            CircleAvatar(
              backgroundColor:
              Colors.white,

              child: ClipOval(
                child: doctorImageWidget(
                  size: 58,
                ),
              ),
            ),

            accountName: Text(
              doctorName.isEmpty
                  ? 'Doctor'
                  : doctorName,

              style:
              const TextStyle(
                fontWeight:
                FontWeight.bold,
              ),
            ),

            accountEmail: Text(
              specialization.isEmpty
                  ? 'Doctor'
                  : specialization,
            ),
          ),

          // ======================================================
          // DASHBOARD
          // ======================================================

          ListTile(
            leading: const Icon(
              Icons.dashboard,
              color: Colors.blueAccent,
            ),

            title:
            const Text(
              'Dashboard',
            ),

            onTap: () {
              Navigator.pop(context);
            },
          ),

          // ======================================================
          // APPOINTMENTS
          // ======================================================

          ListTile(
            leading: const Icon(
              Icons.calendar_month,
              color: Colors.blueAccent,
            ),

            title:
            const Text(
              'Appointments',
            ),

            onTap: () {
              Navigator.pop(context);

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      DoctorAppointments(
                        doctorName:
                        doctorName,
                      ),
                ),
              );
            },
          ),

          // ======================================================
          // PROFILE
          // ======================================================

          ListTile(
            leading: const Icon(
              Icons.person,
              color: Colors.blueAccent,
            ),

            title:
            const Text(
              'Profile',
            ),

            onTap: () {
              Navigator.pop(context);

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      DoctorProfile(
                        doctorId:
                        doctorId,
                        doctorName:
                        doctorName,
                        specialization:
                        specialization,
                      ),
                ),
              );
            },
          ),

          // ======================================================
          // SCHEDULE
          // ======================================================

          ListTile(
            leading: const Icon(
              Icons.schedule,
              color: Colors.blueAccent,
            ),

            title:
            const Text(
              'Schedule',
            ),

            onTap: () {
              Navigator.pop(context);

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                  const DoctorSchedule(),
                ),
              );
            },
          ),

          // ======================================================
          // PATIENT DETAILS
          // ======================================================

          ListTile(
            leading: const Icon(
              Icons.people,
              color: Colors.blueAccent,
            ),

            title:
            const Text(
              'Patient Detail',
            ),

            onTap: () {
              Navigator.pop(context);

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                  const PatientDetails(),
                ),
              );
            },
          ),

          // ======================================================
          // TIME SLOTS
          // ======================================================

          ListTile(
            leading: const Icon(
              Icons.access_time,
              color: Colors.blueAccent,
            ),

            title:
            const Text(
              'Time Slots',
            ),

            onTap: () {
              Navigator.pop(context);

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                  const DoctorTimeSlots(),
                ),
              );
            },
          ),

          const Spacer(),

          const Divider(),

          // ======================================================
          // LOGOUT
          // ======================================================

          ListTile(
            leading: const Icon(
              Icons.logout,
              color: Colors.red,
            ),

            title:
            const Text(
              'Logout',
              style: TextStyle(
                color: Colors.red,
              ),
            ),

            onTap: () async {
              await FirebaseAuth
                  .instance
                  .signOut();

              if (!mounted) return;

              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                  const login_screen(),
                ),
                    (route) => false,
              );
            },
          ),

          const SizedBox(height: 15),
        ],
      ),
    );
  }

  // ============================================================
  // DASHBOARD CONTENT
  // ============================================================

  Widget dashboardContent() {
    if (loadingDoctor) {
      return const Center(
        child:
        CircularProgressIndicator(
          color: primaryBlue,
        ),
      );
    }

    // ============================================================
    // DOCTOR NOT FOUND
    // ============================================================

    if (doctorId.isEmpty) {
      return Center(
        child: Padding(
          padding:
          const EdgeInsets.all(25),

          child: Column(
            mainAxisAlignment:
            MainAxisAlignment.center,

            children: [
              const Icon(
                Icons.person_off,
                size: 60,
                color: Colors.grey,
              ),

              const SizedBox(
                height: 15,
              ),

              const Text(
                'Doctor profile was not found.',
                textAlign:
                TextAlign.center,

                style: TextStyle(
                  fontSize: 18,
                  fontWeight:
                  FontWeight.bold,
                ),
              ),

              const SizedBox(
                height: 8,
              ),

              const Text(
                'Make sure the doctor document ID '
                    'is the same as the Firebase Auth UID.',
                textAlign:
                TextAlign.center,

                style: TextStyle(
                  color: Colors.grey,
                ),
              ),

              const SizedBox(
                height: 20,
              ),

              ElevatedButton(
                onPressed:
                _loadDoctor,

                style:
                ElevatedButton.styleFrom(
                  backgroundColor:
                  primaryBlue,
                  foregroundColor:
                  Colors.white,
                ),

                child:
                const Text(
                  'Retry',
                ),
              ),
            ],
          ),
        ),
      );
    }

    // ============================================================
    // REAL-TIME APPOINTMENTS
    // ============================================================

    return StreamBuilder<
        QuerySnapshot<
            Map<String, dynamic>>>(
      stream:
      _appointmentStream(),

      builder:
          (context, snapshot) {
        if (snapshot.connectionState ==
            ConnectionState.waiting &&
            !snapshot.hasData) {
          return const Center(
            child:
            CircularProgressIndicator(
              color:
              primaryBlue,
            ),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding:
              const EdgeInsets.all(
                20,
              ),

              child: Text(
                'Error loading appointments:\n'
                    '${snapshot.error}',

                textAlign:
                TextAlign.center,

                style:
                const TextStyle(
                  color: Colors.red,
                ),
              ),
            ),
          );
        }

        final List<
            QueryDocumentSnapshot<
                Map<String, dynamic>>>
        documents =
            snapshot.data?.docs ?? [];

        final List<
            Map<String, dynamic>>
        appointments =
        documents.map((doc) {
          final Map<String, dynamic>
          data =
          doc.data();

          return <String, dynamic>{
            'id': doc.id,
            ...data,
          };
        }).toList();

        // ========================================================
        // TODAY'S APPOINTMENTS
        // ========================================================

        final List<
            Map<String, dynamic>>
        todayAppointments =
        appointments.where(
              (appointment) {
            final dynamic date =
            _getAppointmentDate(
              appointment,
            );

            return _isToday(date);
          },
        ).toList();

        // ========================================================
        // SORT TODAY'S APPOINTMENTS
        // ========================================================

        todayAppointments.sort(
              (a, b) {
            final DateTime? aDate =
            _getDate(
              _getAppointmentDate(a),
            );

            final DateTime? bDate =
            _getDate(
              _getAppointmentDate(b),
            );

            if (aDate == null &&
                bDate == null) {
              return 0;
            }

            if (aDate == null) {
              return 1;
            }

            if (bDate == null) {
              return -1;
            }

            return aDate.compareTo(
              bDate,
            );
          },
        );

        // ========================================================
        // PENDING APPOINTMENTS
        // ========================================================

        final List<
            Map<String, dynamic>>
        pendingAppointments =
        appointments.where(
              (appointment) {
            return _getStatus(
              appointment,
            ).toLowerCase() ==
                'pending';
          },
        ).toList();

        // ========================================================
        // UNIQUE PATIENTS
        // ========================================================

        final Set<String> patientIds =
        {};

        for (final appointment
        in appointments) {
          final String? patientId =
          appointment['patientId']
              ?.toString();

          if (patientId != null &&
              patientId.trim().isNotEmpty) {
            patientIds.add(
              patientId.trim(),
            );
          } else {
            final String patientName =
            _getPatientName(
              appointment,
            );

            if (patientName !=
                'Unknown Patient') {
              patientIds.add(
                patientName
                    .toLowerCase(),
              );
            }
          }
        }

        // ========================================================
        // RECENT APPOINTMENTS
        // ========================================================

        final List<
            Map<String, dynamic>>
        recentAppointments =
        List<
            Map<String, dynamic>>.from(
          appointments,
        );

        recentAppointments.sort(
              (a, b) {
            final DateTime? aDate =
            _getDate(
              a['createdAt'] ??
                  a['date'] ??
                  a['appointmentDate'] ??
                  a['bookingDate'],
            );

            final DateTime? bDate =
            _getDate(
              b['createdAt'] ??
                  b['date'] ??
                  b['appointmentDate'] ??
                  b['bookingDate'],
            );

            if (aDate == null &&
                bDate == null) {
              return 0;
            }

            if (aDate == null) {
              return 1;
            }

            if (bDate == null) {
              return -1;
            }

            return bDate.compareTo(
              aDate,
            );
          },
        );

        final List<
            Map<String, dynamic>>
        displayRecent =
        recentAppointments
            .take(5)
            .toList();

        // ========================================================
        // DASHBOARD UI
        // ========================================================

        return RefreshIndicator(
          color: primaryBlue,

          onRefresh:
          _loadDoctor,

          child:
          SingleChildScrollView(
            physics:
            const AlwaysScrollableScrollPhysics(),

            padding:
            const EdgeInsets.all(
              16,
            ),

            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [
                // ==================================================
                // DOCTOR INFORMATION
                // ==================================================

                doctorInfoCard(),

                const SizedBox(
                  height: 18,
                ),

                // ==================================================
                // TODAY'S APPOINTMENTS
                // ==================================================

                todayAppointmentsCard(
                  todayAppointments,
                ),

                const SizedBox(
                  height: 18,
                ),

                // ==================================================
                // STAT CARDS
                // ==================================================

                Row(
                  children: [
                    Expanded(
                      child:
                      statCard(
                        icon: Icons
                            .calendar_month,
                        title:
                        'Appointments',
                        value:
                        appointments
                            .length
                            .toString(),
                      ),
                    ),

                    const SizedBox(
                      width: 10,
                    ),

                    Expanded(
                      child:
                      statCard(
                        icon: Icons
                            .pending_actions,
                        title:
                        'Pending',
                        value:
                        pendingAppointments
                            .length
                            .toString(),
                      ),
                    ),

                    const SizedBox(
                      width: 10,
                    ),

                    Expanded(
                      child:
                      statCard(
                        icon:
                        Icons.people,
                        title:
                        'Patients',
                        value:
                        patientIds
                            .length
                            .toString(),
                      ),
                    ),
                  ],
                ),

                const SizedBox(
                  height: 24,
                ),

                const Text(
                  'Recent Appointments',

                  style: TextStyle(
                    fontSize: 19,
                    fontWeight:
                    FontWeight.bold,
                  ),
                ),

                const SizedBox(
                  height: 12,
                ),

                if (displayRecent
                    .isEmpty)
                  emptyRecentAppointments()
                else
                  ...displayRecent.map(
                    recentAppointmentCard,
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ============================================================
  // DOCTOR INFORMATION CARD
  // ============================================================

  Widget doctorInfoCard() {
    return Container(
      width: double.infinity,

      padding:
      const EdgeInsets.all(18),

      decoration:
      BoxDecoration(
        color: Colors.white,

        borderRadius:
        BorderRadius.circular(
          18,
        ),

        boxShadow: [
          BoxShadow(
            color:
            Colors.black.withValues(
              alpha: 0.07,
            ),

            blurRadius: 10,

            offset:
            const Offset(0, 4),
          ),
        ],
      ),

      child: Row(
        children: [
          // ========================================================
          // DOCTOR IMAGE
          // ========================================================

          doctorImageWidget(
            size: 76,
          ),

          const SizedBox(
            width: 15,
          ),

          // ========================================================
          // DOCTOR DETAILS
          // ========================================================

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [
                Text(
                  doctorName.isEmpty
                      ? 'Doctor'
                      : doctorName,

                  style:
                  const TextStyle(
                    fontSize: 20,
                    fontWeight:
                    FontWeight.bold,
                  ),
                ),

                const SizedBox(
                  height: 5,
                ),

                Text(
                  specialization.isEmpty
                      ? 'Specialization'
                      : specialization,

                  style:
                  const TextStyle(
                    color:
                    primaryBlue,
                    fontSize: 15,
                    fontWeight:
                    FontWeight.w600,
                  ),
                ),

                if (doctorEmail
                    .trim()
                    .isNotEmpty) ...[
                  const SizedBox(
                    height: 5,
                  ),

                  Text(
                    doctorEmail,

                    maxLines: 1,

                    overflow:
                    TextOverflow.ellipsis,

                    style: TextStyle(
                      color:
                      Colors.grey.shade600,
                      fontSize: 12,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // TODAY'S APPOINTMENTS CARD
  // ============================================================

  Widget todayAppointmentsCard(
      List<Map<String, dynamic>>
      todayAppointments,
      ) {
    final int count =
        todayAppointments.length;

    return Container(
      width: double.infinity,

      padding:
      const EdgeInsets.all(18),

      decoration:
      BoxDecoration(
        color: primaryBlue,

        borderRadius:
        BorderRadius.circular(
          18,
        ),

        boxShadow: [
          BoxShadow(
            color:
            primaryBlue.withValues(
              alpha: 0.25,
            ),

            blurRadius: 10,

            offset:
            const Offset(0, 4),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [
          Row(
            children: [
              Container(
                width: 50,
                height: 50,

                decoration:
                BoxDecoration(
                  color:
                  Colors.white.withValues(
                    alpha: 0.18,
                  ),

                  borderRadius:
                  BorderRadius.circular(
                    14,
                  ),
                ),

                child: const Icon(
                  Icons.today,
                  color: Colors.white,
                  size: 28,
                ),
              ),

              const SizedBox(
                width: 14,
              ),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,

                  children: [
                    const Text(
                      "Today's Appointments",

                      style:
                      TextStyle(
                        color:
                        Colors.white,
                        fontSize: 17,
                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),

                    const SizedBox(
                      height: 5,
                    ),

                    Text(
                      count == 1
                          ? 'You have 1 appointment today'
                          : 'You have $count appointments today',

                      style: TextStyle(
                        color:
                        Colors.white
                            .withValues(
                          alpha: 0.9,
                        ),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),

              Text(
                count.toString(),

                style:
                const TextStyle(
                  color:
                  Colors.white,
                  fontSize: 28,
                  fontWeight:
                  FontWeight.bold,
                ),
              ),
            ],
          ),

          if (todayAppointments
              .isNotEmpty) ...[
            const SizedBox(
              height: 16,
            ),

            Container(
              decoration:
              BoxDecoration(
                color:
                Colors.white
                    .withValues(
                  alpha: 0.12,
                ),

                borderRadius:
                BorderRadius.circular(
                  14,
                ),
              ),

              child: Column(
                children:
                todayAppointments
                    .take(5)
                    .map(
                  todayAppointmentItem,
                )
                    .toList(),
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ============================================================
  // TODAY APPOINTMENT ITEM
  // ============================================================

  Widget todayAppointmentItem(
      Map<String, dynamic>
      appointment,
      ) {
    final String patientName =
    _getPatientName(
      appointment,
    );

    final String status =
    _getStatus(
      appointment,
    );

    final dynamic timeValue =
    _getAppointmentTime(
      appointment,
    );

    return Container(
      padding:
      const EdgeInsets.all(12),

      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,

            decoration:
            const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),

            child: const Icon(
              Icons.person,
              color: primaryBlue,
              size: 23,
            ),
          ),

          const SizedBox(
            width: 10,
          ),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [
                Text(
                  patientName,

                  maxLines: 1,

                  overflow:
                  TextOverflow.ellipsis,

                  style:
                  const TextStyle(
                    color:
                    Colors.white,
                    fontSize: 14,
                    fontWeight:
                    FontWeight.bold,
                  ),
                ),

                const SizedBox(
                  height: 3,
                ),

                Text(
                  _formatTime(
                    timeValue,
                  ),

                  style: TextStyle(
                    color:
                    Colors.white
                        .withValues(
                      alpha: 0.85,
                    ),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          _todayStatusBadge(
            status,
          ),
        ],
      ),
    );
  }

  // ============================================================
  // TODAY STATUS BADGE
  // ============================================================

  Widget _todayStatusBadge(
      String status,
      ) {
    Color backgroundColor;
    Color textColor;

    switch (
    status.toLowerCase()) {
      case 'confirmed':
      case 'approved':
        backgroundColor =
            Colors.green.shade100;
        textColor =
            Colors.green.shade700;
        break;

      case 'pending':
        backgroundColor =
            Colors.orange.shade100;
        textColor =
            Colors.orange.shade700;
        break;

      case 'completed':
        backgroundColor =
            Colors.green.shade100;
        textColor =
            Colors.green.shade700;
        break;

      case 'cancelled':
      case 'canceled':
      case 'rejected':
        backgroundColor =
            Colors.red.shade100;
        textColor =
            Colors.red.shade700;
        break;

      default:
        backgroundColor =
            Colors.grey.shade200;
        textColor =
            Colors.grey.shade700;
    }

    return Container(
      padding:
      const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 5,
      ),

      decoration:
      BoxDecoration(
        color: backgroundColor,

        borderRadius:
        BorderRadius.circular(
          20,
        ),
      ),

      child: Text(
        status,

        style:
        TextStyle(
          color: textColor,
          fontSize: 9,
          fontWeight:
          FontWeight.bold,
        ),
      ),
    );
  }

  // ============================================================
  // STAT CARD
  // ============================================================

  Widget statCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      padding:
      const EdgeInsets.symmetric(
        vertical: 16,
        horizontal: 8,
      ),

      decoration:
      BoxDecoration(
        color: Colors.white,

        borderRadius:
        BorderRadius.circular(
          16,
        ),

        boxShadow: [
          BoxShadow(
            color:
            Colors.black.withValues(
              alpha: 0.06,
            ),

            blurRadius: 8,

            offset:
            const Offset(0, 3),
          ),
        ],
      ),

      child: Column(
        children: [
          Icon(
            icon,
            color: primaryBlue,
            size: 27,
          ),

          const SizedBox(
            height: 8,
          ),

          Text(
            value,

            style:
            const TextStyle(
              fontSize: 22,
              fontWeight:
              FontWeight.bold,
              color: primaryBlue,
            ),
          ),

          const SizedBox(
            height: 3,
          ),

          Text(
            title,

            textAlign:
            TextAlign.center,

            style: TextStyle(
              fontSize: 11,
              color:
              Colors.grey.shade600,
              fontWeight:
              FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // RECENT APPOINTMENT CARD
  // ============================================================

  Widget recentAppointmentCard(
      Map<String, dynamic>
      appointment,
      ) {
    final String patientName =
    _getPatientName(
      appointment,
    );

    final String status =
    _getStatus(
      appointment,
    );

    final dynamic dateValue =
    _getAppointmentDate(
      appointment,
    );

    final dynamic timeValue =
    _getAppointmentTime(
      appointment,
    );

    return Container(
      margin:
      const EdgeInsets.only(
        bottom: 12,
      ),

      padding:
      const EdgeInsets.all(14),

      decoration:
      BoxDecoration(
        color: Colors.white,

        borderRadius:
        BorderRadius.circular(
          16,
        ),

        boxShadow: [
          BoxShadow(
            color:
            Colors.black.withValues(
              alpha: 0.06,
            ),

            blurRadius: 8,

            offset:
            const Offset(0, 3),
          ),
        ],
      ),

      child: Row(
        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [
          Container(
            width: 48,
            height: 48,

            decoration:
            BoxDecoration(
              color:
              Colors.blueAccent
                  .withValues(
                alpha: 0.10,
              ),

              shape: BoxShape.circle,
            ),

            child: const Icon(
              Icons.person,
              color: primaryBlue,
              size: 27,
            ),
          ),

          const SizedBox(
            width: 12,
          ),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [
                Text(
                  patientName,

                  maxLines: 1,

                  overflow:
                  TextOverflow.ellipsis,

                  style:
                  const TextStyle(
                    fontSize: 16,
                    fontWeight:
                    FontWeight.bold,
                  ),
                ),

                const SizedBox(
                  height: 5,
                ),

                Text(
                  _formatDate(
                    dateValue,
                  ),

                  style: TextStyle(
                    color:
                    Colors.grey.shade600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          Column(
            crossAxisAlignment:
            CrossAxisAlignment.end,

            children: [
              _statusBadge(
                status,
              ),

              const SizedBox(
                height: 7,
              ),

              Text(
                _formatTime(
                  timeValue,
                ),

                style: TextStyle(
                  color:
                  Colors.grey.shade700,
                  fontSize: 12,
                  fontWeight:
                  FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ============================================================
  // STATUS BADGE
  // ============================================================

  Widget _statusBadge(
      String status,
      ) {
    Color backgroundColor;
    Color textColor;

    switch (
    status.toLowerCase()) {
      case 'confirmed':
      case 'approved':
        backgroundColor =
            Colors.green.shade100;
        textColor =
            Colors.green.shade700;
        break;

      case 'pending':
        backgroundColor =
            Colors.orange.shade100;
        textColor =
            Colors.orange.shade700;
        break;

      case 'completed':
        backgroundColor =
            Colors.green.shade100;
        textColor =
            Colors.green.shade700;
        break;

      case 'cancelled':
      case 'canceled':
      case 'rejected':
        backgroundColor =
            Colors.red.shade100;
        textColor =
            Colors.red.shade700;
        break;

      default:
        backgroundColor =
            Colors.grey.shade200;
        textColor =
            Colors.grey.shade700;
    }

    return Container(
      padding:
      const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 5,
      ),

      decoration:
      BoxDecoration(
        color: backgroundColor,

        borderRadius:
        BorderRadius.circular(
          20,
        ),
      ),

      child: Text(
        status,

        style:
        TextStyle(
          color: textColor,
          fontSize: 10,
          fontWeight:
          FontWeight.bold,
        ),
      ),
    );
  }

  // ============================================================
  // EMPTY APPOINTMENTS
  // ============================================================

  Widget emptyRecentAppointments() {
    return Container(
      width: double.infinity,

      padding:
      const EdgeInsets.all(25),

      decoration:
      BoxDecoration(
        color: Colors.white,

        borderRadius:
        BorderRadius.circular(
          16,
        ),
      ),

      child: Column(
        children: [
          Icon(
            Icons
                .calendar_month_outlined,
            size: 50,
            color:
            Colors.grey.shade400,
          ),

          const SizedBox(
            height: 10,
          ),

          Text(
            'No appointments found',

            style: TextStyle(
              color:
              Colors.grey.shade600,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}