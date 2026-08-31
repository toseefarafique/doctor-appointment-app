import 'package:flutter/material.dart';

class DoctorTimeSlots extends StatefulWidget {
  const DoctorTimeSlots({super.key});

  @override
  State<DoctorTimeSlots> createState() => _DoctorTimeSlotsState();
}

class _DoctorTimeSlotsState extends State<DoctorTimeSlots> {
  static const Color primaryBlue = Color(0xFF1565C0);

  DateTime selectedDate = DateTime.now();

  List<Map<String, dynamic>> slots = [
    {
      "time": "09:00 AM - 09:30 AM",
      "available": true,
    },
    {
      "time": "09:30 AM - 10:00 AM",
      "available": true,
    },
    {
      "time": "10:00 AM - 10:30 AM",
      "available": true,
    },
    {
      "time": "11:30 AM - 12:00 PM",
      "available": false,
    },
    {
      "time": "02:00 PM - 02:30 PM",
      "available": false,
    },
  ];

  // Select Date
  Future<void> pickDate() async {
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );

    if (date != null) {
      setState(() {
        selectedDate = date;
      });
    }
  }

  // Add Slot
  void addSlots() {
    TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add Time Slot"),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: "Example: 01:00 PM - 01:30 PM",
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
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  setState(() {
                    slots.add({
                      "time": controller.text,
                      "available": true,
                    });
                  });

                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryBlue,
                foregroundColor: Colors.white,
              ),
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }

  // Delete Slot
  void deleteSlot(int index) {
    setState(() {
      slots.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFF3F8),

      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 600,
            ),

            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),

              child: Scaffold(
                backgroundColor: const Color(0xFFF7F9FC),

              
                appBar: AppBar(
                  backgroundColor: primaryBlue,
                  foregroundColor: Colors.white,
                  elevation: 0,

                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),

                  title: const Text(
                    "Time Slots",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  actions: [
                    TextButton.icon(
                      onPressed: addSlots,

                      icon: const Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 18,
                      ),

                      label: const Text(
                        "Add Slot",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

              
                body: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      // Selected Date
                      const Text(
                        "Selected Date",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 8),

                      GestureDetector(
                        onTap: pickDate,

                        child: Container(
                          width: double.infinity,

                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 13,
                          ),

                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),

                            border: Border.all(
                              color: const Color(0xFFE0E0E0),
                            ),
                          ),

                          child: Row(
                            children: [

                              const Icon(
                                Icons.calendar_today,
                                size: 18,
                                color: primaryBlue,
                              ),

                              const SizedBox(width: 10),

                              Text(
                                "${selectedDate.day} "
                                "${_monthName(selectedDate.month)} "
                                "${selectedDate.year}",

                                style: const TextStyle(
                                  fontSize: 14,
                                ),
                              ),

                              const Spacer(),

                              const Icon(
                                Icons.calendar_month,
                                size: 18,
                                color: Colors.grey,
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 22),

                      // Available Slots
                      const Text(
                        "Available Slots",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 10),

                      
                      ListView.builder(
                        shrinkWrap: true,

                        physics:
                            const NeverScrollableScrollPhysics(),

                        itemCount: slots.length,

                        itemBuilder: (context, index) {
                          final slot = slots[index];

                          return Container(
                            margin: const EdgeInsets.only(
                              bottom: 10,
                            ),

                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),

                            decoration: BoxDecoration(
                              color: Colors.white,

                              borderRadius:
                                  BorderRadius.circular(10),

                              border: Border.all(
                                color: const Color(0xFFE0E0E0),
                              ),
                            ),

                            child: Row(
                              children: [

                                // Time
                                Expanded(
                                  child: Text(
                                    slot["time"].toString(),

                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),

                                // Available Switch
                                Switch(
                                  value: slot["available"] == true,

                                  activeThumbColor: Colors.white,

                                  activeTrackColor: Colors.green,

                                  onChanged: (value) {
                                    setState(() {
                                      slot["available"] = value;
                                    });
                                  },
                                ),

                                // Delete
                                IconButton(
                                  onPressed: () {
                                    deleteSlot(index);
                                  },

                                  icon: const Icon(
                                    Icons.delete_outline,
                                    size: 20,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),

                      
                      const SizedBox(height: 8),

                      SizedBox(
                        width: double.infinity,
                        height: 45,

                        child: ElevatedButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "Time slots saved successfully",
                                ),
                              ),
                            );
                          },

                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryBlue,
                            foregroundColor: Colors.white,

                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(10),
                            ),
                          ),

                          child: const Text(
                            "Save Time Slots",

                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 27),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Month Name
  String _monthName(int month) {
    const months = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December",
    ];

    return months[month - 1];
  }
}