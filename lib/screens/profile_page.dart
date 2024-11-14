import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_app/providers/login_provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final loginProvider = Provider.of<LoginProvider>(context, listen: false);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Text(
              'Profile',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            FutureBuilder<Map<String, dynamic>>(
              future: loginProvider.userData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  final userData = snapshot.data!;
                  return Center(
                    child: Column(children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(
                          userData['id']['userPic'].toString(),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'User Name: ${userData['id']['name'].toString()}',
                        style: const TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 5),
                      Text('User Email: ${userData['id']['email'].toString()}'),
                    ]),
                  );
                } else {
                  return const Center(
                      child: Text('No token found or token is invalid'));
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
