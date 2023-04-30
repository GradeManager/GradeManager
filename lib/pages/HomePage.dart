import 'package:GradeManager/components/Math.dart';
import 'package:flutter/material.dart';
import 'package:GradeManager/components/gmScrollContainer.dart';
import 'package:GradeManager/components/gmGauge.dart';

import '../Globals.dart';

class home extends StatefulWidget {
  @override
  State<home> createState() {
    return _homeState();
  }
}

class _homeState extends State<home> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
        style: const TextStyle(fontSize: 20, color: Colors.white),
        child: ScrollContainer(
          context: context,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.2),
                child: ImageIcon(
                  const AssetImage('assets/icons/GM_white.png'),
                  color: Colors.white,
                  size: MediaQuery.of(context).size.shortestSide / 3,
                ),
              ),
              FutureBuilder(
                future: fetchConfig(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return  Wrap(
                      direction: Axis.horizontal,
                      children: [
                        gmMainGauge(
                            value: double.parse(getSumGrade(Config).toStringAsFixed(1)),
                            primarySwatch: Colors.blue,
                            secondarySwatch: Colors.grey,
                            description: "Average Grade"
                        ),
                        gmMainGauge(
                            value: double.parse(getSumPluspoints(Config).toStringAsFixed(1)),
                            primarySwatch: Colors.orange,
                            secondarySwatch: Colors.grey,
                            description: "Pluspoints"
                        ),
                      ],
                    );
                  }
                  else if (snapshot.hasError) {
                    return const Text("Failed to load config", style: TextStyle(fontSize: 30));
                  }
                  else {
                    return const CircularProgressIndicator(color: Colors.white);
                  }
                }
              )
            ],
          )
        )
    );
  }
}

