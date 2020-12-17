import 'package:firebase_helpers/firebase_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import 'package:firebasestarter/core/presentation/providers/providers.dart';
import 'package:firebasestarter/core/presentation/res/routes.dart';
import 'package:firebasestarter/core/presentation/res/utils.dart';
import 'package:firebasestarter/features/events/data/models/app_event.dart';
import 'package:firebasestarter/features/events/data/services/event_firestore_service.dart';

import '../../../../core/presentation/res/colors.dart';
import '../../../../core/presentation/res/sizes.dart';

class StartEndDates {
  final DateTime start;
  final DateTime end;
  StartEndDates({
    this.start,
    this.end,
  });

  StartEndDates copyWith({
    DateTime start,
    DateTime end,
  }) {
    return StartEndDates(
      start: start ?? this.start,
      end: end ?? this.end,
    );
  }

  @override
  String toString() => 'StartEndDates(start: $start, end: $end)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is StartEndDates && o.start == start && o.end == end;
  }

  @override
  int get hashCode => start.hashCode ^ end.hashCode;
}

final eventsProvider =
    StreamProvider.family<List<AppEvent>, StartEndDates>((ref, startEndDates) {
  return eventDBS.streamQueryList(args: [
    QueryArgsV2(
      "user_id",
      isEqualTo: ref.read(userRepoProvider).user.id,
    ),
    QueryArgsV2(
      "date",
      isGreaterThanOrEqualTo: startEndDates.start
          .subtract(Duration(days: 30))
          .millisecondsSinceEpoch,
    ),
    QueryArgsV2(
      "date",
      isLessThanOrEqualTo:
          startEndDates.end.add(Duration(days: 30)).millisecondsSinceEpoch,
    ),
  ]);
});

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  CalendarController _calendarController = CalendarController();
  Map<DateTime, List<AppEvent>> _groupedEvents;
  DateTime firstDate;
  DateTime lastDate;
  DateTime today;
  @override
  void initState() {
    super.initState();
    today = DateTime.now();
    firstDate = beginingOfDay(DateTime(today.year, today.month, 1));
    lastDate = endOfDay(lastDayOfMonth(today));
  }

  @override
  void didChangeDependencies() {
    context.read(pnProvider).init();
    super.didChangeDependencies();
  }

  _groupEvents(List<AppEvent> events) {
    _groupedEvents = {};
    events.forEach((event) {
      if (event.endDate != null) {
        for (var i = DateTime.utc(
                event.date.year, event.date.month, event.date.day, 12);
            i.millisecondsSinceEpoch <=
                DateTime.utc(event.endDate.year, event.endDate.month,
                        event.endDate.day, 12)
                    .millisecondsSinceEpoch;
            i = i.add(Duration(days: 1))) {
          if (_groupedEvents[i] == null) _groupedEvents[i] = [];
          _groupedEvents[i].add(event);
        }
      } else {
        DateTime date =
            DateTime.utc(event.date.year, event.date.month, event.date.day, 12);
        if (_groupedEvents[date] == null) _groupedEvents[date] = [];
        _groupedEvents[date].add(event);
      }
    });
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
        child: Consumer(
/*           stream: eventDBS.streamQueryList(args: [
            QueryArgsV2(
              "user_id",
              isEqualTo: context.read(userRepoProvider).user.id,
            ),
            QueryArgsV2(
              "date",
              isGreaterThanOrEqualTo:
                  firstDate.subtract(Duration(days: 30)).millisecondsSinceEpoch,
            ),
            QueryArgsV2(
              "date",
              isLessThanOrEqualTo:
                  lastDate.add(Duration(days: 30)).millisecondsSinceEpoch,
            ),
          ]), */
          builder: (BuildContext context, ScopedReader watch, child) {
            final eventsProvided = watch(
                eventsProvider(StartEndDates(start: firstDate, end: lastDate)));
            return eventsProvided.when(
                data: (events) {
                  _groupEvents(events);
                  DateTime selectedDate = _calendarController.selectedDay ??
                      DateTime.utc(DateTime.now().year, DateTime.now().month,
                          DateTime.now().day, 12);
                  final _selectedEvents = _groupedEvents[selectedDate] ?? [];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Card(
                        clipBehavior: Clip.antiAlias,
                        margin: const EdgeInsets.all(8.0),
                        child: TableCalendar(
                          calendarController: _calendarController,
                          events: _groupedEvents,
                          onDaySelected: (date, events, holidays) {
                            setState(() {});
                          },
                          onCalendarCreated: (first, last, format) {
                            // setState(() {
                            firstDate = beginingOfDay(first);
                            lastDate = endOfDay(last);
                            // });
                          },
                          onVisibleDaysChanged: (first, last, format) {
                            setState(() {
                              firstDate = beginingOfDay(first);
                              lastDate = endOfDay(last);
                            });
                          },
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
                            formatButtonTextStyle:
                                TextStyle(color: Colors.white),
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
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0, top: 8.0),
                        child: Text(
                          DateFormat('EEEE, dd MMMM, yyyy')
                              .format(selectedDate),
                          style: Theme.of(context).textTheme.headline6,
                        ),
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
                },
                loading: () => Center(
                      child: CircularProgressIndicator(),
                    ),
                error: (err, stack) => Container(
                      child: Text("There is an error"),
                    ));
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
