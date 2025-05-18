import 'package:flutter/material.dart';
import 'package:medicare/widgets/chat_sample.dart';

class PharmacistChatScreen extends StatefulWidget {
  final String userName;
  final String userImage;
  final String chatId;

  const PharmacistChatScreen({
    super.key,
    required this.userName,
    required this.userImage,
    required this.chatId,
  });

  @override
  State<PharmacistChatScreen> createState() => _PharmacistChatScreenState();
}

class _PharmacistChatScreenState extends State<PharmacistChatScreen> {
  final TextEditingController _messageController = TextEditingController();

  // This list should come from your backend or Firebase
  List<Map<String, dynamic>> messages = [
    {'from': 'user', 'text': 'Hello, I need Paracetamol.'},
    {'from': 'pharmacist', 'text': 'Sure! How many tablets?'},
  ];

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        messages.add({'from': 'pharmacist', 'text': text});
        _messageController.clear();
      });

      // TODO: Send message to backend with widget.chatId
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF7165D6),
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage(widget.userImage),
            ),
            const SizedBox(width: 10),
            Text(widget.userName),
          ],
        ),
        actions: const [
          Icon(Icons.call),
          SizedBox(width: 15),
          Icon(Icons.video_call),
          SizedBox(width: 15),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final isPharmacist = messages[index]['from'] == 'pharmacist';
                return Align(
                  alignment:
                  isPharmacist ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isPharmacist ? Colors.deepPurple[100] : Colors.grey[300],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(messages[index]['text']),
                  ),
                );
              },
            ),
          ),
          _buildBottomInput(),
        ],
      ),
    );
  }

  Widget _buildBottomInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      height: 65,
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(color: Colors.black12, spreadRadius: 2, blurRadius: 10),
      ]),
      child: Row(
        children: [
          Icon(Icons.add, size: 28),
          const SizedBox(width: 5),
          Icon(Icons.emoji_emotions_outlined, color: Colors.purple, size: 28),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: const InputDecoration(
                hintText: "Type your message...",
                border: InputBorder.none,
              ),
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          GestureDetector(
            onTap: _sendMessage,
            child: Icon(Icons.send, size: 28, color: Color(0xFF7165D6)),
          ),
        ],
      ),
    );
  }
}
