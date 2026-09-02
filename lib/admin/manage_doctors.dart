import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'admin_widgets.dart';

class ManageDoctors extends StatefulWidget {
  const ManageDoctors({super.key});

  @override
  State<ManageDoctors> createState() => _ManageDoctorsState();
}

class _ManageDoctorsState extends State<ManageDoctors> {
  String search = "";

  // SnackBar key for mobile frame
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
  GlobalKey<ScaffoldMessengerState>();

  // =========================
  // SHOW SNACKBAR
  // =========================

  void showMessage(
      String message, {
        bool isError = false,
      }) {
    scaffoldMessengerKey.currentState?.hideCurrentSnackBar();

    scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(
          message,
          textAlign: TextAlign.center,
        ),
        backgroundColor: isError ? Colors.red : Colors.green,
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
  // ADD DOCTOR
  // =========================

  void addDoctor() {
    showDialog(
      context: context,
      builder: (_) {
        return AddDoctorDialog(
          onSuccess: () {
            showMessage("Doctor added successfully");
          },
          onError: (message) {
            showMessage(message, isError: true);
          },
        );
      },
    );
  }

  // =========================
  // EDIT DOCTOR
  // =========================

  void editDoctor(
      String documentId,
      String currentName,
      String currentSpecialization,
      String currentEmail,
      String currentImage,
      String currentStatus,
      ) {
    showDialog(
      context: context,
      builder: (_) {
        return EditDoctorDialog(
          documentId: documentId,
          currentName: currentName,
          currentSpecialization: currentSpecialization,
          currentEmail: currentEmail,
          currentImage: currentImage,
          currentStatus: currentStatus,
          onSuccess: () {
            showMessage("Doctor updated successfully");
          },
          onError: (message) {
            showMessage(message, isError: true);
          },
        );
      },
    );
  }

  // =========================
  // DELETE DOCTOR
  // =========================

  Future<void> deleteDoctor(String documentId) async {
    try {
      await FirebaseFirestore.instance
          .collection("doctors")
          .doc(documentId)
          .delete();

      if (mounted) {
        showMessage("Doctor deleted successfully");
      }
    } catch (e) {
      if (mounted) {
        showMessage(
          "Error deleting doctor",
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
      String doctorName,
      ) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text(
            "Delete Doctor",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            "Are you sure you want to delete $doctorName?",
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
                await deleteDoctor(documentId);
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
          .collection("doctors")
          .doc(documentId)
          .update({
        "status": status,
      });

      if (mounted) {
        showMessage(
          "Doctor status changed to $status",
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
                title: "Manage Doctors",
              ),

              body: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // =========================
                    // SEARCH
                    // =========================

                    SearchBox(
                      hint: "Search doctors...",
                      onChanged: (value) {
                        setState(() {
                          search = value;
                        });
                      },
                    ),

                    const SizedBox(height: 10),

                    // =========================
                    // DOCTOR LIST
                    // =========================

                    Expanded(
                      child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection("doctors")
                            .snapshots(),

                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(
                                color: Colors.blueAccent,
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
                                "No doctors found",
                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                            );
                          }

                          // =========================
                          // SEARCH FILTER
                          // =========================

                          final doctors =
                          snapshot.data!.docs.where((doc) {
                            final data =
                            doc.data() as Map<String, dynamic>;

                            final name = (data["name"] ?? "")
                                .toString()
                                .toLowerCase();

                            final specialization =
                            (data["specialization"] ?? "")
                                .toString()
                                .toLowerCase();

                            final searchText =
                            search.toLowerCase().trim();

                            return name.contains(searchText) ||
                                specialization.contains(searchText);
                          }).toList();

                          if (doctors.isEmpty) {
                            return const Center(
                              child: Text(
                                "No doctors found",
                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                            );
                          }

                          return ListView.builder(
                            itemCount: doctors.length,
                            itemBuilder: (_, index) {
                              final document = doctors[index];

                              final data = document.data()
                              as Map<String, dynamic>;

                              final name = (data["name"] ??
                                  "Unknown Doctor")
                                  .toString();

                              final specialization =
                              (data["specialization"] ??
                                  "No specialization")
                                  .toString();

                              final email =
                              (data["email"] ?? "No email").toString();

                              final image =
                              (data["image"] ?? "").toString();

                              final status =
                              (data["status"] ?? "Pending").toString();

                              // =========================
                              // DOCTOR OBJECT
                              // =========================

                              final doctor = Doctor(
                                name: name,
                                specialization: specialization,
                                email: email,
                                image: image,
                                status: status,
                              );

                              return Card(
                                color: Colors.white,
                                elevation: 1,
                                margin: const EdgeInsets.only(
                                  bottom: 12,
                                ),
                                child: ListTile(
                                  contentPadding:
                                  const EdgeInsets.symmetric(
                                    horizontal: 15,
                                    vertical: 10,
                                  ),

                                  // =========================
                                  // DOCTOR IMAGE
                                  // =========================

                                  leading: DoctorAvatar(
                                    doctor: doctor,
                                    radius: 28,
                                  ),

                                  // =========================
                                  // NAME
                                  // =========================

                                  title: Text(
                                    name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),

                                  // =========================
                                  // SPECIALIZATION + EMAIL
                                  // =========================

                                  subtitle: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 4),

                                      Text(
                                        specialization,
                                        style: const TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),

                                      const SizedBox(height: 3),

                                      Text(
                                        email,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),

                                  // =========================
                                  // MENU
                                  // =========================

                                  trailing: PopupMenuButton<String>(
                                    icon: const Icon(
                                      Icons.more_vert,
                                      color: Colors.blueAccent,
                                    ),
                                    itemBuilder: (_) {
                                      return const [
                                        PopupMenuItem<String>(
                                          value: "edit",
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.edit,
                                                color: Colors.blueAccent,
                                              ),
                                              SizedBox(width: 10),
                                              Text("Edit"),
                                            ],
                                          ),
                                        ),

                                        PopupMenuItem<String>(
                                          value: "approve",
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.check_circle,
                                                color: Colors.green,
                                              ),
                                              SizedBox(width: 10),
                                              Text("Approve"),
                                            ],
                                          ),
                                        ),

                                        PopupMenuItem<String>(
                                          value: "reject",
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.cancel,
                                                color: Colors.red,
                                              ),
                                              SizedBox(width: 10),
                                              Text("Reject"),
                                            ],
                                          ),
                                        ),

                                        PopupMenuItem<String>(
                                          value: "delete",
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.delete,
                                                color: Colors.red,
                                              ),
                                              SizedBox(width: 10),
                                              Text("Delete"),
                                            ],
                                          ),
                                        ),
                                      ];
                                    },
                                    onSelected: (value) {
                                      if (value == "edit") {
                                        editDoctor(
                                          document.id,
                                          name,
                                          specialization,
                                          email,
                                          image,
                                          status,
                                        );
                                      }

                                      if (value == "approve") {
                                        changeStatus(
                                          document.id,
                                          "Approved",
                                        );
                                      }

                                      if (value == "reject") {
                                        changeStatus(
                                          document.id,
                                          "Rejected",
                                        );
                                      }

                                      if (value == "delete") {
                                        confirmDelete(
                                          document.id,
                                          name,
                                        );
                                      }
                                    },
                                  ),

                                  isThreeLine: true,
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 10),

                    // =========================
                    // ADD BUTTON
                    // =========================

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: addDoctor,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            vertical: 14,
                          ),
                        ),
                        icon: const Icon(Icons.add),
                        label: const Text(
                          "Add New Doctor",
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
// ADD DOCTOR DIALOG
// ==========================================================================

class AddDoctorDialog extends StatefulWidget {
  final VoidCallback onSuccess;
  final Function(String) onError;

  const AddDoctorDialog({
    super.key,
    required this.onSuccess,
    required this.onError,
  });

  @override
  State<AddDoctorDialog> createState() => _AddDoctorDialogState();
}

class _AddDoctorDialogState extends State<AddDoctorDialog> {
  final name = TextEditingController();
  final specialization = TextEditingController();
  final email = TextEditingController();

  @override
  void dispose() {
    name.dispose();
    specialization.dispose();
    email.dispose();
    super.dispose();
  }

  // =========================
  // ADD TO FIRESTORE
  // =========================

  Future<void> saveDoctor() async {
    final doctorName = name.text.trim();
    final doctorSpecialization = specialization.text.trim();
    final doctorEmail = email.text.trim();

    if (doctorName.isEmpty ||
        doctorSpecialization.isEmpty ||
        doctorEmail.isEmpty) {
      widget.onError(
        "Please enter all doctor information",
      );
      return;
    }

    try {
      await FirebaseFirestore.instance
          .collection("doctors")
          .add({
        "name": doctorName,
        "specialization": doctorSpecialization,
        "email": doctorEmail,

        // Default image
        "image": "assets/doctors/doctor1.jpeg",

        // New doctor starts as Pending
        "status": "Pending",

        "createdAt": FieldValue.serverTimestamp(),
      });

      if (mounted) {
        Navigator.pop(context);
        widget.onSuccess();
      }
    } catch (e) {
      widget.onError(
        "Error adding doctor",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        "Add Doctor",
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: name,
              decoration: const InputDecoration(
                labelText: "Doctor Name",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: specialization,
              decoration: const InputDecoration(
                labelText: "Specialization",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: email,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(),
              ),
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
          onPressed: saveDoctor,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent,
            foregroundColor: Colors.white,
          ),
          child: const Text("Add"),
        ),
      ],
    );
  }
}

