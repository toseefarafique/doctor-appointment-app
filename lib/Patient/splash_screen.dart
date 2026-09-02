import 'package:flutter/material.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState(){
    super.initState();

  Future.delayed(
    Duration(seconds: 3),
    (){
      Navigator.pushReplacement(context,
      MaterialPageRoute(builder: (context) =>const login_screen()),);
    }

  );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/Medi_Book.png',
            width: 300,
            height: 300,
            fit: BoxFit.contain,
            ),
          SizedBox(height: 60),
          Padding(padding: EdgeInsetsGeometry.symmetric(horizontal: 70),
          child: LinearProgressIndicator(
            
            color: Colors.blueAccent,
            minHeight: 6,
            borderRadius: BorderRadius.circular(20),
          ),)
      
            
          
         
             
          ],
        ),
      ),
    );

  }
}
// }   width: 50,
//             height: 50,
//             fit: BoxFit.contain