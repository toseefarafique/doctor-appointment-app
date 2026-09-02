import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'admin_widgets.dart';

class DoctorApproval extends StatefulWidget {
  const DoctorApproval({super.key});

  @override
  State<DoctorApproval> createState() => _DoctorApprovalState();
}

class _DoctorApprovalState extends State<DoctorApproval> {
  String selectedTab = "Pending";
  String search = "";

  // ============================================================
  // SNACKBAR
  // ============================================================

  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
  GlobalKey<ScaffoldMessengerState>();

  // ============================================================
  // APPROVE DOCTOR
  // ============================================================

  Future<void> approveDoctor(
      String documentId,
      String doctorName,
      ) async {
    try {
      await FirebaseFirestore.instance
          .collection('doctors')
          .doc(documentId)
          .update({
        'status': 'Approved',
      });

      scaffoldMessengerKey.currentState?.hideCurrentSnackBar();

      scaffoldMessengerKey.currentState?.showSnackBar(
        SnackBar(
          content: Text(
            "$doctorName approved. Doctor can now login.",
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(15),
          duration: const Duration(seconds: 3),
        ),
      );
    } catch (e) {
      scaffoldMessengerKey.currentState?.showSnackBar(
        SnackBar(
          content: Text(
            "Error approving doctor: $e",
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(15),
        ),
      );
    }
  }

  // ============================================================
  // REJECT DOCTOR
  // ============================================================

  Future<void> rejectDoctor(
      String documentId,
      String doctorName,
      ) async {
    try {
      await FirebaseFirestore.instance
          .collection('doctors')
          .doc(documentId)
          .update({
        'status': 'Rejected',
      });

      scaffoldMessengerKey.currentState?.hideCurrentSnackBar();

      scaffoldMessengerKey.currentState?.showSnackBar(
        SnackBar(
          content: Text(
            "$doctorName rejected.",
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(15),
          duration: const Duration(seconds: 3),
        ),
      );
    } catch (e) {
      scaffoldMessengerKey.currentState?.showSnackBar(
        SnackBar(
          content: Text(
            "Error rejecting doctor: $e",
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(15),
        ),
      );
    }
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFF3F8),

      body: Center(
        child: Container(
          width: 600,
          height: 1100,

          clipBehavior: Clip.antiAlias,

          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),

          child: ScaffoldMessenger(
            key: scaffoldMessengerKey,

            child: Scaffold(
              backgroundColor: Colors.white,

              // ==================================================
              // APP BAR
              // ==================================================

              appBar: const MyAppBar(
                title: "Doctor Approval",
              ),

              // ==================================================
              // BODY
              // ==================================================

              body: Padding(
                padding: const EdgeInsets.all(20),

                child: Column(
                  children: [

                    // ==================================================
                    // SEARCH
                    // ==================================================

                    SearchBox(
                      hint: "Search doctors...",

                      onChanged: (value) {
                        setState(() {
                          search = value;
                        });
                      },
                    ),

                    const SizedBox(height: 15),

                    // ==================================================
                    // TABS
                    // ==================================================

                    Row(
                      children: [
                        tabButton("Pending"),
                        tabButton("Approved"),
                        tabButton("Rejected"),
                      ],
                    ),

                    const SizedBox(height: 10),

                    // ==================================================
                    // DOCTOR LIST
                    // ==================================================

                    Expanded(
                      child: StreamBuilder<
                          QuerySnapshot<Map<String, dynamic>>>(
                        stream: FirebaseFirestore.instance
                            .collection('doctors')
                            .snapshots(),

                        builder: (context, snapshot) {

                          // ==========================================
                          // LOADING
                          // ==========================================

                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(
                                color: appBlue,
                              ),
                            );
                          }

                          // ==========================================
                          // ERROR
                          // ==========================================

                          if (snapshot.hasError) {
                            return Center(
                              child: Text(
                                "Error loading doctors:\n${snapshot.error}",
                                textAlign: TextAlign.center,
                              ),
                            );
                          }

                          // ==========================================
                          // NO DATA
                          // ==========================================

                          if (!snapshot.hasData ||
                              snapshot.data!.docs.isEmpty) {
                            return const Center(
                              child: Text(
                                "No doctors found",
                              ),
                            );
                          }

                          // ==========================================
                          // FILTER DOCTORS
                          // ==========================================

                          final doctors = snapshot.data!.docs.where(
                                (document) {
                              final data = document.data();

                              final name =
                                  data['name']?.toString() ?? '';

                              final specialization =
                                  data['specialization']?.toString() ?? '';

                              final status =
                                  data['status']?.toString() ?? 'Pending';

                              final tabMatch =
                                  status == selectedTab;

                              final searchMatch =
                                  name.toLowerCase().contains(
                                    search.toLowerCase(),
                                  ) ||
                                      specialization.toLowerCase().contains(
                                        search.toLowerCase(),
                                      );

                              return tabMatch && searchMatch;
                            },
                          ).toList();

                          // ==========================================
                          // NO MATCH
                          // ==========================================

                          if (doctors.isEmpty) {
                            return const Center(
                              child: Text(
                                "No doctors found",
                              ),
                            );
                          }

                          // ==========================================
                          // LIST
                          // ==========================================

                          return ListView.builder(
                            itemCount: doctors.length,

                            itemBuilder: (_, index) {
                              final document = doctors[index];

                              final data = document.data();

                              final name =
                                  data['name']?.toString() ??
                                      'Unknown Doctor';

                              final specialization =
                                  data['specialization']?.toString() ??
                                      'Unknown';

                              final email =
                                  data['email']?.toString() ??
                                      '';

                              final image =
                                  data['image']?.toString() ??
                                      '';

                              final status =
                                  data['status']?.toString() ??
                                      'Pending';

                              // Create Doctor object for DoctorAvatar
                              final doctor = Doctor(
                                name: name,
                                specialization: specialization,
                                email: email,
                                image: image,
                                status: status,
                              );

                              return Card(
                                color: Colors.white,

                                margin: const EdgeInsets.only(
                                  bottom: 10,
                                ),

                                child: ListTile(
                                  contentPadding:
                                  const EdgeInsets.all(8),

                                  // ====================================
                                  // DOCTOR IMAGE
                                  // ====================================

                                  leading: DoctorAvatar(
                                    doctor: doctor,
                                  ),

                                  // ====================================
                                  // DOCTOR NAME
                                  // ====================================

                                  title: Text(
                                    name,

                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  // ====================================
                                  // SPECIALIZATION
                                  // ====================================

                                  subtitle: Text(
                                    specialization,
                                  ),

                                  // ====================================
                                  // BUTTONS / STATUS
                                  // ====================================

                                  trailing: selectedTab == "Pending"
                                      ? Row(
                                    mainAxisSize:
                                    MainAxisSize.min,

                                    children: [

                                      // ==========================
                                      // APPROVE
                                      // ==========================

                                      IconButton(
                                        onPressed: () {
                                          approveDoctor(
                                            document.id,
                                            name,
                                          );
                                        },

                                        icon: const Icon(
                                          Icons.check,
                                          color: Colors.green,
                                        ),
                                      ),

                                      // ==========================
                                      // REJECT
                                      // ==========================

                                      IconButton(
                                        onPressed: () {
                                          rejectDoctor(
                                            document.id,
                                            name,
                                          );
                                        },

                                        icon: const Icon(
                                          Icons.close,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ],
                                  )
                                      : StatusBadge(
                                    status: status,
                                  ),
                                ),
                              );
                            },
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

  // ============================================================
  // TAB BUTTON
  // ============================================================

  Widget tabButton(String name) {
    final active = selectedTab == name;

    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            selectedTab = name;
          });
        },

        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: 12,
          ),

          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: active
                    ? appBlue
                    : Colors.grey.shade300,

                width: active ? 3 : 1,
              ),
            ),
          ),

          child: Text(
            name,

            textAlign: TextAlign.center,

            style: TextStyle(
              color: active
                  ? appBlue
                  : Colors.grey,

              fontWeight: active
                  ? FontWeight.bold
                  : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}