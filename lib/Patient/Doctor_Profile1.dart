import 'package:flutter/material.dart';
import 'Appointment_Book1.dart';

class DoctorProfile extends StatelessWidget {
  final String doctorId;
  final String doctorName;
  final String specialization;

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

  static const Color primaryBlue = Color(0xFF1565C0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        title: Text(
          doctorName,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // Doctor Icon
            Center(
              child: CircleAvatar(
                radius: 55,
                backgroundColor: Colors.blue.shade100,
                child: const Icon(
                  Icons.person,
                  size: 65,
                  color: primaryBlue,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Doctor Name
            Center(
              child: Text(
                doctorName,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: primaryBlue,
                ),
              ),
            ),

            const SizedBox(height: 8),

            // Specialization
            Center(
              child: Text(
                specialization,
                style: const TextStyle(
                  fontSize: 17,
                  color: Colors.grey,
                ),
              ),
            ),

            const SizedBox(height: 25),

            _infoCard(
              icon: Icons.location_on,
              title: "Location",
              value: location,
            ),

            _infoCard(
              icon: Icons.work,
              title: "Experience",
              value: experience,
            ),

            _infoCard(
              icon: Icons.school,
              title: "Qualification",
              value: qualification,
            ),

            _infoCard(
              icon: Icons.local_hospital,
              title: "Hospital",
              value: hospital,
            ),

            _infoCard(
              icon: Icons.email,
              title: "Email",
              value: email,
            ),

            _infoCard(
              icon: Icons.phone,
              title: "Phone",
              value: phone,
            ),

            const SizedBox(height: 20),

            const Text(
              "About Doctor",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: primaryBlue,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              about.isEmpty
                  ? "No information available."
                  : about,
              style: const TextStyle(
                fontSize: 15,
                color: Colors.black87,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 30),

            // BOOK APPOINTMENT
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AppointmentBook1(
                        doctorId: doctorId,
                        doctorName: doctorName,
                        specialization: specialization,
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.calendar_month),
                label: const Text(
                  "Book Appointment",
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: primaryBlue,
            size: 25,
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  value.isEmpty ? "Not available" : value,
                  style: const TextStyle(
                    fontSize: 15,
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