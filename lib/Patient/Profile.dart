import 'package:flutter/material.dart';

class profile extends StatefulWidget {
  const profile({super.key});

  @override
  State<profile> createState() => _profileState();
}

class _profileState extends State<profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,

      body: Center(
        child: Container(
          width: 600,
          height: 1100,
          clipBehavior: Clip.hardEdge,

          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 20,
                spreadRadius: 2,
              ),
            ],
          ),

          child: SingleChildScrollView(
            child: Column(
              children: [
                // ==================================================
                // PROFILE HEADER
                // ==================================================

                Container(
                  width: double.infinity,
                  height: 190,

                  decoration: const BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(50),
                      bottomRight: Radius.circular(50),
                    ),
                  ),

                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(30, 30, 25, 20),

                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        // Header Text
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,

                            children: const [
                              Text(
                                "Profile",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 28,
                                ),
                              ),

                              SizedBox(height: 5),

                              Text(
                                "Manage your Account and Setting",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Notification
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.notifications,
                            color: Colors.white,
                            size: 35,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // ==================================================
                // PROFILE CARD
                // ==================================================
                Padding(
                  padding: const EdgeInsets.only(left: 30, right: 30, top: 25),

                  child: Container(
                    width: double.infinity,

                    padding: const EdgeInsets.all(25),

                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),

                      border: Border.all(color: Colors.grey.shade200),

                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 8,
                          spreadRadius: 1,
                        ),
                      ],
                    ),

                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,

                      children: [
                        // ==================================================
                        // PROFILE IMAGE
                        // ==================================================

                        Stack(
                          alignment: Alignment.center,
                          children: [
                            CircleAvatar(
                              radius: 55,
                              backgroundColor: Colors.blue.shade100,

                              child: const Icon(
                                Icons.person,
                                size: 65,
                                color: Colors.blueAccent,
                              ),
                            ),

                            Positioned(
                              bottom: 0,
                              right: 0,

                              child: CircleAvatar(
                                radius: 20,
                                backgroundColor: Colors.blueAccent,

                                child: const Icon(
                                  Icons.edit,
                                  color: Colors.white,
                                  size: 23,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(width: 25),

                        // ==================================================
                        // USER INFORMATION
                        // ==================================================
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,

                            children: const [
                              Text(
                                "Sana Khan",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24,
                                ),
                              ),

                              SizedBox(height: 5),

                              Text(
                                "Patient",
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),

                              SizedBox(height: 5),

                              Text(
                                "Taking Care of yourself",
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // ==================================================
                // ACCOUNT SETTINGS
                // ==================================================
                Padding(
                  padding: const EdgeInsets.all(30),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      const Text(
                        "Account Settings",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 21,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 15),

                      _settingTile(
                        icon: Icons.person_outline,
                        title: "Personal Information",
                        subtitle: "Manage your personal details",
                      ),

                      _settingTile(
                        icon: Icons.lock_outline,
                        title: "Change Password",
                        subtitle: "Update your account password",
                      ),

                      _settingTile(
                        icon: Icons.notifications_none,
                        title: "Notifications",
                        subtitle: "Manage notification settings",
                      ),

                      _settingTile(
                        icon: Icons.help_outline,
                        title: "Help & Support",
                        subtitle: "Get help with the application",
                      ),

                      _settingTile(
                        icon: Icons.logout,
                        title: "Logout",
                        subtitle: "Sign out from your account",
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // SETTING TILE
  // ============================================================

  Widget _settingTile({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),

      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),

        leading: CircleAvatar(
          backgroundColor: Colors.blue.shade50,

          child: Icon(icon, color: Colors.blueAccent),
        ),

        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
            fontSize: 16,
          ),
        ),

        subtitle: Text(
          subtitle,
          style: const TextStyle(color: Colors.grey, fontSize: 13),
        ),

        trailing: const Icon(
          Icons.arrow_forward_ios,
          color: Colors.blueAccent,
          size: 17,
        ),

        onTap: () {},
      ),
    );
  }
}
