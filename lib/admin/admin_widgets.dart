import 'package:flutter/material.dart';

import 'manage_patients.dart';
import 'manage_doctors.dart';
import 'manage_appointments.dart';
import 'specializations.dart';
import 'doctor_approval.dart';
import '../doctor/doctor_main_screen.dart';

const Color appBlue = Colors.blueAccent;

// ============================== DOCTOR MODEL ==============================

class Doctor {
  String name;
  String specialization;
  String email;
  String image;
  String status;

  Doctor({
    required this.name,
    required this.specialization,
    required this.email,
    required this.image,
    this.status = "Pending",
  });
}

// ================================ APP BAR =================================

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showMenu;

  const MyAppBar({super.key, required this.title, this.showMenu = false});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.blueAccent,
      foregroundColor: Colors.white,

      // When showMenu is true, we provide our own hamburger button.
      automaticallyImplyLeading: !showMenu,

      leading: showMenu
          ? Builder(
              builder: (context) {
                return IconButton(
                  icon: const Icon(Icons.menu, color: Colors.white, size: 28),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                );
              },
            )
          : null,

      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),

      actions: [
        IconButton(
          icon: const Icon(
            Icons.notifications_none,
            color: Colors.white,
            size: 27,
          ),
          onPressed: () {},
        ),
      ],

      iconTheme: const IconThemeData(color: Colors.white),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

// ================================ DRAWER ==================================

class AdminDrawer extends StatelessWidget {
  const AdminDrawer({super.key});

  void openPage(BuildContext context, Widget page) {
    Navigator.pop(context);

    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // ================= DRAWER HEADER =================

          DrawerHeader(
            decoration: const BoxDecoration(color: Colors.blueAccent),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.admin_panel_settings, color: Colors.white, size: 50),
                SizedBox(height: 10),
                Text(
                  "Admin Panel",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // ================= DASHBOARD =================
          ListTile(
            leading: const Icon(Icons.dashboard, color: appBlue),
            title: const Text(
              "Dashboard",
              style: TextStyle(color: Colors.black87),
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),

          // ================= MANAGE PATIENTS =================
          ListTile(
            leading: const Icon(Icons.people, color: Colors.green),
            title: const Text(
              "Manage Patients",
              style: TextStyle(color: Colors.black87),
            ),
            onTap: () {
              openPage(context, const ManagePatients());
            },
          ),

          // ================= MANAGE DOCTORS =================
          ListTile(
            leading: const Icon(Icons.medical_services, color: Colors.orange),
            title: const Text(
              "Manage Doctors",
              style: TextStyle(color: Colors.black87),
            ),
            onTap: () {
              openPage(context, const ManageDoctors());
            },
          ),

          // ================= MANAGE APPOINTMENTS =================
          ListTile(
            leading: const Icon(Icons.calendar_month, color: Colors.purple),
            title: const Text(
              "Manage Appointments",
              style: TextStyle(color: Colors.black87),
            ),
            onTap: () {
              openPage(context, const ManageAppointments());
            },
          ),

          // ================= SPECIALIZATIONS =================
          ListTile(
            leading: const Icon(Icons.local_hospital, color: Colors.red),
            title: const Text(
              "Specializations",
              style: TextStyle(color: Colors.black87),
            ),
            onTap: () {
              openPage(context, const SpecializationsScreen());
            },
          ),

          // ================= DOCTOR APPROVAL =================
          ListTile(
            leading: const Icon(Icons.verified_user, color: Colors.teal),
            title: const Text(
              "Doctor Approval",
              style: TextStyle(color: Colors.black87),
            ),
            onTap: () {
              openPage(context, const DoctorApproval());
            },
          ),

          const Divider(),

          // ================= DOCTOR MODULE =================
          ListTile(
            leading: const Icon(Icons.person, color: Colors.indigo),
            title: const Text(
              "Doctor Module",
              style: TextStyle(color: Colors.black87),
            ),
            onTap: () {
              openPage(context, const DoctorMainScreen());
            },
          ),
        ],
      ),
    );
  }
}

// ================================ STAT CARD ===============================

class StatCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color color;

  const StatCard({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ================= COLORED ICON =================

            Icon(icon, size: 40, color: color),

            const SizedBox(height: 8),

            // ================= TITLE =================
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 5),

            // ================= NUMBER =================
            // Always BLACK
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================== STATUS BADGE ==============================

class StatusBadge extends StatelessWidget {
  final String status;

  const StatusBadge({super.key, required this.status});

  Color getStatusColor() {
    switch (status) {
      case "Pending":
        return Colors.orange;

      case "Confirmed":
        return Colors.green;

      case "Completed":
        return Colors.green.shade700;

      case "Rejected":
        return Colors.red;

      case "Approved":
        return Colors.green;

      case "Cancelled":
        return Colors.red;

      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color statusColor = getStatusColor();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: statusColor,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}

// ================================ SEARCH BOX ==============================

class SearchBox extends StatelessWidget {
  final ValueChanged<String> onChanged;
  final String hint;

  const SearchBox({
    super.key,
    required this.onChanged,
    this.hint = "Search...",
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hint,

        prefixIcon: const Icon(Icons.search, color: Colors.blueAccent),

        filled: true,
        fillColor: Colors.white,

        contentPadding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 15,
        ),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
        ),
      ),
    );
  }
}

// ============================== PATIENT AVATAR ============================

class PatientAvatar extends StatelessWidget {
  const PatientAvatar({super.key});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 25,
      backgroundColor: Colors.blue.shade50,
      child: const Icon(Icons.person, color: Colors.blueAccent, size: 28),
    );
  }
}

// ============================== DOCTOR AVATAR =============================

class DoctorAvatar extends StatelessWidget {
  final Doctor doctor;
  final double radius;

  const DoctorAvatar({super.key, required this.doctor, this.radius = 25});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: Colors.blue.shade50,
      child: ClipOval(
        child: Image.asset(
          doctor.image,
          width: radius * 2,
          height: radius * 2,
          fit: BoxFit.cover,
          errorBuilder:
              (BuildContext context, Object error, StackTrace? stackTrace) {
                return Icon(
                  Icons.person,
                  color: Colors.blueAccent,
                  size: radius * 1.1,
                );
              },
        ),
      ),
    );
  }
}

// ======================== SPECIALIZATION ICON ============================

IconData getSpecializationIcon(String specialization) {
  switch (specialization.toLowerCase()) {
    case "cardiology":
      return Icons.favorite;

    case "neurology":
      return Icons.psychology;

    case "dermatology":
      return Icons.face;

    case "ophthalmology":
      return Icons.visibility;

    default:
      return Icons.local_hospital;
  }
}
