import 'package:firebase_helpers/firebase_helpers.dart';
import 'package:firebasestarter/core/presentation/providers/providers.dart';
import 'package:firebasestarter/features/events/data/models/app_event.dart';
import 'package:firebasestarter/features/events/data/services/event_firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:firebasestarter/core/presentation/res/routes.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../../core/presentation/res/colors.dart';
import '../../../../core/presentation/res/sizes.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  CalendarController _calendarController = CalendarController();
  Map<DateTime, List<AppEvent>> _groupedEvents;
  @override
  void didChangeDependencies() {
    context.read(pnProvider).init();
    super.didChangeDependencies();
  }

  _groupEvents(List<AppEvent> events) {
    Map<DateTime, List<AppEvent>> data = {};
    events.forEach((event) {
      DateTime date =
          DateTime.utc(event.date.year, event.date.month, event.date.day, 12);
      if (data[date] == null) data[date] = [];
      data[date].add(event);
    });
    _groupedEvents = data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Firebase starter'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () => Navigator.pushNamed(context, AppRoutes.profile),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: StreamBuilder(
          stream: eventDBS.streamQueryList(args: [
            QueryArgsV2(
              "user_id",
              isEqualTo: context.read(userRepoProvider).user.id,
            ),
          ]),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              final events = snapshot.data;
              _groupEvents(events);
              DateTime initialDate = _calendarController.selectedDay ??
                  DateTime.utc(DateTime.now().year, DateTime.now().month,
                      DateTime.now().day, 12);
              final _selectedEvents = _groupedEvents[initialDate] ?? [];
              return Column(
                children: [
                  Card(
                    clipBehavior: Clip.antiAlias,
                    margin: const EdgeInsets.all(8.0),
                    child: TableCalendar(
                      onDaySelected: (date, events, _) {
                        setState(() {});
                      },
                      initialSelectedDay: initialDate,
                      events: _groupedEvents,
                      calendarController: _calendarController,
                      weekendDays: [6],
                      headerStyle: HeaderStyle(
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor,
                        ),
                        headerMargin: const EdgeInsets.only(bottom: 8.0),
                        titleTextStyle: TextStyle(
                          color: Colors.white,
                        ),
                        formatButtonDecoration: BoxDecoration(
                          border: Border.all(color: Colors.white),
                          borderRadius:
                              BorderRadius.circular(AppSizes.borderRadius),
                        ),
                        formatButtonTextStyle: TextStyle(color: Colors.white),
                        leftChevronIcon: Icon(
                          Icons.chevron_left,
                          color: Colors.white,
                        ),
                        rightChevronIcon: Icon(
                          Icons.chevron_right,
                          color: Colors.white,
                        ),
                      ),
                      calendarStyle: CalendarStyle(),
                      builders: CalendarBuilders(),
                    ),
                  ),
                  if (_selectedEvents.isEmpty)
                    ListTile(
                      title: Text("No events on the selected day"),
                    ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: _selectedEvents.length,
                    itemBuilder: (BuildContext context, int index) {
                      AppEvent event = _selectedEvents[index];
                      return ListTile(
                        title: Text(event.title),
                        subtitle: Text(DateFormat("EEEE, dd MMMM, yyyy")
                            .format(event.date)),
                        onTap: () => Navigator.pushNamed(
                            context, AppRoutes.viewEvent,
                            arguments: event),
                        trailing: IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () => Navigator.pushNamed(
                            context,
                            AppRoutes.editEvent,
                            arguments: event,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              );
            }
            return CircularProgressIndicator();
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(context, AppRoutes.addEvent,
              arguments: _calendarController.selectedDay);
        },
      ),
    );
  }
}
