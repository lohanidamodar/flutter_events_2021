import 'package:firebasestarter/core/presentation/res/routes.dart';
import 'package:firebasestarter/features/events/data/models/app_event.dart';
import 'package:firebasestarter/features/events/data/services/event_firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventDetails extends StatelessWidget {
  final AppEvent event;

  const EventDetails({Key key, this.event}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.clear),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.pushReplacementNamed(
                context,
                AppRoutes.editEvent,
                arguments: event,
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () async {
              final confirm = await showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text("Warinig!"),
                      content: Text("Are you sure you want to delete?"),
                      actions: [
                        TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: Text("Delete")),
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: Text(
                            "Cancel",
                            style: TextStyle(color: Colors.grey.shade700),
                          ),
                        ),
                      ],
                    ),
                  ) ??
                  false;

              if (confirm) {
                await eventDBS.removeItem(event.id);
                Navigator.pop(context);
              }
            },
          )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          Text(event.public ? "Public" : "Private"),
          ListTile(
            leading: Icon(Icons.event),
            title: Text(
              event.title,
              style: Theme.of(context).textTheme.headline5,
            ),
            subtitle:
                Text(DateFormat("EEEE, dd MMMM, yyyy").format(event.date)),
          ),
          const SizedBox(height: 10.0),
          ListTile(
            leading: Icon(Icons.short_text),
            title: Text(event.description),
          ),
          const SizedBox(height: 20.0),
        ],
      ),
    );
  }
}
