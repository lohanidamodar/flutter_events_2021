import 'package:firebasestarter/features/events/data/models/app_event.dart';
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
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {},
          )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
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