// ==========================================================================
// EDIT DOCTOR DIALOG
// ==========================================================================

class EditDoctorDialog extends StatefulWidget {
  final String documentId;
  final String currentName;
  final String currentSpecialization;
  final String currentEmail;
  final String currentImage;
  final String currentStatus;

  final VoidCallback onSuccess;
  final Function(String) onError;

  const EditDoctorDialog({
    super.key,
    required this.documentId,
    required this.currentName,
    required this.currentSpecialization,
    required this.currentEmail,
    required this.currentImage,
    required this.currentStatus,
    required this.onSuccess,
    required this.onError,
  });

  @override
  State<EditDoctorDialog> createState() => _EditDoctorDialogState();
}

class _EditDoctorDialogState extends State<EditDoctorDialog> {
  late TextEditingController name;
  late TextEditingController specialization;
  late TextEditingController email;

  late String selectedStatus;

  @override
  void initState() {
    super.initState();

    name = TextEditingController(
      text: widget.currentName,
    );

    specialization = TextEditingController(
      text: widget.currentSpecialization,
    );

    email = TextEditingController(
      text: widget.currentEmail,
    );

    // IMPORTANT:
    // Convert Firestore status to the exact dropdown value.
    selectedStatus = _getValidStatus(widget.currentStatus);
  }

