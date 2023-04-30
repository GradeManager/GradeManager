import 'package:flutter/material.dart';

SingleChildScrollView ScrollContainer({required Widget child, required BuildContext context}) {
  return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: ConstrainedBox(
        constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height - kBottomNavigationBarHeight
        ),
        child: Container(
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  colors: [
                    Color.fromARGB(255, 36, 36, 62),
                    Color.fromARGB(255, 20, 30, 48),
                    Color.fromARGB(255, 15, 12, 41)
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight
              ),
            ),
            child: child
        ),
      )
  );
}