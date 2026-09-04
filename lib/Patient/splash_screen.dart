import 'package:flutter/material.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(
      const Duration(seconds: 3),
          () {
        if (!mounted) return;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const login_screen(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: Center(
        child: Container(
          width: 600,
          constraints: const BoxConstraints(
            minHeight: 700,
            maxHeight: 900,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.10),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),

          child: ClipRRect(
            borderRadius: BorderRadius.circular(25),

            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                // =========================
                // APP LOGO
                // =========================
                Image.asset(
                  'assets/images/Medi_Book.png',
                  width: 300,
                  height: 300,
                  fit: BoxFit.contain,

                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.medical_services,
                      color: Colors.blueAccent,
                      size: 150,
                    );
                  },
                ),

                const SizedBox(height: 60),

                // =========================
                // LOADING BAR
                // =========================
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 70,
                  ),

                  child: LinearProgressIndicator(
                    color: Colors.blueAccent,
                    minHeight: 6,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}