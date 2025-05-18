import 'package:flutter/material.dart';
import 'package:medicare/screens/messages_screen.dart';


class onlinePeople extends StatefulWidget {
  const onlinePeople({super.key});

  @override
  State<onlinePeople> createState() => _onlinePeopleState();
}

class _onlinePeopleState extends State<onlinePeople> {
  TextEditingController search = TextEditingController();

  final List<Map<String, String>> onlineUsers = [
    {'image': 'images/signUp.jpg', 'name': 'Sampath', 'status': 'Available'},
    {'image': 'images/user2.png', 'name': 'Kamal', 'status': 'Busy'},
    {'image': 'images/user3.png', 'name': 'Nihal Perera', 'status': 'Active now'},
    {'image': 'images/user4.png', 'name': 'Sarah ', 'status': 'Available'},
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const Text(
              "Online People",
              style: TextStyle(
                color: Colors.deepPurple,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildSearchBox(),
            const SizedBox(height: 24),
            _buildOnlineList(context),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBox() {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: search,
        decoration: InputDecoration(
          hintText: 'Search online users...',
          prefixIcon: const Icon(Icons.search),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildOnlineList(BuildContext context) {
    return Column(
      children: onlineUsers.map((user) {
        bool isOnline = user['status'] == 'Available' || user['status'] == 'Active now';

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => chat(
                  username: user['name']!,
                  userImage: user['image']!,
                ),
              ),
            );
          },
          child: Card(
            elevation: 3,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundImage: AssetImage(user['image']!),
                      ),
                      if (isOnline)
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            width: 14,
                            height: 14,
                            decoration: BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(user['name']!,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text(user['status']!,
                          style: TextStyle(color: Colors.grey.shade600)),
                    ],
                  ),
                  const Spacer(),
                  const Icon(Icons.message, color: Colors.deepPurple),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

}

