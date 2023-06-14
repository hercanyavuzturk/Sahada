import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sahada2_app/Jobs/jobs_screen.dart';
import 'package:sahada2_app/Jobs/upload_job.dart';
import 'package:sahada2_app/Profile/user_profile.dart';
import 'package:sahada2_app/Search/search_companies.dart';
import 'package:sahada2_app/user_state.dart';

class BottomNavigationBarForApp extends StatelessWidget {
  int indexNum = 0;

  BottomNavigationBarForApp({required this.indexNum});
  @override
  void _logout(context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.black54,
            title: Row(
              children: const [
                Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.logout,
                      color: Colors.white,
                      size: 36,
                    )),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Çıkış',
                    style: TextStyle(color: Colors.white, fontSize: 28),
                  ),
                )
              ],
            ),
            content: const Text(
              'Çıkış yapmak istiyor musunuz?',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.canPop(context) ? Navigator.pop(context) :null;
                },
                child: const Text(
                  'Hayır',
                  style: TextStyle(color: Colors.red, fontSize: 18),
                ),
              ),
              TextButton(
                onPressed: () {
                  _auth.signOut();
                  Navigator.canPop(context) ? Navigator.pop(context) :null;
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => UserState()));

                },
                child: const Text(
                  'Evet',
                  style: TextStyle(color: Colors.green, fontSize: 18),
                ),
              ),
            ],
          );
        });
  }

  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      color: Colors.black26,
      backgroundColor: Colors.black26,
      buttonBackgroundColor: Colors.white70,
      height: 50,
      index: indexNum,
      items: const [
        Icon(
          Icons.home,
          size: 19,
          color: Colors.black,
        ),
        Icon(
          Icons.search,
          size: 19,
          color: Colors.black,
        ),
        Icon(
          Icons.add,
          size: 19,
          color: Colors.black,
        ),
        Icon(
          Icons.person,
          size: 19,
          color: Colors.black,
        ),
        Icon(
          Icons.exit_to_app,
          size: 19,
          color: Colors.black,
        ),
      ],
      animationDuration: const Duration(milliseconds: 300),
      animationCurve: Curves.bounceInOut,
      onTap: (index) {
        if (index == 0) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => JobScreen()));
        } else if (index == 1) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => AllWorkersSecreen()));
        } else if (index == 2) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => UploadJobNow()));
        } else if (index == 3) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => UserProfile()));
        } else if (index == 4) {
          _logout(context);
        }
      },
    );
  }
}
