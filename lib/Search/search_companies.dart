import 'package:flutter/material.dart';
import 'package:sahada2_app/Widgets/bottom_nav_bar.dart';

class AllWorkersSecreen extends StatefulWidget {

  @override
  State<AllWorkersSecreen> createState() => _AllWorkersState();
}

class _AllWorkersState extends State<AllWorkersSecreen> {
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
        bottomNavigationBar: BottomNavigationBarForApp(indexNum: 1,),
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text('Kendine saha bul'),
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
