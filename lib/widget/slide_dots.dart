import 'package:flutter/material.dart';

class SlideDots extends StatelessWidget {
  bool isActive;
  int num;
  SlideDots(this.isActive, this.num);

  @override
  Widget build(BuildContext context) {
    return Container(
      //  duration: Duration(milliseconds: 300),
      // child: isActive
      //     ? Text(
      //         num.toString(),
      //         style: TextStyle(
      //           fontWeight: FontWeight.bold,
      //           color: Colors.white,
      //           fontSize: 10,
      //         ),
      //         textAlign: TextAlign.center,
      //       )
      //     : Text(""),
      margin: const EdgeInsets.symmetric(horizontal: 5),
      height: isActive ? 8 : 6,
      width: isActive ? 8 : 6,
      decoration: BoxDecoration(
        color: isActive ? Colors.blue : Colors.grey,
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    );
  }
}
