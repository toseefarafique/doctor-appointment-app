import 'package:flutter/material.dart';

class AppointmentDetails extends StatelessWidget {
  final Map<String, dynamic> appointment;

  const AppointmentDetails({
    super.key,
    required this.appointment,
  });

  static const Color primaryBlue = Color(0xFF1565C0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 253, 252, 252),
      body: SafeArea(
    child: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 600,
        ),

        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),

          child: Scaffold(
            backgroundColor: const Color.fromARGB(234, 245, 243, 243),

      

  

      appBar: AppBar(
        backgroundColor: primaryBlue,
        foregroundColor: Colors.white,
        elevation: 0,

        title: const Text(
          "Appointment Details",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [

            

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),

              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 254, 254, 254),
                borderRadius: BorderRadius.circular(16),

                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),

              child: Column(
                children: [

                  const CircleAvatar(
                    radius: 40,
                    backgroundColor: Color(0xFFE3F2FD),

                    child: Icon(
                      Icons.person,
                      size: 48,
                      color: primaryBlue,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    (appointment["name"] ?? "").toString(),

                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    "${appointment["age"] ?? ""} • "
                    "${appointment["gender"] ?? ""}",

                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            

            detailSection(
              title: "Appointment Information",

              children: [
                detailRow(
                  Icons.calendar_today,
                  "Date",
                  (appointment["date"] ?? "").toString(),
                ),

                const Divider(),

                detailRow(
                  Icons.access_time,
                  "Time",
                  (appointment["time"] ?? "").toString(),
                ),

                const Divider(),

                detailRow(
                  Icons.medical_services,
                  "Type",
                  (appointment["type"] ?? "").toString(),
                ),

                const Divider(),

                detailRow(
                  Icons.check_circle,
                  "Status",
                  (appointment["status"] ?? "").toString(),
                ),
              ],
            ),

            const SizedBox(height: 20),

          

            detailSection(
              title: "Patient Information",

              children: [
                detailRow(
                  Icons.person,
                  "Name",
                  (appointment["name"] ?? "").toString(),
                ),

                const Divider(),

                detailRow(
                  Icons.cake,
                  "Age",
                  (appointment["age"] ?? "").toString(),
                ),

                const Divider(),

                detailRow(
                  Icons.person_outline,
                  "Gender",
                  (appointment["gender"] ?? "").toString(),
                ),
              ],
            ),

            const SizedBox(height: 20),

            

            detailSection(
              title: "Reason for Visit",

              children: const [
                Align(
                  alignment: Alignment.centerLeft,

                  child: Text(
                    "General medical consultation "
                    "and patient check-up.",

                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            

            SizedBox(
              width: double.infinity,
              height: 45,

              child: ElevatedButton(
                onPressed: () {},

                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryBlue,
                  foregroundColor: Colors.white,

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),

                child: const Text(
                  "Start Consultation",

                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),

            

            SizedBox(
              width: double.infinity,
              height: 45,

              child: OutlinedButton(
                onPressed: () {},

                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,

                  side: const BorderSide(
                    color: Colors.red,
                  ),

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),

                child: const Text(
                  "Cancel Appointment",

                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
          )
        )
      )
    )
      )
    );
  }

  

  static Widget detailSection({
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(15),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Text(
            title,

            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: primaryBlue,
            ),
          ),

          const SizedBox(height: 12),

          // THIS WAS MISSING
          ...children,
        ],
      ),
    );
  }

  

  static Widget detailRow(
    IconData icon,
    String title,
    String value,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 5,
      ),

      child: Row(
        children: [

          Container(
            width: 38,
            height: 38,

            decoration: BoxDecoration(
              color: const Color(0xFFE3F2FD),

              borderRadius: BorderRadius.circular(10),
            ),

            child: Icon(
              icon,
              color: primaryBlue,
              size: 20,
            ),
          ),

          const SizedBox(width: 12),

          Text(
            title,

            style: const TextStyle(
              fontSize: 13,
              color: Colors.grey,
            ),
          ),

          const Spacer(),

          Flexible(
            child: Text(
              value,

              textAlign: TextAlign.right,

              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}