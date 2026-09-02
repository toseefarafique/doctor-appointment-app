import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'admin_widgets.dart';

class SpecializationsScreen extends StatefulWidget {
  const SpecializationsScreen({super.key});

  @override
  State<SpecializationsScreen> createState() =>
      _SpecializationsScreenState();
}

class _SpecializationsScreenState
    extends State<SpecializationsScreen> {
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
  // ADD SPECIALIZATION
  // =========================

  void addSpecialization() {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text(
            "Add Specialization",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),

          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              labelText: "Specialization name",
              border: OutlineInputBorder(),
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
              onPressed: () async {
                final name =
                controller.text.trim();

                if (name.isEmpty) {
                  showMessage(
                    "Please enter specialization name",
                    isError: true,
                  );
                  return;
                }

                try {
                  await FirebaseFirestore.instance
                      .collection("specializations")
                      .add({
                    "name": name,
                    "createdAt":
                    FieldValue.serverTimestamp(),
                  });

                  if (mounted) {
                    Navigator.pop(context);

                    showMessage(
                      "Specialization added successfully",
                    );
                  }
                } catch (e) {
                  if (mounted) {
                    showMessage(
                      "Error adding specialization",
                      isError: true,
                    );
                  }
                }
              },

              style: ElevatedButton.styleFrom(
                backgroundColor:
                Colors.blueAccent,
                foregroundColor: Colors.white,
              ),

              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }

  // =========================
  // EDIT SPECIALIZATION
  // =========================

  void editSpecialization(
      String documentId,
      String currentName,
      ) {
    final controller =
    TextEditingController(
      text: currentName,
    );

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text(
            "Edit Specialization",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),

          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              labelText: "Specialization name",
              border: OutlineInputBorder(),
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
              onPressed: () async {
                final name =
                controller.text.trim();

                if (name.isEmpty) {
                  showMessage(
                    "Please enter specialization name",
                    isError: true,
                  );
                  return;
                }

                try {
                  await FirebaseFirestore.instance
                      .collection("specializations")
                      .doc(documentId)
                      .update({
                    "name": name,
                  });

                  if (mounted) {
                    Navigator.pop(context);

                    showMessage(
                      "Specialization updated successfully",
                    );
                  }
                } catch (e) {
                  if (mounted) {
                    showMessage(
                      "Error updating specialization",
                      isError: true,
                    );
                  }
                }
              },

              style: ElevatedButton.styleFrom(
                backgroundColor:
                Colors.blueAccent,
                foregroundColor: Colors.white,
              ),

              child: const Text("Update"),
            ),
          ],
        );
      },
    );
  }

  // =========================
  // DELETE SPECIALIZATION
  // =========================

  Future<void> deleteSpecialization(
      String documentId,
      ) async {
    try {
      await FirebaseFirestore.instance
          .collection("specializations")
          .doc(documentId)
          .delete();

      if (mounted) {
        showMessage(
          "Specialization deleted successfully",
        );
      }
    } catch (e) {
      if (mounted) {
        showMessage(
          "Error deleting specialization",
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
      String specializationName,
      ) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text(
            "Delete Specialization",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),

          content: Text(
            "Are you sure you want to delete $specializationName?",
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

                await deleteSpecialization(
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
  // BUILD
  // =========================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
      const Color(0xFFEFF3F8),

      body: Center(
        child: Container(
          width: 600,
          height: 1100,
          clipBehavior: Clip.antiAlias,

          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius:
            BorderRadius.circular(20),
          ),

          child: ScaffoldMessenger(
            key: scaffoldMessengerKey,

            child: Scaffold(
              backgroundColor: Colors.white,

              appBar: const MyAppBar(
                title: "Specializations",
              ),

              body: Padding(
                padding:
                const EdgeInsets.all(20),

                child: Column(
                  children: [
                    // SEARCH
                    SearchBox(
                      hint:
                      "Search specialization...",

                      onChanged: (value) {
                        setState(() {
                          search = value;
                        });
                      },
                    ),

                    const SizedBox(height: 15),

                    // LIST
                    Expanded(
                      child:
                      StreamBuilder<QuerySnapshot>(
                        stream:
                        FirebaseFirestore.instance
                            .collection(
                            "specializations")
                            .snapshots(),

                        builder:
                            (context, snapshot) {
                          if (snapshot
                              .connectionState ==
                              ConnectionState
                                  .waiting) {
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
                              snapshot
                                  .data!
                                  .docs
                                  .isEmpty) {
                            return const Center(
                              child: Text(
                                "No specializations found",
                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                            );
                          }

                          // SEARCH FILTER
                          final list = snapshot
                              .data!
                              .docs
                              .where((doc) {
                            final data =
                            doc.data()
                            as Map<String,
                                dynamic>;

                            final name =
                            (data["name"] ??
                                "")
                                .toString();

                            return name
                                .toLowerCase()
                                .contains(
                              search
                                  .toLowerCase(),
                            );
                          }).toList();

                          if (list.isEmpty) {
                            return const Center(
                              child: Text(
                                "No specializations found",
                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                            );
                          }

                          return ListView.builder(
                            itemCount: list.length,

                            itemBuilder:
                                (_, index) {
                              final document =
                              list[index];

                              final data =
                              document.data()
                              as Map<String,
                                  dynamic>;

                              final item =
                              (data["name"] ??
                                  "Unknown")
                                  .toString();

                              return Card(
                                color:
                                Colors.white,

                                margin:
                                const EdgeInsets
                                    .only(
                                  bottom: 10,
                                ),

                                child: ListTile(
                                  contentPadding:
                                  const EdgeInsets
                                      .symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),

                                  // ICON
                                  leading:
                                  CircleAvatar(
                                    radius: 25,

                                    backgroundColor:
                                    Colors
                                        .blueAccent
                                        .withOpacity(
                                        0.1),

                                    child: Icon(
                                      getSpecializationIcon(
                                          item),
                                      color: appBlue,
                                      size: 26,
                                    ),
                                  ),

                                  // NAME
                                  title: Text(
                                    item,
                                    style:
                                    const TextStyle(
                                      fontWeight:
                                      FontWeight
                                          .bold,
                                      fontSize: 16,
                                    ),
                                  ),

                                  // MENU
                                  trailing:
                                  PopupMenuButton<
                                      String>(
                                    icon:
                                    const Icon(
                                      Icons.more_vert,
                                      color: Colors
                                          .blueAccent,
                                    ),

                                    itemBuilder:
                                        (_) =>
                                    const [
                                      PopupMenuItem<
                                          String>(
                                        value:
                                        "edit",
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons
                                                  .edit,
                                              color: Colors
                                                  .blueAccent,
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                                "Edit"),
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
                                              Icons
                                                  .delete,
                                              color:
                                              Colors.red,
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                                "Delete"),
                                          ],
                                        ),
                                      ),
                                    ],

                                    onSelected:
                                        (value) {
                                      if (value ==
                                          "edit") {
                                        editSpecialization(
                                          document.id,
                                          item,
                                        );
                                      }

                                      if (value ==
                                          "delete") {
                                        confirmDelete(
                                          document.id,
                                          item,
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

                    // ADD BUTTON
                    SizedBox(
                      width:
                      double.infinity,

                      child:
                      ElevatedButton.icon(
                        onPressed:
                        addSpecialization,

                        style:
                        ElevatedButton.styleFrom(
                          backgroundColor:
                          Colors.blueAccent,
                          foregroundColor:
                          Colors.white,
                          padding:
                          const EdgeInsets
                              .symmetric(
                            vertical: 14,
                          ),
                        ),

                        icon: const Icon(
                          Icons.add,
                        ),

                        label: const Text(
                          "Add New Specialization",
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