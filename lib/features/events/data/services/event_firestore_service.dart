import 'package:firebase_helpers/firebase_helpers.dart';
import 'package:firebasestarter/core/data/res/data_constants.dart';
import 'package:firebasestarter/features/events/data/models/app_event.dart';

final eventDBS = DatabaseService<AppEvent>(
  AppDBConstants.eventsCollection,
  fromDS: (id, data) => AppEvent.fromDS(id, data),
  toMap: (event) => event.toMap(),
);
