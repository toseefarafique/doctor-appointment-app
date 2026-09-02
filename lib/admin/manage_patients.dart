import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'admin_widgets.dart';

class ManagePatients extends StatefulWidget {
  const ManagePatients({super.key});

  @override
  State<ManagePatients> createState() => _ManagePatientsState();
}

class _ManagePatientsState extends State<ManagePatients> {
  String search = "";

  // SnackBar key for the mobile frame
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
  // ADD PATIENT
  // =========================
  void addPatient() {
    final nameController = TextEditingController();
    final emailController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text(
            "Add Patient",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),

          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: "Patient Name",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 15),

              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(),
                ),
              ),
            ],
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
                backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.white,
              ),

              onPressed: () async {
                final name =
                nameController.text.trim();

                final email =
                emailController.text.trim();

                if (name.isEmpty || email.isEmpty) {
                  showMessage(
                    "Please enter name and email",
                    isError: true,
                  );
                  return;
                }

                try {
                  await FirebaseFirestore.instance
                      .collection("patients")
                      .add({
                    "name": name,
                    "email": email,
                    "createdAt":
                    FieldValue.serverTimestamp(),
                  });

                  if (mounted) {
                    Navigator.pop(context);

                    showMessage(
                      "Patient added successfully",
                    );
                  }
                } catch (e) {
                  if (mounted) {
                    showMessage(
                      "Error: $e",
                      isError: true,
                    );
                  }
                }
              },

              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }

  // =========================
  // EDIT PATIENT
  // =========================
  void editPatient(
      String documentId,
      String currentName,
      String currentEmail,
      ) {
    final nameController =
    TextEditingController(text: currentName);

    final emailController =
    TextEditingController(text: currentEmail);

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text(
            "Edit Patient",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),

          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: "Patient Name",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 15),

              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(),
                ),
              ),
            ],
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
                backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.white,
              ),

              onPressed: () async {
                final name =
                nameController.text.trim();

                final email =
                emailController.text.trim();

                if (name.isEmpty || email.isEmpty) {
                  showMessage(
                    "Please enter name and email",
                    isError: true,
                  );
                  return;
                }

                try {
                  await FirebaseFirestore.instance
                      .collection("patients")
                      .doc(documentId)
                      .update({
                    "name": name,
                    "email": email,
                  });

                  if (mounted) {
                    Navigator.pop(context);

                    showMessage(
                      "Patient updated successfully",
                    );
                  }
                } catch (e) {
                  if (mounted) {
                    showMessage(
                      "Error: $e",
                      isError: true,
                    );
                  }
                }
              },

              child: const Text("Update"),
            ),
          ],
        );
      },
    );
  }

  // =========================
  // DELETE PATIENT
  // =========================
  Future<void> deletePatient(
      String documentId,
      ) async {
    try {
      await FirebaseFirestore.instance
          .collection("patients")
          .doc(documentId)
          .delete();

      if (mounted) {
        showMessage(
          "Patient deleted successfully",
        );
      }
    } catch (e) {
      if (mounted) {
        showMessage(
          "Error: $e",
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
            "Delete Patient",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),

          content: Text(
            "Are you sure you want to delete $patientName?",
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

                await deletePatient(documentId);
              },

              child: const Text("Delete"),
            ),
          ],
        );
      },
    );
  }

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

          // =========================
          // MOBILE FRAME
          // =========================
          child: ScaffoldMessenger(
            key: scaffoldMessengerKey,

            child: Scaffold(
              backgroundColor: Colors.white,

              appBar: const MyAppBar(
                title: "Manage Patients",
              ),

              body: Padding(
                padding: const EdgeInsets.all(20),

                child: Column(
                  children: [
                    // =========================
                    // SEARCH
                    // =========================
                    SearchBox(
                      hint: "Search patients...",

                      onChanged: (value) {
                        setState(() {
                          search = value;
                        });
                      },
                    ),

                    const SizedBox(height: 10),

                    // =========================
                    // PATIENT LIST
                    // =========================
                    Expanded(
                      child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection("patients")
                            .snapshots(),

                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child:
                              CircularProgressIndicator(
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
                                "No patients found",
                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                            );
                          }

                          final patients =
                          snapshot.data!.docs.where((doc) {
                            final data =
                            doc.data()
                            as Map<String, dynamic>;

                            final name =
                            (data["name"] ?? "")
                                .toString();

                            return name
                                .toLowerCase()
                                .contains(
                              search.toLowerCase(),
                            );
                          }).toList();

                          if (patients.isEmpty) {
                            return const Center(
                              child: Text(
                                "No patients found",
                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                            );
                          }

                          return ListView.builder(
                            itemCount: patients.length,

                            itemBuilder: (_, index) {
                              final document =
                              patients[index];

                              final data =
                              document.data()
                              as Map<String, dynamic>;

                              final name =
                              (data["name"] ??
                                  "Unknown")
                                  .toString();

                              final email =
                              (data["email"] ??
                                  "No email")
                                  .toString();

                              return Card(
                                color: Colors.white,
                                elevation: 1,

                                margin:
                                const EdgeInsets.only(
                                  bottom: 10,
                                ),

                                child: ListTile(
                                  leading:
                                  const PatientAvatar(),

                                  title: Text(
                                    name,
                                    style:
                                    const TextStyle(
                                      fontWeight:
                                      FontWeight.bold,
                                    ),
                                  ),

                                  subtitle: Text(email),

                                  trailing:
                                  PopupMenuButton<String>(
                                    icon: const Icon(
                                      Icons.more_vert,
                                      color:
                                      Colors.blueAccent,
                                    ),

                                    itemBuilder: (_) =>
                                    const [
                                      PopupMenuItem<String>(
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
                                            Text("Edit"),
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
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text("Delete"),
                                          ],
                                        ),
                                      ),
                                    ],

                                    onSelected: (value) {
                                      if (value == "edit") {
                                        editPatient(
                                          document.id,
                                          name,
                                          email,
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
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 10),

                    // =========================
                    // ADD PATIENT BUTTON
                    // =========================
                    SizedBox(
                      width: double.infinity,

                      child: ElevatedButton.icon(
                        onPressed: addPatient,

                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                          Colors.blueAccent,
                          foregroundColor: Colors.white,

                          padding:
                          const EdgeInsets.symmetric(
                            vertical: 14,
                          ),
                        ),

                        icon: const Icon(Icons.add),

                        label: const Text(
                          "Add New Patient",
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