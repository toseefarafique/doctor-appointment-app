
import 'package:doctor_appointment_app/doctor/appointment.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'doctor_profile.dart';
import 'schedule.dart';
import 'time_slots.dart';
import 'patient_details.dart';

class DoctorDashboard extends StatelessWidget {
const DoctorDashboard({super.key});

static const Color primaryBlue = Colors.blueAccent;

// ============================================================
// GET SARA KHAN FROM FIRESTORE USING THE NAME FIELD
// ============================================================
Stream<QuerySnapshot<Map<String, dynamic>>> getDoctor() {
return FirebaseFirestore.instance
    .collection('doctors')
    .where('name', isEqualTo: 'Sara Khan')
    .limit(1)
    .snapshots();
}

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

child: Scaffold(
backgroundColor: Colors.white,

// ==================================================
// APP BAR
// ==================================================
appBar: AppBar(
backgroundColor: primaryBlue,
foregroundColor: Colors.white,
elevation: 0,

title: const Text(
"Doctor Dashboard",
style: TextStyle(
fontSize: 18,
fontWeight: FontWeight.bold,
),
),

actions: [
IconButton(
onPressed: () {},
icon: const Icon(
Icons.notifications_none,
),
),
],
),

// ==================================================
// DRAWER
// ==================================================
drawer: Drawer(
backgroundColor: Colors.white,

child: ListView(
padding: EdgeInsets.zero,

children: [
// ------------------------------------------------
// DRAWER HEADER
// ------------------------------------------------
DrawerHeader(
decoration: const BoxDecoration(
color: primaryBlue,
),

child: StreamBuilder<
QuerySnapshot<Map<String, dynamic>>>(
stream: getDoctor(),

builder: (context, snapshot) {
if (snapshot.connectionState ==
ConnectionState.waiting) {
return const Center(
child: CircularProgressIndicator(
color: Colors.white,
),
);
}

if (snapshot.hasError) {
return const Column(
crossAxisAlignment:
CrossAxisAlignment.start,
children: [
CircleAvatar(
radius: 30,
backgroundColor: Colors.white,
child: Icon(
Icons.person,
size: 38,
color: primaryBlue,
),
),
SizedBox(height: 10),
Text(
"Doctor",
style: TextStyle(
color: Colors.white,
fontSize: 18,
fontWeight: FontWeight.bold,
),
),
],
);
}

if (!snapshot.hasData ||
snapshot.data!.docs.isEmpty) {
return const Column(
crossAxisAlignment:
CrossAxisAlignment.start,
children: [
CircleAvatar(
radius: 30,
backgroundColor: Colors.white,
child: Icon(
Icons.person,
size: 38,
color: primaryBlue,
),
),
SizedBox(height: 10),
Text(
"Sara Khan",
style: TextStyle(
color: Colors.white,
fontSize: 18,
fontWeight: FontWeight.bold,
),
),
],
);
}

final data =
snapshot.data!.docs.first.data();

final name =
data['name'] ?? 'Doctor';

final specialization =
data['specialization'] ??
'Specialist';

return Column(
crossAxisAlignment:
CrossAxisAlignment.start,

children: [
const CircleAvatar(
radius: 30,
backgroundColor: Colors.white,
child: Icon(
Icons.person,
size: 38,
color: primaryBlue,
),
),

const SizedBox(height: 10),

Text(
"Dr. $name",
style: const TextStyle(
color: Colors.white,
fontSize: 18,
fontWeight: FontWeight.bold,
),
),

Text(
specialization,
style: const TextStyle(
color: Colors.white70,
),
),
],
);
},
),
),

// ==================================================
// DASHBOARD
// ==================================================
ListTile(
leading: const Icon(
Icons.dashboard,
color: primaryBlue,
),
title: const Text("Dashboard"),
onTap: () {
Navigator.pop(context);
},
),

// ==================================================
// APPOINTMENTS
// ==================================================
ListTile(
leading: const Icon(
Icons.calendar_today,
color: primaryBlue,
),
title: const Text("Appointments"),
onTap: () {
Navigator.pop(context);

Navigator.push(
context,
MaterialPageRoute(
builder: (context) =>
const DoctorAppointments(),
),
);
},
),

// ==================================================
// PROFILE
// ==================================================
ListTile(
leading: const Icon(
Icons.person,
color: primaryBlue,
),
title: const Text("Profile"),
onTap: () {
Navigator.pop(context);

Navigator.push(
context,
MaterialPageRoute(
builder: (context) =>
const DoctorProfile(),
),
);
},
),

// ==================================================
// SCHEDULE
// ==================================================
ListTile(
leading: const Icon(
Icons.schedule,
color: primaryBlue,
),
title: const Text("Schedule"),
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

// ==================================================
// PATIENT DETAILS
// ==================================================
ListTile(
leading: const Icon(
Icons.person_search,
color: primaryBlue,
),
title: const Text("Patient Detail"),
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

// ==================================================
// TIME SLOTS
// ==================================================
ListTile(
leading: const Icon(
Icons.access_time,
color: primaryBlue,
),
title: const Text("Time Slots"),
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

const Divider(),

// ==================================================
// LOGOUT
// ==================================================
ListTile(
leading: const Icon(
Icons.logout,
color: primaryBlue,
),
title: const Text("Logout"),
onTap: () {},
),
],
),
),

// ==================================================
// BODY
// ==================================================
body: StreamBuilder<
QuerySnapshot<Map<String, dynamic>>>(
stream: getDoctor(),

builder: (context, snapshot) {
// ------------------------------------------------
// LOADING
// ------------------------------------------------
if (snapshot.connectionState ==
ConnectionState.waiting) {
return const Center(
child: CircularProgressIndicator(
color: primaryBlue,
),
);
}

// ------------------------------------------------
// ERROR
// ------------------------------------------------
if (snapshot.hasError) {
return Center(
child: Padding(
padding: const EdgeInsets.all(20),
child: Text(
"Error loading doctor data:\n\n"
"${snapshot.error}",
textAlign: TextAlign.center,
),
),
);
}

// ------------------------------------------------
// NO DOCTOR FOUND
// ------------------------------------------------
if (!snapshot.hasData ||
snapshot.data!.docs.isEmpty) {
return const Center(
child: Text(
"Doctor data not found in Firestore.",
style: TextStyle(
fontSize: 16,
fontWeight: FontWeight.w500,
),
),
);
}

// ------------------------------------------------
// GET DOCTOR DATA
// ------------------------------------------------
final data =
snapshot.data!.docs.first.data();

final name =
data['name'] ?? 'Doctor';

final specialization =
data['specialization'] ??
'Specialist';

final image =
data['image'] ?? '';

// ==================================================
// DASHBOARD CONTENT
// ==================================================
return SingleChildScrollView(
padding: const EdgeInsets.all(20),

child: Column(
crossAxisAlignment:
CrossAxisAlignment.start,

children: [
// ==================================================
// DOCTOR INFO
// ==================================================
Row(
children: [
Container(
width: 100,
height: 100,

decoration: BoxDecoration(
shape: BoxShape.circle,
color: Colors.blue.shade50,
border: Border.all(
color: primaryBlue,
width: 2,
),
),

child: ClipOval(
child: image.toString().isNotEmpty
? Image.asset(
image.toString(),
fit: BoxFit.cover,

errorBuilder:
(context,
error,
stackTrace) {
return const Icon(
Icons.person,
size: 70,
color: primaryBlue,
);
},
)
    : const Icon(
Icons.person,
size: 70,
color: primaryBlue,
),
),
),

const SizedBox(width: 40),

Expanded(
child: Column(
crossAxisAlignment:
CrossAxisAlignment.start,

children: [
const Text(
"Good Morning",
style: TextStyle(
color: Colors.black87,
fontSize: 20,
),
),

const SizedBox(height: 5),

Text(
"Dr. $name",
style: const TextStyle(
color: Colors.black,
fontSize: 26,
fontWeight:
FontWeight.bold,
),
),

const SizedBox(height: 3),

Text(
specialization,
style: const TextStyle(
color: primaryBlue,
fontSize: 18,
fontWeight:
FontWeight.w500,
),
),
],
),
),
],
),

const SizedBox(height: 40),

// ==================================================
// STATISTICS
// ==================================================
Row(
children: [
Expanded(
child: statCard(
icon:
Icons.calendar_today,
number: "12",
title:
"Today's\nAppointments",
),
),

const SizedBox(width: 10),

Expanded(
child: statCard(
icon:
Icons.pending_actions,
number: "5",
title:
"Pending\nRequests",
),
),

const SizedBox(width: 10),

Expanded(
child: statCard(
icon: Icons.people,
number: "8",
title:
"Total\nPatients",
),
),
],
),

const SizedBox(height: 40),

// ==================================================
// TODAY SCHEDULE
// ==================================================
Row(
mainAxisAlignment:
MainAxisAlignment.spaceBetween,

children: [
const Text(
"Today Schedule",
style: TextStyle(
fontSize: 24,
fontWeight:
FontWeight.bold,
color: Colors.black,
),
),

TextButton(
onPressed: () {},

child: const Text(
"View All",
style: TextStyle(
color: primaryBlue,
fontWeight:
FontWeight.w600,
),
),
),
],
),

const SizedBox(height: 20),

// ==================================================
// APPOINTMENT 1
// ==================================================
scheduleCard(
time: "10:00 AM",
patient: "Ali Raza",
type: "Consultation",
status: "Confirmed",
),

// ==================================================
// APPOINTMENT 2
// ==================================================
scheduleCard(
time: "10:30 AM",
patient: "Fatima Noor",
type: "Follow-up",
status: "Upcoming",
),

// ==================================================
// APPOINTMENT 3
// ==================================================
scheduleCard(
time: "02:00 PM",
patient: "Ahmed Farooq",
type: "Consultation",
status: "Upcoming",
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
);
}

// ==============================================================
// STAT CARD
// ==============================================================
Widget statCard({
required IconData icon,
required String number,
required String title,
}) {
return Card(
color: Colors.white,
elevation: 2,

shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(12),
side: BorderSide(
color: Colors.blue.shade50,
),
),

child: Padding(
padding: const EdgeInsets.all(16),

child: Column(
children: [
Icon(
icon,
color: primaryBlue,
size: 30,
),

const SizedBox(height: 8),

Text(
number,
style: const TextStyle(
fontSize: 24,
fontWeight: FontWeight.bold,
color: Colors.black,
),
),

Text(
title,
textAlign: TextAlign.center,
style: const TextStyle(
color: Colors.black87,
),
),
],
),
),
);
}

// ==============================================================
// SCHEDULE CARD
// ==============================================================
Widget scheduleCard({
required String time,
required String patient,
required String type,
required String status,
}) {
return Card(
color: Colors.white,
elevation: 2,

margin: const EdgeInsets.only(bottom: 12),

shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(12),
),

child: Padding(
padding: const EdgeInsets.all(16),

child: Row(
children: [
Text(
time,
style: const TextStyle(
fontWeight: FontWeight.bold,
color: Colors.black,
),
),

const SizedBox(width: 20),

Expanded(
child: Column(
crossAxisAlignment:
CrossAxisAlignment.start,

children: [
Text(
patient,
style: const TextStyle(
fontSize: 16,
fontWeight: FontWeight.bold,
color: Colors.black,
),
),

const SizedBox(height: 10),

Text(
type,
style: const TextStyle(
color: Colors.black87,
),
),
],
),
),

Container(
padding: const EdgeInsets.symmetric(
horizontal: 10,
vertical: 6,
),

decoration: BoxDecoration(
color: Colors.blue.shade50,
borderRadius:
BorderRadius.circular(20),
),

child: Text(
status,
style: const TextStyle(
color: primaryBlue,
fontWeight: FontWeight.bold,
),
),
),
],
),
),
);
}
}

