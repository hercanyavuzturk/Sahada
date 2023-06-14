import 'package:flutter/material.dart';
import 'package:sahada2_app/Widgets/bottom_nav_bar.dart';

class UserProfile extends StatefulWidget {

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.greenAccent.shade200, Colors.blueAccent],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            stops: const [0.2, 0.9],
          )
      ),
      child:  Scaffold(
        bottomNavigationBar: BottomNavigationBarForApp(indexNum: 3,),
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text('Profilim'),
          centerTitle: true,
          flexibleSpace: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.greenAccent.shade200, Colors.blueAccent],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  stops: const [0.2, 0.9],
                )),
          ),
        ),
      ),
    );
  }
}
