import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:math';
import 'package:flutter/material.dart';

List<Color> colorCollection = <Color>[];
Future<List<Meeting>> getDataFromWeb() async {
  var data = await http.get(Uri.parse("https://ece-b-api.herokuapp.com/eceb"));
  var jsonData = json.decode(data.body);

  final List<Meeting> appointmentData = [];
  final Random random = Random();
  for (var data in jsonData) {
    Meeting meetingData = Meeting(
        eventName: data['Subject'],
        from: _convertDateFromString(
          data['StartTime'],
        ),
        to: _convertDateFromString(data['EndTime']),
        background: colorCollection[random.nextInt(7)],
        reccurenceRule: data['ReccurenceRule']);
    appointmentData.add(meetingData);
  }
  return appointmentData;
}

DateTime _convertDateFromString(String date) {
  return DateTime.parse(date);
}

class Meeting {
  Meeting(
      {this.eventName,
      this.from,
      this.to,
      this.background,
      this.reccurenceRule});

  String? eventName;
  DateTime? from;
  DateTime? to;
  Color? background;
  String? reccurenceRule;
}
