import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'api_config.dart';

class AiChat extends StatefulWidget {
  const AiChat({super.key});

  @override
  State<AiChat> createState() => _AiChatState();
}

class _AiChatState extends State<AiChat> {
  final List<Map<String, String>> messages = [];

  final TextEditingController messageController =
  TextEditingController();

  bool isLoading = false;

  // ============================================================
  // SEND MESSAGE TO OPENROUTER
  // ============================================================
  Future<String> sendMessage(
      List<Map<String, String>> messages) async {
    final response = await http.post(
      Uri.parse(
        'https://openrouter.ai/api/v1/chat/completions',
      ),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $openRouterApiKey',
      },
      body: jsonEncode({
        'model': 'openai/gpt-4o-mini',
        'messages': messages,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception(
        'API Error ${response.statusCode}: ${response.body}',
      );
    }

    final data = jsonDecode(response.body);

    final reply =
    data['choices']?[0]?['message']?['content'];

    if (reply == null) {
      throw Exception('Invalid response from AI.');
    }

    return reply.toString();
  }

  // ============================================================
  // SEND USER MESSAGE
  // ============================================================
  Future<void> sendMessageToAI() async {
    final userMessage =
    messageController.text.trim();

    if (userMessage.isEmpty || isLoading) {
      return;
    }

    setState(() {
      messages.add({
        'role': 'user',
        'content': userMessage,
      });

      messageController.clear();
      isLoading = true;
    });

    try {
      final aiReply = await sendMessage(messages);

      if (!mounted) return;

      setState(() {
        messages.add({
          'role': 'assistant',
          'content': aiReply,
        });

        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Unable to connect to AI.',
          ),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );

      debugPrint('AI Error: $e');
    }
  }

  // ============================================================
  // DISPOSE
  // ============================================================
  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  // ============================================================
  // BUILD
  // ============================================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(10),
          ),
        ),

        backgroundColor: Colors.blueAccent,

        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.menu),
          color: Colors.white,
          iconSize: 30,
        ),

        titleSpacing: 0,

        title: const Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: Colors.white,
              child: Icon(
                Icons.smart_toy,
                color: Colors.blueAccent,
              ),
            ),

            SizedBox(width: 20),

            Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  "MediBook AI",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                ),

                Text(
                  "Your Personal Health Assistant",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ],
        ),

        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                messages.clear();
              });
            },
            icon: const Icon(Icons.delete),
            color: Colors.white,
            iconSize: 30,
          ),

          const Padding(
            padding: EdgeInsets.only(right: 10),
            child: Center(
              child: Text(
                "Clear Chat",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ],
      ),

      // ==========================================================
      // BODY
      // ==========================================================
      body: Container(
        color: Colors.blue[50],

        child: Column(
          children: [
            // ======================================================
            // CHAT MESSAGES
            // ======================================================
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(20),

                children: [
                  // ------------------------------------------------
                  // WELCOME MESSAGE
                  // ------------------------------------------------
                  Align(
                    alignment: Alignment.centerLeft,

                    child: Container(
                      width: 350,

                      margin: const EdgeInsets.only(
                        bottom: 15,
                      ),

                      padding: const EdgeInsets.all(8),

                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                        BorderRadius.circular(12),
                      ),

                      child: Row(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,

                        children: [
                          const CircleAvatar(
                            radius: 20,
                            backgroundColor:
                            Colors.blueAccent,

                            child: Icon(
                              Icons.smart_toy,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),

                          const SizedBox(width: 20),

                          const Expanded(
                            child: Text(
                              "Hello! How can I help you?",
                              style: TextStyle(
                                color: Color(0xFF4A3438),
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // ------------------------------------------------
                  // USER + AI MESSAGES
                  // ------------------------------------------------
                  ...messages.map((message) {
                    final bool isUser =
                        message['role'] == 'user';

                    if (isUser) {
                      return Align(
                        alignment: Alignment.centerRight,

                        child: Container(
                          margin: const EdgeInsets.only(
                            bottom: 15,
                          ),

                          padding:
                          const EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 15,
                          ),

                          decoration: BoxDecoration(
                            color: Colors.blue[200],
                            borderRadius:
                            BorderRadius.circular(12),
                          ),

                          child: Text(
                            message['content'] ?? '',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      );
                    }

                    return Align(
                      alignment: Alignment.centerLeft,

                      child: Container(
                        margin: const EdgeInsets.only(
                          bottom: 15,
                        ),

                        padding:
                        const EdgeInsets.all(8),

                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                          BorderRadius.circular(12),
                        ),

                        child: Row(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,

                          children: [
                            const CircleAvatar(
                              radius: 20,
                              backgroundColor:
                              Colors.blueAccent,

                              child: Icon(
                                Icons.smart_toy,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),

                            const SizedBox(width: 20),

                            Expanded(
                              child: Text(
                                message['content'] ?? "",
                                style: const TextStyle(
                                  color:
                                  Color(0xFF4A3438),
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),

                  // ------------------------------------------------
                  // LOADING INDICATOR
                  // ------------------------------------------------
                  if (isLoading)
                    const Align(
                      alignment: Alignment.centerLeft,

                      child: Padding(
                        padding: EdgeInsets.only(
                          top: 5,
                          bottom: 15,
                        ),

                        child: CircularProgressIndicator(
                          color: Colors.blueAccent,
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // ======================================================
            // MESSAGE INPUT
            // ======================================================
            Padding(
              padding: const EdgeInsets.all(12),

              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: messageController,

                      decoration: InputDecoration(
                        hintText: "Type a Message",

                        hintStyle: const TextStyle(
                          color: Colors.blueAccent,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),

                        prefixIcon: const Icon(
                          Icons.emoji_emotions_outlined,
                          color: Colors.blueAccent,
                          size: 30,
                        ),

                        suffixIcon: const Icon(
                          Icons.attach_file,
                          color: Colors.blueAccent,
                          size: 30,
                        ),

                        border: OutlineInputBorder(
                          borderRadius:
                          BorderRadius.circular(15),

                          borderSide:
                          const BorderSide(
                            color: Colors.blueAccent,
                            width: 1,
                          ),
                        ),

                        focusedBorder:
                        OutlineInputBorder(
                          borderRadius:
                          BorderRadius.circular(15),

                          borderSide:
                          const BorderSide(
                            color: Colors.blueAccent,
                            width: 1.5,
                          ),
                        ),
                      ),

                      onFieldSubmitted: (_) {
                        sendMessageToAI();
                      },
                    ),
                  ),

                  const SizedBox(width: 10),

                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.blueAccent,
                      shape: BoxShape.circle,
                    ),

                    child: IconButton(
                      onPressed: isLoading
                          ? null
                          : sendMessageToAI,

                      icon: const Icon(
                        Icons.send,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}