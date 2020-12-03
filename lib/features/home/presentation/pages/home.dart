import 'package:firebase_helpers/firebase_helpers.dart';
import 'package:firebasestarter/core/presentation/providers/providers.dart';
import 'package:firebasestarter/core/presentation/res/colors.dart';
import 'package:firebasestarter/features/events/data/models/app_event.dart';
import 'package:firebasestarter/features/events/data/services/event_firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:firebasestarter/core/presentation/res/routes.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  CalendarController _calendarController;
  @override
  void initState() {
    super.initState();
    _calendarController = CalendarController();
  }

  @override
  void didChangeDependencies() {
    context.read(pnProvider).init();
    super.didChangeDependencies();
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Card(
              clipBehavior: Clip.antiAlias,
              margin: const EdgeInsets.all(8.0),
              child: TableCalendar(
                calendarController: _calendarController,
                weekendDays: [6],
                headerStyle: HeaderStyle(
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                  ),
                  headerMargin: const EdgeInsets.only(bottom: 8),
                  titleTextStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                  ),
                  formatButtonTextStyle: TextStyle(
                    color: Colors.white,
                  ),
                  formatButtonDecoration: BoxDecoration(
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  leftChevronIcon: Icon(
                    Icons.chevron_left,
                    color: Colors.white,
                  ),
                  rightChevronIcon: Icon(
                    Icons.chevron_right,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            StreamBuilder(
              stream: eventDBS.streamQueryList(
                args: [
                  QueryArgsV2('user_id',
                      isEqualTo: context.read(userRepoProvider).user.id),
                ],
              ),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Container(
                    child: Text("Error"),
                  );
                }
                if (snapshot.hasData) {
                  List<AppEvent> events = snapshot.data;
                  return ListView.builder(
                    itemCount: events.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      final event = events[index];
                      return ListTile(
                        title: Text(event.title),
                        subtitle: Text(DateFormat("EEEE, dd MMMM, yyyy")
                            .format(event.date)),
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            AppRoutes.viewEvent,
                            arguments: event,
                          );
                        },
                      );
                    },
                  );
                }
                return CircularProgressIndicator();
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => Navigator.pushNamed(
          context,
          AppRoutes.addEvent,
          arguments: _calendarController.selectedDay,
        ),
      ),
    );
  }
}
