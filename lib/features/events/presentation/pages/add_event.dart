import 'package:firebasestarter/core/presentation/providers/providers.dart';
import 'package:firebasestarter/core/presentation/res/colors.dart';
import 'package:firebasestarter/features/events/data/models/app_event.dart';
import 'package:firebasestarter/features/events/data/services/event_firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddEventPage extends StatefulWidget {
  final DateTime selectedDate;
  final AppEvent event;

  const AddEventPage({Key key, this.selectedDate, this.event})
      : super(key: key);
  @override
  _AddEventPageState createState() => _AddEventPageState();
}

class _AddEventPageState extends State<AddEventPage> {
  final _formKey = GlobalKey<FormBuilderState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(
            Icons.clear,
            color: AppColors.primaryColor,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () async {
                //save
                _formKey.currentState.save();
                final data =
                    Map<String, dynamic>.from(_formKey.currentState.value);
                data["date"] =
                    (data["date"] as DateTime).millisecondsSinceEpoch;
                await eventDBS.create({
                  ...data,
                  "user_id": context.read(userRepoProvider).user.id,
                });
                Navigator.pop(context);
              },
              child: Text("Save"),
            ),
          )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          //add event form
          FormBuilder(
            key: _formKey,
            child: Column(
              children: [
                FormBuilderTextField(
                  name: "title",
                  initialValue: widget.event?.title,
                  decoration: InputDecoration(
                      hintText: "Add Title",
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.only(left: 48.0)),
                ),
                Divider(),
                FormBuilderTextField(
                  name: "description",
                  initialValue: widget.event?.description,
                  minLines: 1,
                  maxLines: 5,
                  decoration: InputDecoration(
                      hintText: "Add Details",
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.short_text)),
                ),
                Divider(),
                FormBuilderSwitch(
                  name: "public",
                  initialValue: widget.event?.public ?? false,
                  title: Text("Public"),
                  controlAffinity: ListTileControlAffinity.leading,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                  ),
                ),
                Divider(),
                FormBuilderDateTimePicker(
                  name: "date",
                  initialValue: widget.selectedDate ??
                      widget.event?.date ??
                      DateTime.now(),
                  initialDate: DateTime.now(),
                  fieldHintText: "Add Date",
                  initialDatePickerMode: DatePickerMode.day,
                  inputType: InputType.date,
                  format: DateFormat('EEEE, dd MMMM, yyyy'),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.calendar_today_sharp),
                  ),
                ),
                Divider(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
