import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'admin_widgets.dart';

class ManageAppointments extends StatefulWidget {
  const ManageAppointments({super.key});

  @override
  State<ManageAppointments> createState() =>
      _ManageAppointmentsState();
}

class _ManageAppointmentsState
    extends State<ManageAppointments> {
  String search = "";

  // SnackBar key for mobile frame
  final GlobalKey<ScaffoldMessengerState>
  scaffoldMessengerKey =
  GlobalKey<ScaffoldMessengerState>();

  // =========================
  // SHOW SNACKBAR
  // =========================

  void showMessage(
      String message, {
        bool isError = false,
      }) {
    scaffoldMessengerKey.currentState
        ?.hideCurrentSnackBar();

    scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(
          message,
          textAlign: TextAlign.center,
        ),
        backgroundColor:
        isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // =========================
  // ADD APPOINTMENT
  // =========================

  void addAppointment() {
    showDialog(
      context: context,
      builder: (_) {
        return AddAppointmentDialog(
          onSuccess: () {
            showMessage(
              "Appointment added successfully",
            );
          },
          onError: (message) {
            showMessage(
              message,
              isError: true,
            );
          },
        );
      },
    );
  }

  // =========================
  // EDIT APPOINTMENT
  // =========================

  void editAppointment(
      String documentId,
      String currentPatient,
      String currentDoctor,
      String currentTime,
      String currentStatus,
      ) {
    showDialog(
      context: context,
      builder: (_) {
        return EditAppointmentDialog(
          documentId: documentId,
          currentPatient: currentPatient,
          currentDoctor: currentDoctor,
          currentTime: currentTime,
          currentStatus: currentStatus,
          onSuccess: () {
            showMessage(
              "Appointment updated successfully",
            );
          },
          onError: (message) {
            showMessage(
              message,
              isError: true,
            );
          },
        );
      },
    );
  }

  // =========================
  // DELETE APPOINTMENT
  // =========================

  Future<void> deleteAppointment(
      String documentId,
      ) async {
    try {
      await FirebaseFirestore.instance
          .collection("appointments")
          .doc(documentId)
          .delete();

      if (mounted) {
        showMessage(
          "Appointment deleted successfully",
        );
      }
    } catch (e) {
      if (mounted) {
        showMessage(
          "Error deleting appointment",
          isError: true,
        );
      }
    }
  }

  // =========================
  // DELETE CONFIRMATION
  // =========================

  void confirmDelete(
      String documentId,
      String patientName,
      ) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text(
            "Delete Appointment",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            "Are you sure you want to delete the appointment for $patientName?",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () async {
                Navigator.pop(context);

                await deleteAppointment(
                  documentId,
                );
              },
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );
  }

  // =========================
  // CHANGE STATUS
  // =========================

  Future<void> changeStatus(
      String documentId,
      String status,
      ) async {
    try {
      await FirebaseFirestore.instance
          .collection("appointments")
          .doc(documentId)
          .update({
        "status": status,
      });

      if (mounted) {
        showMessage(
          "Appointment status changed to $status",
        );
      }
    } catch (e) {
      if (mounted) {
        showMessage(
          "Error changing status",
          isError: true,
        );
      }
    }
  }

  // =========================
  // BUILD
  // =========================

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

              appBar: const MyAppBar(
                title: "Manage Appointments",
              ),

              body: Padding(
                padding: const EdgeInsets.all(20),

                child: Column(
                  children: [
                    // SEARCH
                    SearchBox(
                      hint: "Search appointments...",
                      onChanged: (value) {
                        setState(() {
                          search = value;
                        });
                      },
                    ),

                    const SizedBox(height: 15),

                    // APPOINTMENT LIST
                    Expanded(
                      child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection("appointments")
                            .snapshots(),

                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child:
                              CircularProgressIndicator(
                                color:
                                Colors.blueAccent,
                              ),
                            );
                          }

                          if (snapshot.hasError) {
                            return Center(
                              child: Text(
                                "Error: ${snapshot.error}",
                              ),
                            );
                          }

                          if (!snapshot.hasData ||
                              snapshot.data!.docs.isEmpty) {
                            return const Center(
                              child: Text(
                                "No appointments found",
                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                            );
                          }

                          // SEARCH FILTER
                          final appointments =
                          snapshot.data!.docs
                              .where((doc) {
                            final data =
                            doc.data()
                            as Map<String, dynamic>;

                            final patient =
                            (data["patient"] ?? "")
                                .toString()
                                .toLowerCase();

                            final doctor =
                            (data["doctor"] ?? "")
                                .toString()
                                .toLowerCase();

                            final searchText =
                            search.toLowerCase();

                            return patient
                                .contains(searchText) ||
                                doctor
                                    .contains(searchText);
                          }).toList();

                          if (appointments.isEmpty) {
                            return const Center(
                              child: Text(
                                "No appointments found",
                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                            );
                          }

                          return ListView.builder(
                            itemCount:
                            appointments.length,

                            itemBuilder: (_, index) {
                              final document =
                              appointments[index];

                              final data =
                              document.data()
                              as Map<String, dynamic>;

                              final patient =
                              (data["patient"] ??
                                  "Unknown Patient")
                                  .toString();

                              final doctor =
                              (data["doctor"] ??
                                  "Unknown Doctor")
                                  .toString();

                              final time =
                              (data["time"] ??
                                  "No time")
                                  .toString();

                              final status =
                              (data["status"] ??
                                  "Pending")
                                  .toString();

                              return Card(
                                color: Colors.white,

                                margin:
                                const EdgeInsets.only(
                                  bottom: 10,
                                ),

                                child: ListTile(
                                  leading:
                                  const PatientAvatar(),

                                  title: Text(
                                    patient,
                                    style:
                                    const TextStyle(
                                      fontWeight:
                                      FontWeight.bold,
                                    ),
                                  ),

                                  subtitle: Text(
                                    "$doctor\n$time",
                                  ),

                                  isThreeLine: true,

                                  trailing: Row(
                                    mainAxisSize:
                                    MainAxisSize.min,
                                    children: [
                                      StatusBadge(
                                        status: status,
                                      ),

                                      PopupMenuButton<
                                          String>(
                                        icon:
                                        const Icon(
                                          Icons.more_vert,
                                          color: Colors
                                              .blueAccent,
                                        ),

                                        itemBuilder: (_) {
                                          return const [
                                            PopupMenuItem<
                                                String>(
                                              value: "edit",
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.edit,
                                                    color: Colors
                                                        .blueAccent,
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text(
                                                    "Edit",
                                                  ),
                                                ],
                                              ),
                                            ),

                                            PopupMenuItem<
                                                String>(
                                              value:
                                              "confirm",
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.check_circle,
                                                    color: Colors
                                                        .green,
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text(
                                                    "Confirm",
                                                  ),
                                                ],
                                              ),
                                            ),

                                            PopupMenuItem<
                                                String>(
                                              value:
                                              "complete",
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.done_all,
                                                    color: Colors
                                                        .green,
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text(
                                                    "Complete",
                                                  ),
                                                ],
                                              ),
                                            ),

                                            PopupMenuItem<
                                                String>(
                                              value:
                                              "cancel",
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.cancel,
                                                    color: Colors
                                                        .red,
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text(
                                                    "Cancel",
                                                  ),
                                                ],
                                              ),
                                            ),

                                            PopupMenuItem<
                                                String>(
                                              value:
                                              "delete",
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.delete,
                                                    color: Colors
                                                        .red,
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text(
                                                    "Delete",
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ];
                                        },

                                        onSelected:
                                            (value) {
                                          if (value ==
                                              "edit") {
                                            editAppointment(
                                              document.id,
                                              patient,
                                              doctor,
                                              time,
                                              status,
                                            );
                                          }

                                          if (value ==
                                              "confirm") {
                                            changeStatus(
                                              document.id,
                                              "Confirmed",
                                            );
                                          }

                                          if (value ==
                                              "complete") {
                                            changeStatus(
                                              document.id,
                                              "Completed",
                                            );
                                          }

                                          if (value ==
                                              "cancel") {
                                            changeStatus(
                                              document.id,
                                              "Cancelled",
                                            );
                                          }

                                          if (value ==
                                              "delete") {
                                            confirmDelete(
                                              document.id,
                                              patient,
                                            );
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 10),

                    // ADD BUTTON
                    SizedBox(
                      width: double.infinity,

                      child: ElevatedButton.icon(
                        onPressed:
                        addAppointment,

                        style:
                        ElevatedButton.styleFrom(
                          backgroundColor:
                          Colors.blueAccent,
                          foregroundColor:
                          Colors.white,
                          padding:
                          const EdgeInsets.symmetric(
                            vertical: 14,
                          ),
                        ),

                        icon: const Icon(
                          Icons.add,
                        ),

                        label: const Text(
                          "Add New Appointment",
                        ),
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
}

// ==========================================================================
// ADD APPOINTMENT DIALOG
// ==========================================================================

class AddAppointmentDialog
    extends StatefulWidget {
  final VoidCallback onSuccess;
  final Function(String) onError;

  const AddAppointmentDialog({
    super.key,
    required this.onSuccess,
    required this.onError,
  });

  @override
  State<AddAppointmentDialog> createState() =>
      _AddAppointmentDialogState();
}

class _AddAppointmentDialogState
    extends State<AddAppointmentDialog> {
  final patient =
  TextEditingController();

  final doctor =
  TextEditingController();

  final time =
  TextEditingController();

  String selectedStatus = "Pending";

  @override
  void dispose() {
    patient.dispose();
    doctor.dispose();
    time.dispose();
    super.dispose();
  }

  // =========================
  // SAVE APPOINTMENT
  // =========================

  Future<void> saveAppointment() async {
    final patientName =
    patient.text.trim();

    final doctorName =
    doctor.text.trim();

    final appointmentTime =
    time.text.trim();

    if (patientName.isEmpty ||
        doctorName.isEmpty ||
        appointmentTime.isEmpty) {
      widget.onError(
        "Please enter all appointment information",
      );
      return;
    }

    try {
      await FirebaseFirestore.instance
          .collection("appointments")
          .add({
        "patient": patientName,
        "doctor": doctorName,
        "time": appointmentTime,
        "status": selectedStatus,
        "createdAt":
        FieldValue.serverTimestamp(),
      });

      if (mounted) {
        Navigator.pop(context);
        widget.onSuccess();
      }
    } catch (e) {
      widget.onError(
        "Error adding appointment",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        "Add Appointment",
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),

      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: patient,
              decoration:
              const InputDecoration(
                labelText: "Patient Name",
                border:
                OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: doctor,
              decoration:
              const InputDecoration(
                labelText: "Doctor Name",
                border:
                OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: time,
              decoration:
              const InputDecoration(
                labelText: "Appointment Time",
                hintText: "e.g. 10:00 AM",
                border:
                OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            DropdownButtonFormField<String>(
              value: selectedStatus,

              decoration:
              const InputDecoration(
                labelText: "Status",
                border:
                OutlineInputBorder(),
              ),

              items: const [
                DropdownMenuItem(
                  value: "Pending",
                  child: Text("Pending"),
                ),
                DropdownMenuItem(
                  value: "Confirmed",
                  child: Text("Confirmed"),
                ),
                DropdownMenuItem(
                  value: "Completed",
                  child: Text("Completed"),
                ),
                DropdownMenuItem(
                  value: "Cancelled",
                  child: Text("Cancelled"),
                ),
              ],

              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    selectedStatus =
                        value;
                  });
                }
              },
            ),
          ],
        ),
      ),

      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("Cancel"),
        ),

        ElevatedButton(
          onPressed:
          saveAppointment,

          style:
          ElevatedButton.styleFrom(
            backgroundColor:
            Colors.blueAccent,
            foregroundColor:
            Colors.white,
          ),

          child: const Text("Add"),
        ),
      ],
    );
  }
}

// ==========================================================================
// EDIT APPOINTMENT DIALOG
// ==========================================================================

class EditAppointmentDialog
    extends StatefulWidget {
  final String documentId;
  final String currentPatient;
  final String currentDoctor;
  final String currentTime;
  final String currentStatus;

  final VoidCallback onSuccess;
  final Function(String) onError;

  const EditAppointmentDialog({
    super.key,
    required this.documentId,
    required this.currentPatient,
    required this.currentDoctor,
    required this.currentTime,
    required this.currentStatus,
    required this.onSuccess,
    required this.onError,
  });

  @override
  State<EditAppointmentDialog> createState() =>
      _EditAppointmentDialogState();
}

class _EditAppointmentDialogState
    extends State<EditAppointmentDialog> {
  late TextEditingController patient;
  late TextEditingController doctor;
  late TextEditingController time;

  late String selectedStatus;

  @override
  void initState() {
    super.initState();

    patient =
        TextEditingController(
          text: widget.currentPatient,
        );

    doctor =
        TextEditingController(
          text: widget.currentDoctor,
        );

    time =
        TextEditingController(
          text: widget.currentTime,
        );

    selectedStatus =
        widget.currentStatus;
  }

  @override
  void dispose() {
    patient.dispose();
    doctor.dispose();
    time.dispose();
    super.dispose();
  }

  // =========================
  // UPDATE APPOINTMENT
  // =========================

  Future<void> updateAppointment() async {
    final patientName =
    patient.text.trim();

    final doctorName =
    doctor.text.trim();

    final appointmentTime =
    time.text.trim();

    if (patientName.isEmpty ||
        doctorName.isEmpty ||
        appointmentTime.isEmpty) {
      widget.onError(
        "Please enter all appointment information",
      );
      return;
    }

    try {
      await FirebaseFirestore.instance
          .collection("appointments")
          .doc(widget.documentId)
          .update({
        "patient": patientName,
        "doctor": doctorName,
        "time": appointmentTime,
        "status": selectedStatus,
      });

      if (mounted) {
        Navigator.pop(context);
        widget.onSuccess();
      }
    } catch (e) {
      widget.onError(
        "Error updating appointment",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        "Edit Appointment",
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),

      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: patient,
              decoration:
              const InputDecoration(
                labelText: "Patient Name",
                border:
                OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: doctor,
              decoration:
              const InputDecoration(
                labelText: "Doctor Name",
                border:
                OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: time,
              decoration:
              const InputDecoration(
                labelText: "Appointment Time",
                border:
                OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            DropdownButtonFormField<String>(
              value: selectedStatus,

              decoration:
              const InputDecoration(
                labelText: "Status",
                border:
                OutlineInputBorder(),
              ),

              items: const [
                DropdownMenuItem(
                  value: "Pending",
                  child: Text("Pending"),
                ),
                DropdownMenuItem(
                  value: "Confirmed",
                  child: Text("Confirmed"),
                ),
                DropdownMenuItem(
                  value: "Completed",
                  child: Text("Completed"),
                ),
                DropdownMenuItem(
                  value: "Cancelled",
                  child: Text("Cancelled"),
                ),
              ],

              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    selectedStatus =
                        value;
                  });
                }
              },
            ),
          ],
        ),
      ),

      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("Cancel"),
        ),

        ElevatedButton(
          onPressed:
          updateAppointment,

          style:
          ElevatedButton.styleFrom(
            backgroundColor:
            Colors.blueAccent,
            foregroundColor:
            Colors.white,
          ),

          child: const Text("Update"),
        ),
      ],
    );
  }
}