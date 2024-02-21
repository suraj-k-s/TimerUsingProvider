import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:timer/main.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({super.key});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15), topRight: Radius.circular(15)),
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(255, 90, 90, 90).withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Lottie.asset(
            'assets/TeethBrushing.json',
            width: 70,
            height: 70,
            repeat: true,
            animate: true,
          ),
          Text(
            '1:00',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
          ),
          Row(
            children: [
              IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.stop_rounded,
                    size: 40,
                  )),
              IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.pause_rounded,
                    size: 40,
                  )),
            ],
          )
        ],
      ),
    );
  }
}
