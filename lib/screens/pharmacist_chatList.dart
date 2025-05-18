import 'package:flutter/material.dart';
import 'package:medicare/screens/pharmacy_chat.dart';


class PharmacistChatListScreen extends StatelessWidget {
  final List<Map<String, String>> userChats = [
    {
      'name': 'Darshana',
      'image': 'images/user1.jpg',
    },
    {
      'name': 'Nimali',
      'image': 'images/user2.jpg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Messages'),
        backgroundColor: Color(0xFF7165D6),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: userChats.length,
        itemBuilder: (context, index) {
          final user = userChats[index];
          return ListTile(
            contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            leading: CircleAvatar(
              radius: 25,
              backgroundImage: AssetImage(user['image']!),
            ),
            title: Text(user['name']!, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: const Text("Tap to reply..."),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PharmacistChatScreen(
                    userName: user['name']!,
                    userImage: user['image']!,
                    chatId: 'chat_with_${user['name']!.toLowerCase()}',
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
