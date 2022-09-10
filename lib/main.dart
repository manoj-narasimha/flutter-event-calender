import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:connectivity/connectivity.dart';
import 'services/service.dart';

void main() {
  runApp(const MyHomePage());
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final CalendarController _controller = CalendarController();
  String _dayFormat = 'EEE', _dateFormat = 'dd';
  // CalendarDataSource? _dataSource;
  String? _networkStatusMsg;
  final Connectivity _internetConnectivity = Connectivity();

  @override
  initState() {
    // _dataSource = _getCalendarDataSource();
    initializeEventColor();
    _checkNetworkStatus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.system,
      darkTheme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SafeArea(
          child: FutureBuilder(
            future: getDataFromWeb(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.data != null) {
                return SafeArea(
                  child: SfCalendar(
                    // backgroundColor: Colors.black,
                    showDatePickerButton: true,
                    showNavigationArrow: true,
                    allowViewNavigation: true,
                    firstDayOfWeek: 6,
                    view: CalendarView.workWeek,
                    allowedViews: const [
                      CalendarView.day,
                      CalendarView.workWeek,
                      CalendarView.week
                    ],
                    initialDisplayDate: DateTime.now(),
                    initialSelectedDate: DateTime.now(),
                    dataSource: MeetingDataSource(snapshot.data),
                  ),
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator.adaptive(),
                );
              }
            },
          ),
        ),
      ),
    );
  }

  // _AppointmentDataSource _getCalendarDataSource() {
  //   List<Appointment> appointments = <Appointment>[];
  //   return _AppointmentDataSource(appointments);
  // }

  void viewChanged(ViewChangedDetails viewChangedDetails) {
    if (_controller.view == CalendarView.day) {
      SchedulerBinding.instance!.addPostFrameCallback((Duration duration) {
        if (_dayFormat != 'EEEEE' || _dateFormat != 'dd') {
          setState(() {
            _dayFormat = 'EEEEE';
            _dateFormat = 'dd';
          });
        } else {
          return;
        }
      });
    } else {
      SchedulerBinding.instance!.addPostFrameCallback((Duration duration) {
        if (_dayFormat != 'EEE' || _dateFormat != 'dd') {
          setState(() {
            _dayFormat = 'EEE';
            _dateFormat = 'dd';
          });
        } else {
          return;
        }
      });
    }
  }

  void initializeEventColor() {
    colorCollection.add(const Color(0xFF0F8644));
    colorCollection.add(const Color(0xFF8B1FA9));
    colorCollection.add(const Color(0xFFD20100));
    colorCollection.add(const Color(0xFFFC571D));
    colorCollection.add(const Color(0xFF36B37B));
    colorCollection.add(const Color(0xFF01A1EF));
    colorCollection.add(const Color(0xFF3D4FB5));
    colorCollection.add(const Color(0xFFE47C73));
    colorCollection.add(const Color(0xFF636363));
    colorCollection.add(const Color(0xFF0A8043));
  }

  void _checkNetworkStatus() {
    _internetConnectivity.onConnectivityChanged
        .listen((ConnectivityResult result) {
      setState(() {
        _networkStatusMsg = result.toString();
        if (_networkStatusMsg == "ConnectivityResult.mobile") {
          _networkStatusMsg =
              "You are connected to mobile network, loading calendar data ....";
        } else if (_networkStatusMsg == "ConnectivityResult.wifi") {
          _networkStatusMsg =
              "You are connected to wifi network, loading calendar data ....";
        } else {
          _networkStatusMsg =
              "Internet connection may not be available. Connect to another network";
        }
      });
    });
  }
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Meeting> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments![index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].to;
  }

  @override
  String getSubject(int index) {
    return appointments![index].eventName;
  }

  @override
  Color getColor(int index) {
    return appointments![index].background;
  }

  // @override
  // bool isAllDay(int index) {
  //   return appointments![index].allDay;
  // }

  @override
  String? getRecurrenceRule(int index) {
    return appointments![index].reccurenceRule;
  }
}

// class _AppointmentDataSource extends CalendarDataSource {
//   _AppointmentDataSource(List<Appointment> source) {
//     appointments = source;
//   }
// }
