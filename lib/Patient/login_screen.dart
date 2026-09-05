import 'package:flutter/material.dart';
import 'Home_Screen.dart';
import 'Registration_Screen.dart';
import 'package:firebase_auth/firebase_auth.dart';


class login_screen extends StatefulWidget {
  const login_screen({super.key});

  @override
  State<login_screen> createState() => _login_screenState();
}

class _login_screenState extends State<login_screen> {
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
return Scaffold(
  body: SingleChildScrollView(
    child: Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 220,
            width: double.infinity,
           
            decoration: BoxDecoration(
               color: Colors.blueAccent,
            borderRadius:BorderRadius.only(
              bottomLeft:Radius.circular(60),
              bottomRight: Radius.circular(60),
            )
            ),
            child:Image.asset('assets/images/medical_icon.png',
            height: 15,
            width: 15,
            fit: BoxFit.contain,),),
          SizedBox(height: 10),
         Padding(padding: EdgeInsetsGeometry.only(left: 30),
          child:Text("Welcome Back",
          style: TextStyle(fontWeight: FontWeight.bold,
          letterSpacing: 0.2,
          fontSize: 30,
          ),
          ),),
         Padding(padding: EdgeInsets.only(left:30),
           child:Text("Please login to your account",
          style: TextStyle(fontWeight: FontWeight.bold,
          fontSize:15 ),)),
         
         Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(padding: EdgeInsets.all(15),
         child: Text("Email:",
         style: TextStyle(
         fontWeight: FontWeight.bold,
         fontSize: 20),),),
        
         Padding(padding: EdgeInsets.only(left: 18,right: 18),
          child:TextFormField(
            controller: _emailController,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value){
              if(value==null ||value.trim().isEmpty){
                return 'Please enter a valid email';
              }
              if(!value.contains('@')){
                return 'Please enter a valid email';
              }
              return null;
            },
            
            keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            
            hintText: "Enter your Email",
            prefixIcon: Icon(Icons.email,
            color: Colors.blueAccent,),
            filled: true,
            fillColor: const Color.fromARGB(255, 223, 235, 255),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            )
          ),
          ),),
         Padding(padding: EdgeInsets.all(15),
         child: Text("Password:",
         style: TextStyle(
         fontWeight: FontWeight.bold,
         fontSize: 20),),),
        
       Padding(padding: EdgeInsets.only(left: 18,right: 18),

        child:TextFormField(
          controller: _passwordController,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (value) {
            if(value==null || value.trim().isEmpty){
              return 'Enter your Password';
            }
          if(value.length<6){
            return 'Password must be at least 6 characters';
          }  
     return null;
  },
  
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
        ),)
          ),
          SizedBox(height: 5),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(onPressed: (){},
           child: Text("Forget Password?",
           style: TextStyle(color: Colors.blueAccent,
           fontWeight: FontWeight.w500),)),
        ),
      Padding(padding: EdgeInsets.all(17),
       child: Align(alignment: AlignmentGeometry.center,
        child:ElevatedButton(
           onPressed: () async {
  if (_formKey.currentState!.validate()) {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const homePage(),
        ),
      );
    } on FirebaseAuthException catch (e) {
      debugPrint("Firebase Auth Error Code: ${e.code}");
  debugPrint("Firebase Auth Error Message: ${e.message}");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("${e.code}: ${e.message}"),
        ),
      );
    }
  }
},
        style: ElevatedButton.styleFrom(
          backgroundColor:Colors.blueAccent,
          foregroundColor: Colors.white,
          minimumSize: Size(double.infinity,52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          )
        ),
         child: Text("Login",
         style: TextStyle(
          color: Colors.white,
         fontWeight: FontWeight.bold,
         fontSize: 25),)),
        )),
       Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Don't have an account?",
          style: TextStyle(color: const Color.fromARGB(255, 141, 141, 141),
          fontWeight: FontWeight.bold,
          fontSize: 18),),
          TextButton(onPressed: (){
            setState(() {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context)=> const RegistrationScreen()),
              );
            });
          }, 
          child: Text("Register",
          style: TextStyle(
            color: Colors.blueAccent,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),))
        ],
       )

            ],
          ),
          )
         
         

        ],
      ),
    ),
  ),
);

  }
}
      
      