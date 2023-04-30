import 'package:flutter/material.dart';
import 'package:gauges/gauges.dart';

class gmGauge extends StatelessWidget {
  const gmGauge({
    Key? key,
    required this.grade, required this.scale, required this.config,
  }) : super(key: key);

  final double grade;
  final double scale;
  final Map<dynamic, dynamic>? config;

  static const minAngle = -105.0;
  static const maxAngle = 150.0;
  static const maxValue = 6.0;

  List<RadialGaugeSegment> getSegments(Map<String, dynamic>? config) {
    try {
      if (config==null) {
        throw Exception();
      }

      List<RadialGaugeSegment> tempList = [];

      double i = 1;
      double angle = (maxAngle - minAngle) / maxValue;

      config.forEach((key, value) {
        if (i>6) {
          return;
        }

        tempList.add(
          RadialGaugeSegment(
            minValue: 0,
            maxValue: maxValue,
            minAngle: minAngle + (angle * (i-1)),
            maxAngle: minAngle + (angle * i),
            // Add up the Alpha value with the OR operator
            color: Color(value | 0xFF000000),
          ),
        );

        i++;
      });

      return tempList;

    } catch (err) {
      return [
        const RadialGaugeSegment(
          minValue: 0,
          maxValue: maxValue,
          minAngle: minAngle,
          maxAngle: maxAngle,
          color: Colors.grey,
        ),
      ];
    }
  }

  @override
  Widget build(BuildContext context) {

    // Parses the Value for the NeedlePointer value (caps the maxvalue and the minvalue (1))
    final double displayedGrade = grade > maxValue ? maxValue : (grade < 1) ? 1 : grade;

    return Transform.scale(
      scale: scale,
      child: SizedBox(
        width: 200,
        child: DefaultTextStyle(
          style: const TextStyle(fontSize: 40, color: Colors.white),
          child: Stack(
            children: [
              RadialGauge(
                axes: [
                  RadialGaugeAxis(
                    color: Colors.transparent,
                    pointers: [
                      RadialNeedlePointer(
                          value: displayedGrade,
                          thicknessStart: 20,
                          thicknessEnd: 0,
                          length: 0.6,
                          knobRadiusAbsolute: 14,
                          color: Colors.white
                      )
                    ],
                    segments: getSegments(config?["colorschema"]),
                    minValue: 0,
                    maxValue: maxValue+1,
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 135, left: 35),
                child: Text(grade.toString(),style: const TextStyle(fontSize: 50, fontWeight: FontWeight.bold)),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class gmGaugeResponsive extends StatelessWidget {
  const gmGaugeResponsive({
    Key? key, required this.value, required this.primarySwatch, required this.secondarySwatch,
  }) : super(key: key);

  final double value;
  final Color primarySwatch;
  final Color secondarySwatch;

  @override
  Widget build(BuildContext context) {
    return RadialGauge(
      axes: [
        RadialGaugeAxis(
          minValue: -10,
          maxValue: 10,
          minAngle: -150,
          maxAngle: 150,
          radius: 0.6,
          width: 0.2,
          color: Colors.transparent,
          ticks: [
            RadialTicks(
                interval: 1,
                alignment: RadialTickAxisAlignment.inside,
                color: primarySwatch,
                length: 0.2,
                children: [
                  RadialTicks(
                      ticksInBetween: 2,
                      thickness: 0.4,
                      length: 0.1,
                      color: secondarySwatch),
                ])
          ],
          pointers: [
            RadialNeedlePointer(
              minValue: -10,
              maxValue: 10,
              value: value,
              thicknessStart: 20,
              thicknessEnd: 0,
              length: 0.5,
              knobColor: primarySwatch,
              knobRadiusAbsolute: 10,
              gradient: LinearGradient(
                colors: [
                  primarySwatch,
                  primarySwatch,
                  secondarySwatch,
                  secondarySwatch
                ],
                stops: const [0, 0.5, 0.5, 1],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class gmMainGauge extends StatelessWidget {

  const gmMainGauge({required this.value, required this.primarySwatch, required this.secondarySwatch, required this.description});

  final double value;
  final Color primarySwatch;
  final Color secondarySwatch;
  final String description;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 200,
        width: 200,
        child: Stack(
          children: [
            gmGaugeResponsive(value: value, primarySwatch: primarySwatch, secondarySwatch: secondarySwatch),
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.only(top: 80),
                child: Text("$value", textAlign: TextAlign.center),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Text(description, textAlign: TextAlign.center),
            )
          ],
        )
    );
  }
}