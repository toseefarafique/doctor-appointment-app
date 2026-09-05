

// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
   final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  final TextEditingController _passwordController = TextEditingController();
 final _confirmPasswordController = TextEditingController();
 final TextEditingController _nameController =TextEditingController();
 final TextEditingController _emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back,
        color: Colors.white,
        size: 30,),)
       ),
       body: SingleChildScrollView(
       child: Form(
        key: _formKey,
         child: Padding(padding: EdgeInsets.all(20),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Create Account",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 28,
              ),),
              Text("Please Register to Continue",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),),
              SizedBox(height: 15),
              Text("Full Name:",style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),),
             TextFormField(
            controller: _nameController,
            validator: (value){
              if(value==null ||value.trim().isEmpty){
                return 'Please enter your name';
              }
             return null;
            },
          
            keyboardType: TextInputType.name,
          decoration: InputDecoration(
            
            hintText: "Enter your full name",
            prefixIcon: Icon(Icons.person,
            color: Colors.blueAccent,),
            filled: true,
            fillColor: const Color.fromARGB(255, 223, 235, 255),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            )
          ),
          ),

           SizedBox(height: 15),
              Text("Email:",style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),),
             TextFormField(
            controller: _emailController,
            validator: (value){
              if(value==null ||value.trim().isEmpty){
                return 'Please enter a valid email';
              }
              if(!value.contains('@')){
                return 'Please anter a valid email';
              }
             return null;
            },
          
            keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            
            hintText: "Enter your Email",
            prefixIcon: Icon(Icons.email_outlined,
            color: Colors.blueAccent,),
            filled: true,
            fillColor: const Color.fromARGB(255, 223, 235, 255),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            )
          ),
          ),

           SizedBox(height: 15),
              Text("Password:",style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),),
            TextFormField(
          
          validator: (value) {
            if(value==null || value.trim().isEmpty){
              return 'Enter your Password';
            }
          if(value.length<6){
            return 'Password must be at least 6 characters';
          }  
     return null;
  },
          controller: _passwordController,
          obscureText: _obscurePassword,
        decoration: InputDecoration(
          hintText: "Enter your Password",
          prefixIcon: Icon(Icons.lock_outline,
          color: Colors.blueAccent,),
          suffixIcon:IconButton(
           icon:Icon(_obscurePassword
          ?Icons.visibility_outlined
          :Icons.visibility_off_outlined,
          color: Colors.blueAccent,
          ),
          onPressed: (){
            setState(() {
              _obscurePassword =!_obscurePassword;
            });
          },),
          
          filled: true,
          fillColor: const Color.fromARGB(255, 223, 235, 255),
           border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            )
        ),),

        SizedBox(height: 15),
              Text("Confirm Password:",style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),),
            TextFormField(
          validator: (value) {
            if(value==null || value.trim().isEmpty){
              return 'Enter your Password';
            }
          if(value != _passwordController.text){
            return 'Password do not match';
          }  
     return null;
  },
          controller: _confirmPasswordController,
          obscureText: _obscurePassword,
        decoration: InputDecoration(
          hintText: "Confirm your Password",
          prefixIcon: Icon(Icons.lock_outline,
          color: Colors.blueAccent,),
          suffixIcon:IconButton(
           icon:Icon(_obscurePassword
          ?Icons.visibility_outlined
          :Icons.visibility_off_outlined,
          color: Colors.blueAccent,
          ),
          onPressed: (){
            setState(() {
              _obscurePassword =!_obscurePassword;
            });
          },),
          
          filled: true,
          fillColor: const Color.fromARGB(255, 223, 235, 255),
           border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            )
        ),),
        SizedBox(height: 60),
        ElevatedButton(onPressed: ()async{
        if(_formKey.currentState!.validate()){
          try{
            UserCredential userCredential=
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
              email: _emailController.text.trim(),
              password: _passwordController.text.trim(),
            );
            await FirebaseFirestore.instance
            .collection('users')
             .doc(userCredential.user!.uid)
            .set({
          'name': _nameController.text.trim(),
          'email': _emailController.text.trim(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Registration successful!"),
          ),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const login_screen(),
          ),
        );
      } on FirebaseAuthException catch (e) {
        print("Firebase Auth Error:${e.code}");
        print("Firebase Auth Message: ${e.message}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Error: ${e.code} - ${e.message}",
          ),
          )
        );


          }
        }
        }, 
        
        style: ElevatedButton.styleFrom(
          elevation: 5,
          backgroundColor: Colors.white,
          foregroundColor: Colors.blueAccent,
        minimumSize: Size(double.infinity,60),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          )
        ),
         child: Text("Register",style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 25,
         ),)),
         SizedBox(height: 5),
         Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
      
            Text("Already have an account?",style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),),
            TextButton(onPressed: (){
             Navigator.pop(context);
            },
             child: Text("Login",style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
             ),))
          ],
         )
            ],
          ),),
       ),
          
        ),
       
    );
  }
}