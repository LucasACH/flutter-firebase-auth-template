import 'package:auth_demo/authService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Home"),
      ),
      body: FutureBuilder<FirebaseUser>(
        future: AuthService().currentUser(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // Get Current User Email
            String userEmail = snapshot.data.email;

            // Get Current User UID
            String userUid = snapshot.data.uid;

            return Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Divider(height: 5,),
                ListTile(
                  // Sign Out Button
                  trailing: IconButton(
                    icon: Icon(Icons.power_settings_new),
                    onPressed: () => AuthService().signOut(),
                  ),

                  // Display User Email
                  title: Text(
                    userEmail,
                    style: TextStyle(color: Colors.white),
                  ),

                  // Display User UID
                  subtitle: Text(userUid),

                  leading: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.person),
                    ],
                  ),
                ),
              ],
            );
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
