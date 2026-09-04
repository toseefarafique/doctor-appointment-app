import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'Home_Screen.dart';
import 'Registration_Screen.dart';

// Doctor module
import '../doctor/doctor_main_screen.dart';

// Admin module
import '../admin/admin_dashboard.dart';

class login_screen extends StatefulWidget {
  const login_screen({super.key});

  @override
  State<login_screen> createState() => _login_screenState();
}

class _login_screenState extends State<login_screen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // KEY FOR THE MOBILE FRAME SCAFFOLD
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // ============================================================
  // FIREBASE LOGIN
  // ============================================================

  Future<void> _loginUser() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // --------------------------------------------------------
      // 1. LOGIN USING FIREBASE AUTHENTICATION
      // --------------------------------------------------------

      final UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          );

      final User? user = userCredential.user;

      if (user == null) {
        _showMessage('Unable to login. Please try again.', isError: true);
        return;
      }

      // --------------------------------------------------------
      // 2. GET USER DATA FROM FIRESTORE
      // --------------------------------------------------------

      final DocumentSnapshot<Map<String, dynamic>> userDoc =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get();

      // --------------------------------------------------------
      // 3. CHECK WHETHER USER DOCUMENT EXISTS
      // --------------------------------------------------------

      if (!userDoc.exists) {
        await FirebaseAuth.instance.signOut();

        _showMessage('User profile was not found in Firestore.', isError: true);
        return;
      }

      final Map<String, dynamic>? userData = userDoc.data();

      // --------------------------------------------------------
      // 4. GET USER ROLE
      // --------------------------------------------------------

      final String role =
          userData?['role']?.toString().trim().toLowerCase() ?? '';

      // --------------------------------------------------------
      // 5. CHECK ROLE
      // --------------------------------------------------------

      if (role != 'patient' && role != 'doctor' && role != 'admin') {
        await FirebaseAuth.instance.signOut();

        _showMessage(
          'Invalid user role. Please contact the administrator.',
          isError: true,
        );
        return;
      }

      // --------------------------------------------------------
      // 6. LOGIN SUCCESSFUL
      // --------------------------------------------------------

      if (!mounted) return;

      _showMessage('Login successful!', isError: false);

      await Future.delayed(const Duration(milliseconds: 500));

      if (!mounted) return;

      // --------------------------------------------------------
      // 7. NAVIGATE ACCORDING TO ROLE
      // --------------------------------------------------------

      if (role == 'patient') {
        // ==============================================
        // PATIENT
        // ==============================================

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const homePage()),
        );
      } else if (role == 'doctor') {
        // ==============================================
        // DOCTOR
        // ==============================================

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const DoctorMainScreen()),
        );
      } else if (role == 'admin') {
        // ==============================================
        // ADMIN
        // ==============================================

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const AdminDashboard()),
        );
      }
    }
    // ============================================================
    // FIREBASE AUTHENTICATION ERRORS
    // ============================================================
    on FirebaseAuthException catch (e) {
      String message = 'Login failed. Please try again.';

      switch (e.code) {
        case 'user-not-found':
          message = 'No account found with this email.';
          break;

        case 'wrong-password':
          message = 'Incorrect email or password.';
          break;

        case 'invalid-credential':
          message = 'Incorrect email or password.';
          break;

        case 'invalid-email':
          message = 'Please enter a valid email address.';
          break;

        case 'user-disabled':
          message = 'This account has been disabled.';
          break;

        case 'too-many-requests':
          message = 'Too many login attempts. Please try again later.';
          break;

        case 'network-request-failed':
          message = 'Network error. Please check your internet connection.';
          break;

        case 'operation-not-allowed':
          message = 'Email/password login is not enabled in Firebase.';
          break;

        default:
          message = e.message ?? 'Login failed. Please try again.';
      }

      _showMessage(message, isError: true);
    }
    // ============================================================
    // OTHER ERRORS
    // ============================================================
    catch (e) {
      _showMessage('Something went wrong. Please try again.', isError: true);
    }
    // ============================================================
    // STOP LOADING
    // ============================================================
    finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // ============================================================
  // SNACKBAR
  // ============================================================

  void _showMessage(String message, {required bool isError}) {
    if (!mounted) return;

    _scaffoldMessengerKey.currentState
      ?..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
          backgroundColor: isError ? Colors.red : Colors.green,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          duration: const Duration(seconds: 3),
        ),
      );
  }

  // ============================================================
  // UI
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,

      body: Center(
        child: Container(
          width: 600,
          height: 844,

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

          // ======================================================
          // INNER SCAFFOLD
          // ======================================================
          child: ScaffoldMessenger(
            key: _scaffoldMessengerKey,

            child: Scaffold(
              backgroundColor: Colors.white,

              body: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    // ==================================================
                    // TOP BLUE SECTION
                    // ==================================================

                    Container(
                      height: 220,
                      width: double.infinity,

                      decoration: const BoxDecoration(
                        color: Colors.blueAccent,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(60),
                          bottomRight: Radius.circular(60),
                        ),
                      ),

                      child: Image.asset(
                        'assets/images/medical_icon.png',
                        height: 80,
                        width: 80,
                        fit: BoxFit.contain,

                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.local_hospital,
                            color: Colors.white,
                            size: 80,
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 15),

                    // ==================================================
                    // WELCOME
                    // ==================================================
                    const Padding(
                      padding: EdgeInsets.only(left: 30),
                      child: Text(
                        "Welcome Back",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.2,
                          fontSize: 30,
                          color: Colors.black,
                        ),
                      ),
                    ),

                    const Padding(
                      padding: EdgeInsets.only(left: 30),
                      child: Text(
                        "Please login to your account",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Colors.black87,
                        ),
                      ),
                    ),

                    // ==================================================
                    // FORM
                    // ==================================================
                    Form(
                      key: _formKey,

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          // ============================================
                          // EMAIL
                          // ============================================

                          const Padding(
                            padding: EdgeInsets.all(15),
                            child: Text(
                              "Email:",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.only(left: 18, right: 18),

                            child: TextFormField(
                              controller: _emailController,

                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,

                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Please enter a valid email';
                                }

                                if (!value.contains('@') ||
                                    !value.contains('.')) {
                                  return 'Please enter a valid email';
                                }

                                return null;
                              },

                              keyboardType: TextInputType.emailAddress,

                              decoration: InputDecoration(
                                hintText: "Enter your Email",

                                prefixIcon: const Icon(
                                  Icons.email,
                                  color: Colors.blueAccent,
                                ),

                                filled: true,

                                fillColor: const Color.fromARGB(
                                  255,
                                  223,
                                  235,
                                  255,
                                ),

                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                          ),

                          // ============================================
                          // PASSWORD
                          // ============================================
                          const Padding(
                            padding: EdgeInsets.all(15),
                            child: Text(
                              "Password:",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.only(left: 18, right: 18),

                            child: TextFormField(
                              controller: _passwordController,

                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,

                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Enter your Password';
                                }

                                if (value.length < 6) {
                                  return 'Password must be at least 6 characters';
                                }

                                return null;
                              },

                              obscureText: _obscurePassword,

                              decoration: InputDecoration(
                                hintText: "Enter your Password",

                                prefixIcon: const Icon(
                                  Icons.lock_outline,
                                  color: Colors.blueAccent,
                                ),

                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined,
                                    color: Colors.blueAccent,
                                  ),

                                  onPressed: () {
                                    setState(() {
                                      _obscurePassword = !_obscurePassword;
                                    });
                                  },
                                ),

                                filled: true,

                                fillColor: const Color.fromARGB(
                                  255,
                                  223,
                                  235,
                                  255,
                                ),

                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                          ),

                          // ============================================
                          // FORGOT PASSWORD
                          // ============================================
                          Align(
                            alignment: Alignment.centerRight,

                            child: TextButton(
                              onPressed: () async {
                                final email = _emailController.text.trim();

                                if (email.isEmpty ||
                                    !email.contains('@') ||
                                    !email.contains('.')) {
                                  _showMessage(
                                    'Please enter your email first.',
                                    isError: true,
                                  );
                                  return;
                                }

                                try {
                                  await FirebaseAuth.instance
                                      .sendPasswordResetEmail(email: email);

                                  _showMessage(
                                    'Password reset email sent.',
                                    isError: false,
                                  );
                                } on FirebaseAuthException catch (e) {
                                  _showMessage(
                                    e.message ?? 'Unable to send reset email.',
                                    isError: true,
                                  );
                                }
                              },

                              child: const Text(
                                "Forget Password?",
                                style: TextStyle(
                                  color: Colors.blueAccent,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),

                          // ============================================
                          // LOGIN BUTTON
                          // ============================================
                          Padding(
                            padding: const EdgeInsets.all(17),

                            child: Align(
                              alignment: Alignment.center,

                              child: ElevatedButton(
                                onPressed: _isLoading ? null : _loginUser,

                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blueAccent,

                                  foregroundColor: Colors.white,

                                  minimumSize: const Size(double.infinity, 52),

                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),

                                child: _isLoading
                                    ? const SizedBox(
                                        width: 25,
                                        height: 25,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 3,
                                        ),
                                      )
                                    : const Text(
                                        "Login",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 25,
                                        ),
                                      ),
                              ),
                            ),
                          ),

                          // ============================================
                          // REGISTER
                          // ============================================
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,

                            children: [
                              const Text(
                                "Don't have an account?",
                                style: TextStyle(
                                  color: Color.fromARGB(255, 141, 141, 141),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),

                              TextButton(
                                onPressed: _isLoading
                                    ? null
                                    : () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const RegistrationScreen(),
                                          ),
                                        );
                                      },

                                child: const Text(
                                  "Register",
                                  style: TextStyle(
                                    color: Colors.blueAccent,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 10),
                        ],
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
