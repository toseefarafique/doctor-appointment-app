import 'package:flutter/material.dart';
import 'Chat_Screen.dart';
import 'Doctor_Profile1.dart';
import 'My_Appointments.dart';
import 'Profile.dart';
import 'Search_screen.dart';

class homePage extends StatefulWidget {
  const homePage({super.key});

  @override
  State<homePage> createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child:Column(
          children: [
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.blueAccent,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),

              )
            ),
            child: Padding(padding: EdgeInsets.all(20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child:Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Hi, Sana",style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                ),),
                Text("How are you today?",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),),
                  SizedBox(height: 30),
              TextField(
                decoration: InputDecoration(
                  hintText: "Search doctors, clinics...",
                  prefixIcon: IconButton(onPressed: (){
                  Navigator.push(context,
                   MaterialPageRoute(builder: (context)=> const Search_screen()));
                  }, 
                  icon: Icon(Icons.search,
                  color: Colors.blueAccent,
                  size: 30)),
                filled: true,
                fillColor: Colors.white,
                border:OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                )  
                ),
                
              )
                
              ],
            ),
                ),
            SizedBox(width: 8),
          IconButton(onPressed: (){}, 
            icon: Icon(Icons.notifications,
            color: Colors.white,
            size: 30,))
           
              ],
             
            ),
            ),
            
          ),
         Padding(padding: EdgeInsets.all(18),
         child: Container(
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 210, 223, 247),
          borderRadius: BorderRadius.all(
            Radius.circular(12),
          )
          ),
          child: Padding(padding: EdgeInsets.only(top: 5),
          child: Row(
            children: [
              Padding(padding: EdgeInsetsGeometry.only(left: 20),
               child:Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 Text("Book Appointment",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 28,
              ),),
              Text("Consult with expert doctors",
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),),
              SizedBox(height: 20),
              ElevatedButton(onPressed: (){},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                   Radius.circular(8),
                  )
                )
              ),
               child: Text("Book Now!",
               style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
               ),))
              ],
             ),),
            
            Spacer(),
             Image.asset('assets/images/Doctor_pic.png',
             height: 170,
            
             fit: BoxFit.contain,),
             
            ],
          ),
          ),
         ),),
        Padding(padding: EdgeInsets.only(left: 20,right: 20),
         child:Row(
          children: [
            Text("Specialities",
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),),
            Spacer(),
            TextButton(onPressed: (){},
             child:Text("See All",
             style: TextStyle(
              color: Colors.blueAccent,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
             )
             
             )
          ],
         )),
         Padding(padding: EdgeInsets.only(left: 18,right: 18),
         child: Container(
          child: Padding(padding: EdgeInsets.all(10),
          child: Row(
            children: [
        Expanded(
      child: GestureDetector(
        onTap: () {
          // Cardiologist screen
        },
        child: Container(
          height: 100,
          decoration: BoxDecoration(
            color: const Color(0xFFE3EDFF),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.favorite_border,
                color: Colors.blueAccent,
                size: 35,
              ),
              SizedBox(height: 8),
              Text(
                "Cardiologist",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    ),

    SizedBox(width: 12),

    Expanded(
      child: GestureDetector(
        onTap: () {
          // Dermatologist screen
        },
        child: Container(
          height: 100,
          decoration: BoxDecoration(
            color: const Color(0xFFE3EDFF),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.face_retouching_natural,
                color: Colors.blueAccent,
                size: 35,
              ),
              SizedBox(height: 8),
              Text(
                "Dermatologist",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
     SizedBox(width: 12),

    Expanded(
      child: GestureDetector(
        onTap: () {
          // Dermatologist screen
        },
        child: Container(
          height: 100,
          decoration: BoxDecoration(
            color: const Color(0xFFE3EDFF),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.psychology,
                color: Colors.blueAccent,
                size: 35,
              ),
              SizedBox(height: 8),
              Text(
                "Neurologist",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
     SizedBox(width: 12),

    Expanded(
      child: GestureDetector(
        onTap: () {
          // Dermatologist screen
        },
        child: Container(
          height: 100,
          decoration: BoxDecoration(
            color: const Color(0xFFE3EDFF),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.remove_red_eye,
                color: Colors.blueAccent,
                size: 35,
              ),
              SizedBox(height: 8),
              Text(
                "Eye Spacialist",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  ],
),
            
          ),),
          
         ),
       Padding(padding: EdgeInsets.all(15),
        child:Align(
          alignment: Alignment.centerLeft,
          child: Text("Top Doctors",
          style: TextStyle(color:Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 25),),
        ),),
      Padding(padding: EdgeInsets.only(left: 20,right: 20),
      child:Container(
  width: double.infinity,
  padding: const EdgeInsets.all(15),
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(15),
    boxShadow: [
      BoxShadow(
        color: Colors.grey.withOpacity(0.15),
        blurRadius: 8,
        spreadRadius: 2,
      ),
    ],
  ),
  child: Row(
    children: [
      Container(
        height: 90,
        width: 90,
        decoration: BoxDecoration(
          color: const Color(0xFFE3EDFF),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Image.asset(
          'assets/images/Doctor1.png',
          fit: BoxFit.contain,
        ),
      ),

      const SizedBox(width: 15),

      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Dr. Ayesha Khan",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 5),

            const Text(
              "Cardiologist",
              style: TextStyle(
                color: Colors.blueAccent,
                fontSize: 14,
              ),
            ),

            const SizedBox(height: 7),

            const Row(
              children: [
                Icon(
                  Icons.star,
                  color: Colors.amber,
                  size: 18,
                ),
                SizedBox(width: 4),
                Text(
                  "4.8",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 12),
                Text(
                  "5 Years Exp.",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),

   IconButton(onPressed: (){
    Navigator.push(context,
     MaterialPageRoute(builder: (context)=> const Doctor_profile1()));
   },
    icon: Icon(Icons.arrow_forward_ios,
    color: Colors.blueAccent,
    size: 18,))
    ],
  ),
),  
         ),
         Padding(padding: EdgeInsets.all(15),
         child:Container(
  width: double.infinity,
  padding: const EdgeInsets.all(15),
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(15),
    boxShadow: [
      BoxShadow(
        color: Colors.grey.withOpacity(0.15),
        blurRadius: 8,
        spreadRadius: 2,
      ),
    ],
  ),
  child: Row(
    children: [
      Container(
        height: 90,
        width: 90,
        decoration: BoxDecoration(
          color: const Color(0xFFE3EDFF),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Image.asset(
          'assets/images/Doctor2.png',
          fit: BoxFit.contain,
        ),
      ),

      const SizedBox(width: 15),

      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Dr. Ahmed Hussain",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 5),

            const Text(
              "Dermatologist",
              style: TextStyle(
                color: Colors.blueAccent,
                fontSize: 14,
              ),
            ),

            const SizedBox(height: 7),

            const Row(
              children: [
                Icon(
                  Icons.star,
                  color: Colors.amber,
                  size: 18,
                ),
                SizedBox(width: 4),
                Text(
                  "3.8",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 12),
                Text(
                  "8 Years Exp.",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),

     IconButton(onPressed: (){},
      icon: Icon(Icons.arrow_forward_ios,
    color: Colors.blueAccent,
    size: 18,))
    ],
  ),
),),
Padding(padding: EdgeInsetsGeometry.all(15),
child:Container(
  width: double.infinity,
  padding: const EdgeInsets.all(15),
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(15),
    boxShadow: [
      BoxShadow(
        color: Colors.grey.withOpacity(0.15),
        blurRadius: 8,
        spreadRadius: 2,
      ),
    ],
  ),
  child: Row(
    children: [
      Container(
        height: 90,
        width: 90,
        decoration: BoxDecoration(
          color: const Color(0xFFE3EDFF),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Image.asset(
          'assets/images/Doctor3.png',
          fit: BoxFit.contain,
        ),
      ),

      const SizedBox(width: 15),

      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Dr. Jiya Khan",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 5),

            const Text(
              "Neurologist",
              style: TextStyle(
                color: Colors.blueAccent,
                fontSize: 14,
              ),
            ),

            const SizedBox(height: 7),

            const Row(
              children: [
                Icon(
                  Icons.star,
                  color: Colors.amber,
                  size: 18,
                ),
                SizedBox(width: 4),
                Text(
                  "4.6",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 12),
                Text(
                  "4 Years Exp.",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),

      IconButton(onPressed: (){},
      icon: Icon(Icons.arrow_forward_ios,
    color: Colors.blueAccent,
    size: 18,))
    ],
  ),
),),
Padding(padding: EdgeInsets.all(15),
child: Container(
  width: double.infinity,
  padding: const EdgeInsets.all(15),
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(15),
    boxShadow: [
      BoxShadow(
        color: Colors.grey.withOpacity(0.15),
        blurRadius: 8,
        spreadRadius: 2,
      ),
    ],
  ),
  child: Row(
    children: [
      Container(
        height: 90,
        width: 90,
        decoration: BoxDecoration(
          color: const Color(0xFFE3EDFF),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Image.asset(
          'assets/images/Doctor4.png',
          fit: BoxFit.contain,
        ),
      ),

      const SizedBox(width: 15),

      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Dr. Muhammad Umer",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 5),

            const Text(
              "Eye Spacialists",
              style: TextStyle(
                color: Colors.blueAccent,
                fontSize: 14,
              ),
            ),

            const SizedBox(height: 7),

            const Row(
              children: [
                Icon(
                  Icons.star,
                  color: Colors.amber,
                  size: 18,
                ),
                SizedBox(width: 4),
                Text(
                  "4.2",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 12),
                Text(
                  "2 Years Exp.",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),

      IconButton(onPressed: (){},
      icon: Icon(Icons.arrow_forward_ios,
    color: Colors.blueAccent,
    size: 18,))
    ],
  ),
),),
          ],
        )
      ),
     bottomNavigationBar: BottomNavigationBar(
      currentIndex: 0,
      onTap: (index){
        if(index ==1){
          Navigator.push(context,
           MaterialPageRoute(builder: (context) =>const MyAppointments()));
        }
        if(index ==2){
          Navigator.push(context,
          MaterialPageRoute(builder: (context)=> const AiChat()));
        }
        if(index ==3){
          Navigator.push(context,
          MaterialPageRoute(builder: (context)=> const profile()));
        }
      },
      selectedItemColor: Colors.blueAccent,
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed,
      
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined,),
        activeIcon: Icon(Icons.home),
        label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.calendar_month_outlined),
        activeIcon: Icon(Icons.calendar_month),
        label: "Appointmennt"),
        BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline),
        activeIcon: Icon(Icons.chat_bubble),
        label: "Chat"),
        BottomNavigationBarItem(icon: Icon(Icons.person_2_outlined),
        activeIcon: Icon(Icons.person_2),
        label: "Profille"),

        
      ],), 
    );
  }
}