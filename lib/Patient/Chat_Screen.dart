import 'dart:async';
import 'package:flutter/material.dart';

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
  // SEND MESSAGE
  // ============================================================

  Future<void> sendMessageToAI() async {
    final userMessage = messageController.text.trim();

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

    // Small delay so the loading indicator looks natural.
    await Future.delayed(const Duration(milliseconds: 700));

    if (!mounted) return;

    setState(() {
      isLoading = false;

      messages.add({
        'role': 'assistant',
        'content':
        'The AI assistant is currently unavailable. '
            'Please try again later or consult a doctor for medical advice.',
      });
    });
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
          child: Column(
            children: [
              // ==================================================
              // AI APP BAR
              // ==================================================

              Container(
                height: 90,
                decoration: const BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(10),
                  ),
                ),
                child: SafeArea(
                  bottom: false,
                  child: Row(
                    children: [
                      // Back Button
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),

                      // AI Icon
                      const CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.smart_toy,
                          color: Colors.blueAccent,
                          size: 23,
                        ),
                      ),

                      const SizedBox(width: 10),

                      // Title
                      const Expanded(
                        child: Column(
                          mainAxisAlignment:
                          MainAxisAlignment.center,
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            Text(
                              'MediBook AI',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 21,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Your Personal Health Assistant',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Clear Chat
                      IconButton(
                        onPressed: () {
                          setState(() {
                            messages.clear();
                          });
                        },
                        icon: const Icon(
                          Icons.delete_outline,
                          color: Colors.white,
                          size: 26,
                        ),
                        tooltip: 'Clear Chat',
                      ),
                    ],
                  ),
                ),
              ),

              // ==================================================
              // CHAT AREA
              // ==================================================

              Expanded(
                child: Container(
                  color: Colors.blue.shade50,
                  child: Column(
                    children: [
                      // ==========================================
                      // MESSAGES
                      // ==========================================

                      Expanded(
                        child: ListView(
                          padding: const EdgeInsets.all(15),
                          children: [
                            // ====================================
                            // WELCOME MESSAGE
                            // ====================================

                            Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                width: 330,
                                margin: const EdgeInsets.only(
                                  bottom: 15,
                                ),
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                  BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(
                                        alpha: 0.04,
                                      ),
                                      blurRadius: 4,
                                    ),
                                  ],
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
                                    const SizedBox(width: 12),
                                    const Expanded(
                                      child: Text(
                                        'Hello! How can I help you?',
                                        style: TextStyle(
                                          color: Colors.black87,
                                          fontSize: 17,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            // ====================================
                            // USER + AI MESSAGES
                            // ====================================

                            ...messages.map((message) {
                              final bool isUser =
                                  message['role'] == 'user';

                              // USER MESSAGE
                              if (isUser) {
                                return Align(
                                  alignment: Alignment.centerRight,
                                  child: Container(
                                    constraints:
                                    const BoxConstraints(
                                      maxWidth: 290,
                                    ),
                                    margin: const EdgeInsets.only(
                                      bottom: 15,
                                    ),
                                    padding:
                                    const EdgeInsets.symmetric(
                                      vertical: 10,
                                      horizontal: 15,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.blueAccent,
                                      borderRadius:
                                      BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      message['content'] ?? '',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                );
                              }

                              // AI MESSAGE
                              return Align(
                                alignment: Alignment.centerLeft,
                                child: Container(
                                  constraints:
                                  const BoxConstraints(
                                    maxWidth: 330,
                                  ),
                                  margin: const EdgeInsets.only(
                                    bottom: 15,
                                  ),
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                    BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(
                                          alpha: 0.04,
                                        ),
                                        blurRadius: 4,
                                      ),
                                    ],
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
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          message['content'] ?? '',
                                          style: const TextStyle(
                                            color: Colors.black87,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),

                            // ====================================
                            // LOADING
                            // ====================================

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

                      // ==========================================
                      // MESSAGE INPUT
                      // ==========================================

                      Container(
                        padding: const EdgeInsets.fromLTRB(
                          10,
                          8,
                          10,
                          10,
                        ),
                        color: Colors.white,
                        child: Row(
                          children: [
                            // Text Field
                            Expanded(
                              child: TextFormField(
                                controller: messageController,
                                maxLines: 2,
                                minLines: 1,
                                decoration: InputDecoration(
                                  hintText: 'Type a message...',
                                  hintStyle: const TextStyle(
                                    color: Colors.blueAccent,
                                    fontSize: 15,
                                  ),
                                  prefixIcon: const Icon(
                                    Icons.emoji_emotions_outlined,
                                    color: Colors.blueAccent,
                                    size: 25,
                                  ),
                                  suffixIcon: const Icon(
                                    Icons.attach_file,
                                    color: Colors.blueAccent,
                                    size: 25,
                                  ),
                                  filled: true,
                                  fillColor: Colors.blue.shade50,
                                  contentPadding:
                                  const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 8,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.circular(15),
                                    borderSide: const BorderSide(
                                      color: Colors.blueAccent,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.circular(15),
                                    borderSide: BorderSide(
                                      color: Colors.blueAccent
                                          .withValues(alpha: 0.5),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.circular(15),
                                    borderSide: const BorderSide(
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

                            const SizedBox(width: 8),

                            // Send Button
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
                                  size: 25,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}