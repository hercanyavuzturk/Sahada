import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sahada2_app/Jobs/jobs_screen.dart';
import 'package:sahada2_app/LoginPage/login_screen.dart';

class UserState extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (ctx, userSnapshot){

        if(userSnapshot.data == null){

          print('kullanıcı henüz oturum açmadı');
          return Login();
        }
        else if (userSnapshot.hasData){
          print('kullanıcı  oturum açmış durumda');
          return JobScreen();

        }
        else if(userSnapshot.connectionState == ConnectionState.waiting){
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        return const Scaffold(
          body: Center(
            child: Text('Bir şeyler yanlış gitti'),
          ),
        );
      },
    );
  }
}
