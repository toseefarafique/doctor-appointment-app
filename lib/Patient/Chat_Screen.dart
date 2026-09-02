import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'api_config.dart';


class ai_chat extends StatefulWidget {
  const ai_chat({super.key});

  @override
  State<ai_chat> createState() => _ai_chatState();
}

class _ai_chatState extends State<ai_chat> {
  Future<String> sendMessage(List<Map<String, String>> messages) async {
  final response = await http.post(
    Uri.parse('https://openrouter.ai/api/v1/chat/completions'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $openRouterApiKey',
    },
    body: jsonEncode({
      'model': 'openai/gpt-4o-mini',
      'messages': messages,
    }),
  );

  final data = jsonDecode(response.body);

  return data['choices'][0]['message']['content'];
}
Future<void> sendMessageToAI() async {
  try{
  String userMessage = messageController.text.trim();

  if (userMessage.isEmpty) {
    return;
  }
  

  messages.add({
    'role': 'user',
    'content': userMessage,
  });

  messageController.clear();

  String aiReply = await sendMessage(messages);
  setState(() {
    isLoading = false;
  });
  
  print(aiReply);
  messages.add({
    'role': 'assistant',
    'content': aiReply,
  });

  setState(() {});
  }catch(e){
    print(e);
    setState(() {
        isLoading = false;
      
        }); 
                    
  }
}
final List<Map<String,String>> messages = [];
final TextEditingController messageController = TextEditingController();
bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.vertical(
            bottom:Radius.circular(10),
          )
        ),
        backgroundColor: Colors.blueAccent,
      leading: IconButton(onPressed: (){}, 
      icon:Icon(Icons.menu),
      color: Colors.white,
      iconSize: 30,),
    
      titleSpacing: 0,

       title: Row(
         children: [
           CircleAvatar(
            radius: 20,
            backgroundColor: Colors.white,
            child: Icon(Icons.smart_toy,
            color: Colors.blueAccent),
           ),
           SizedBox(width: 20),
           Padding(padding: EdgeInsets.all(2),
           child:  Column(
            crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("MediBook AI",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 25),),
          Text("Your Personal Health Assistant",style: TextStyle(color: Colors.white,fontSize: 16),),

            
        ],
       ),),
         ],
       ),
      
      
      actions: [
        Row(
          children: [
            IconButton(
              onPressed: (){
                messages.clear();
                setState(() {
                  
                });
              },
              icon: Icon(Icons.delete),
              color: Colors.white,
              iconSize: 30,
            ),
           Padding(padding: EdgeInsets.only(right: 10),
            child:Text("Clear Chat",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 15),))
          ],
        ),
      ],  
      ),

      body:Container(
        color: Colors.blue[50],
       child:Column(
        
        children: [
          Expanded(
            child:ListView(
              padding: EdgeInsets.all(20),
                
            
                 children: [
             
                Align(
                  alignment: Alignment.centerLeft,
                
                child:Container(
                  width: 350,
                  margin: EdgeInsetsDirectional.only(bottom: 15),
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.blueAccent,
                        child: Icon(Icons.smart_toy,
                        color: Colors.white,
                        size: 20,),
                   ),
                   SizedBox(width: 20),
                   Expanded(child: Text("Hello! How can I help you?",
                   style: TextStyle(
                    color:Color(0xFF4A3438),
                    fontSize: 20,
                   ),),
                   )
                    ],
                  ),
                ),
                ),
                ...messages.map((message){
                  if(isLoading){
                    return Align(
                      alignment: Alignment.center,
                      child: Padding(padding: EdgeInsets.only(bottom: 15),
                      child: CircularProgressIndicator(
                        color: Colors.blueAccent,
                      ),),
                    );
                  }
                  bool isUser = message['role'] == 'user';
                  if(isUser){
                    return Align(
                            alignment: Alignment.centerRight,
                       child: Container(
                      margin: EdgeInsetsDirectional.only(bottom: 15),
                 padding: EdgeInsets.symmetric(
                 vertical: 10,
                horizontal: 15,
               ),
           decoration: BoxDecoration(
        color:  Colors.blue[200],
                borderRadius: BorderRadius.circular(12),
               ),
               child: Text(message['content'] ?? '',
            style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
             fontSize: 18,
          ),),
                       ),
                  );
                    
                  }
                  return Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                    
                      margin: EdgeInsets.all(15),
                      padding: EdgeInsetsGeometry.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundColor: Colors.blueAccent,
                            child: Icon(Icons.smart_toy,
                            color: Colors.white,
                            size: 20,
                          ),),
                          SizedBox(width: 20),
                          Expanded(
                            child: Text(
                            message['content'] ?? "",
                            style: TextStyle(
                              color: Color(0xFF4A3438),
                              fontSize: 18,
                            ),

                          ))
                        ],
                      ),
                    ),
                  );
                }).toList(),
             
              ],),
            ), 
            Padding(padding: EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: messageController,
                    decoration: InputDecoration(
                      hintText: "Type a Message",hintStyle: TextStyle(
                         color:  Colors.blueAccent,
                         fontSize: 20,
                         fontWeight: FontWeight.bold,
                      ),

                      prefixIcon: Icon(
                        Icons.emoji_emotions_outlined,
                        color:  Colors.blueAccent,
                        size: 30,
                      ),
                      suffixIcon: Icon(
                        Icons.attach_file,
                         color:  Colors.blueAccent,
                         size: 30,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(
                          color:  Colors.blueAccent,
                          width: 8,
                        ),),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                            color: Colors.blueAccent,
                            width: 1.5,
                          )
                        )
                    ),
                  )),
                  SizedBox(width: 10),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(onPressed: (){
                      setState(() {
                        isLoading =true;
                      
                      });
                    sendMessageToAI();

                    }, 
                    icon: Icon(Icons.send,
                    color: Colors.white,
                    size: 30,),
                    ),
                  )
              ],
            ),)
          
        ],
      ),
      ),
    );
  }
}