  @override
  void dispose() {
    name.dispose();
    specialization.dispose();
    email.dispose();
    super.dispose();
  }

  // =========================
  // VALID STATUS
  // =========================

  String _getValidStatus(String value) {
    switch (value.trim().toLowerCase()) {
      case "approved":
        return "Approved";

      case "rejected":
        return "Rejected";

      case "pending":
      default:
        return "Pending";
    }
  }

  // =========================
  // UPDATE FIRESTORE
  // =========================

  Future<void> updateDoctor() async {
    final doctorName = name.text.trim();
    final doctorSpecialization = specialization.text.trim();
    final doctorEmail = email.text.trim();

    if (doctorName.isEmpty ||
        doctorSpecialization.isEmpty ||
        doctorEmail.isEmpty) {
      widget.onError(
        "Please enter all doctor information",
      );
      return;
    }

    try {
      await FirebaseFirestore.instance
          .collection("doctors")
          .doc(widget.documentId)
          .update({
        "name": doctorName,
        "specialization": doctorSpecialization,
        "email": doctorEmail,
        "status": selectedStatus,
      });

      if (mounted) {
        Navigator.pop(context);
        widget.onSuccess();
      }
    } catch (e) {
      widget.onError(
        "Error updating doctor",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        "Edit Doctor",
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),

      content: SingleChildScrollView(
        child: Column(
          children: [
            // =========================
            // NAME
            // =========================

            TextField(
              controller: name,
              decoration: const InputDecoration(
                labelText: "Doctor Name",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            // =========================
            // SPECIALIZATION
            // =========================

            TextField(
              controller: specialization,
              decoration: const InputDecoration(
                labelText: "Specialization",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            // =========================
            // EMAIL
            // =========================

            TextField(
              controller: email,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            // =========================
            // STATUS
            // =========================

            DropdownButtonFormField<String>(
              initialValue: selectedStatus,

              decoration: const InputDecoration(
                labelText: "Status",
                border: OutlineInputBorder(),
              ),

              items: const [
                DropdownMenuItem<String>(
                  value: "Pending",
                  child: Text("Pending"),
                ),

                DropdownMenuItem<String>(
                  value: "Approved",
                  child: Text("Approved"),
                ),

                DropdownMenuItem<String>(
                  value: "Rejected",
                  child: Text("Rejected"),
                ),
              ],

              onChanged: (String? value) {
                if (value != null) {
                  setState(() {
                    selectedStatus = value;
                  });
                }
              },
            ),
          ],
        ),
      ),

      actions: [
        // =========================
        // CANCEL
        // =========================

        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text(
            "Cancel",
          ),
        ),

        // =========================
        // UPDATE
        // =========================

        ElevatedButton(
          onPressed: updateDoctor,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent,
            foregroundColor: Colors.white,
          ),
          child: const Text(
            "Update",
          ),
        ),
      ],
    );
  }
}