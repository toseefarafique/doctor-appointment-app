import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login_screen.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();

  // ============================================================
  // SCAFFOLD MESSENGER KEY
  // Keeps SnackBars INSIDE the mobile frame
  // ============================================================

  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
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

          // Keeps SnackBar inside the mobile frame
          margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),

          duration: const Duration(seconds: 3),
        ),
      );
  }

  // ============================================================
  // REGISTER USER
  // ============================================================

  Future<void> _registerUser() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final String name = _nameController.text.trim();

      final String email = _emailController.text.trim();

      final String password = _passwordController.text.trim();

      // --------------------------------------------------------
      // 1. CREATE USER IN FIREBASE AUTHENTICATION
      // --------------------------------------------------------

      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      final User? user = userCredential.user;

      if (user == null) {
        throw Exception("User account could not be created.");
      }

      // --------------------------------------------------------
      // 2. SAVE USER INFORMATION IN USERS COLLECTION
      // --------------------------------------------------------

      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'name': name,
        'email': email,
        'role': 'patient',
        'createdAt': FieldValue.serverTimestamp(),
      });

      // --------------------------------------------------------
      // 3. SAVE PATIENT INFORMATION IN PATIENTS COLLECTION
      // --------------------------------------------------------

      await FirebaseFirestore.instance.collection('patients').doc(user.uid).set(
        {
          'name': name,
          'email': email,
          'createdAt': FieldValue.serverTimestamp(),
        },
      );

      if (!mounted) return;

      // --------------------------------------------------------
      // 4. SUCCESS MESSAGE
      // --------------------------------------------------------

      _showMessage("Account created successfully!", isError: false);

      // --------------------------------------------------------
      // 5. GO TO LOGIN
      // --------------------------------------------------------

      await Future.delayed(const Duration(milliseconds: 800));

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const login_screen()),
      );
    }
    // ==========================================================
    // FIREBASE ERRORS
    // ==========================================================
    on FirebaseAuthException catch (e) {
      String message = "Registration failed.";

      if (e.code == 'email-already-in-use') {
        message = "This email is already registered.";
      } else if (e.code == 'invalid-email') {
        message = "Please enter a valid email address.";
      } else if (e.code == 'weak-password') {
        message = "Password is too weak.";
      } else if (e.code == 'operation-not-allowed') {
        message = "Email/password authentication is not enabled.";
      } else if (e.code == 'network-request-failed') {
        message = "Network error. Please check your internet connection.";
      }

      if (!mounted) return;

      _showMessage(message, isError: true);
    }
    // ==========================================================
    // OTHER ERRORS
    // ==========================================================
    catch (e) {
      if (!mounted) return;

      _showMessage("Something went wrong. Please try again.", isError: true);
    }
    // ==========================================================
    // STOP LOADING
    // ==========================================================
    finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // ============================================================
  // UI
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,

      body: SafeArea(
        child: Center(
          child: Container(
            width: 600,

            constraints: const BoxConstraints(minHeight: 700, maxHeight: 900),

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

            // ==================================================
            // INNER SCAFFOLD MESSENGER
            // ==================================================
            child: ScaffoldMessenger(
              key: _scaffoldMessengerKey,

              child: Scaffold(
                backgroundColor: Colors.white,

                body: SingleChildScrollView(
                  child: Column(
                    children: [
                      // =====================================================
                      // TOP BLUE SECTION
                      // =====================================================

                      Container(
                        height: 170,
                        width: double.infinity,

                        decoration: const BoxDecoration(
                          color: Colors.blueAccent,

                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(60),
                            bottomRight: Radius.circular(60),
                          ),
                        ),

                        child: Stack(
                          children: [
                            // Back Button
                            Positioned(
                              top: 15,
                              left: 15,

                              child: IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },

                                icon: const Icon(
                                  Icons.arrow_back,
                                  color: Colors.white,
                                  size: 30,
                                ),
                              ),
                            ),

                            // Medical Icon
                            Center(
                              child: Image.asset(
                                'assets/images/medical_icon.png',

                                height: 75,
                                width: 75,

                                fit: BoxFit.contain,

                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(
                                    Icons.local_hospital,
                                    color: Colors.white,
                                    size: 75,
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // =====================================================
                      // TITLE
                      // =====================================================
                      const Align(
                        alignment: Alignment.centerLeft,

                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 35),

                          child: Text(
                            "Create Account",

                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 30,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),

                      const Align(
                        alignment: Alignment.centerLeft,

                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 35),

                          child: Text(
                            "Please register to continue",

                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // =====================================================
                      // FORM
                      // =====================================================
                      Form(
                        key: _formKey,

                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30),

                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,

                            children: [
                              // =================================================
                              // FULL NAME
                              // =================================================

                              const Text(
                                "Full Name:",

                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),

                              const SizedBox(height: 8),

                              TextFormField(
                                controller: _nameController,

                                keyboardType: TextInputType.name,

                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Please enter your full name';
                                  }

                                  return null;
                                },

                                decoration: InputDecoration(
                                  hintText: "Enter your full name",

                                  prefixIcon: const Icon(
                                    Icons.person_outline,
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

                              const SizedBox(height: 18),

                              // =================================================
                              // EMAIL
                              // =================================================
                              const Text(
                                "Email:",

                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),

                              const SizedBox(height: 8),

                              TextFormField(
                                controller: _emailController,

                                keyboardType: TextInputType.emailAddress,

                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Please enter your email';
                                  }

                                  if (!value.contains('@')) {
                                    return 'Please enter a valid email';
                                  }

                                  return null;
                                },

                                decoration: InputDecoration(
                                  hintText: "Enter your email",

                                  prefixIcon: const Icon(
                                    Icons.email_outlined,
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

                              const SizedBox(height: 18),

                              // =================================================
                              // PASSWORD
                              // =================================================
                              const Text(
                                "Password:",

                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),

                              const SizedBox(height: 8),

                              TextFormField(
                                controller: _passwordController,

                                obscureText: _obscurePassword,

                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Enter your password';
                                  }

                                  if (value.length < 6) {
                                    return 'Password must be at least 6 characters';
                                  }

                                  return null;
                                },

                                decoration: InputDecoration(
                                  hintText: "Enter your password",

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

                              const SizedBox(height: 18),

                              // =================================================
                              // CONFIRM PASSWORD
                              // =================================================
                              const Text(
                                "Confirm Password:",

                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),

                              const SizedBox(height: 8),

                              TextFormField(
                                controller: _confirmPasswordController,

                                obscureText: _obscureConfirmPassword,

                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Please confirm your password';
                                  }

                                  if (value != _passwordController.text) {
                                    return 'Passwords do not match';
                                  }

                                  return null;
                                },

                                decoration: InputDecoration(
                                  hintText: "Confirm your password",

                                  prefixIcon: const Icon(
                                    Icons.lock_outline,
                                    color: Colors.blueAccent,
                                  ),

                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscureConfirmPassword
                                          ? Icons.visibility_outlined
                                          : Icons.visibility_off_outlined,
                                      color: Colors.blueAccent,
                                    ),

                                    onPressed: () {
                                      setState(() {
                                        _obscureConfirmPassword =
                                            !_obscureConfirmPassword;
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

                              const SizedBox(height: 35),

                              // =================================================
                              // REGISTER BUTTON
                              // =================================================
                              SizedBox(
                                width: double.infinity,
                                height: 55,

                                child: ElevatedButton(
                                  onPressed: _isLoading ? null : _registerUser,

                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blueAccent,

                                    foregroundColor: Colors.white,

                                    disabledBackgroundColor: Colors.blueAccent
                                        .withValues(alpha: 0.6),

                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),

                                  child: _isLoading
                                      ? const SizedBox(
                                          height: 25,
                                          width: 25,

                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 3,
                                          ),
                                        )
                                      : const Text(
                                          "Register",

                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 23,
                                          ),
                                        ),
                                ),
                              ),

                              const SizedBox(height: 15),

                              // =================================================
                              // LOGIN
                              // =================================================
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,

                                children: [
                                  const Text(
                                    "Already have an account?",

                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),

                                  TextButton(
                                    onPressed: _isLoading
                                        ? null
                                        : () {
                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    const login_screen(),
                                              ),
                                            );
                                          },

                                    child: const Text(
                                      "Login",

                                      style: TextStyle(
                                        color: Colors.blueAccent,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 20),
                            ],
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
      ),
    );
  }
}
