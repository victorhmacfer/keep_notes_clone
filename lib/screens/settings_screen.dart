import 'package:flutter/material.dart';
import 'package:keep_notes_clone/utils/colors.dart';
import 'package:keep_notes_clone/utils/styles.dart';

const double _leftPadding = 16;

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          'Settings',
          style: drawerItemStyle.copyWith(fontSize: 18, letterSpacing: 0),
        ),
        iconTheme: IconThemeData(color: appIconGrey),
        backgroundColor: appWhite,
      ),
      body: Container(
        color: appWhite,
        padding: EdgeInsets.only(top: 4),
        constraints: BoxConstraints.expand(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _SectionTitle('DISPLAY OPTIONS'),
            _ItemWithSwitch('Add new items to bottom'),
            _MyDivider(),
            _ItemWithSwitch('Move checked items to bottom'),
            _MyDivider(),
            _ItemWithSwitch('Display rich link previews'),
            _MyDivider(),
            AppThemePickerItem(),
            _MyDivider(),
            _SectionTitle('REMINDER DEFAULTS'),
            TimePickerItem('Morning'),
            _MyDivider(),
            TimePickerItem('Afternoon'),
            _MyDivider(),
            TimePickerItem('Evening'),
            SizedBox(
              height: 6,
            ),
            _SectionTitle('SHARING'),
            _ItemWithSwitch('Enable sharing'),
          ],
        ),
      ),
    );
  }
}

class _ItemWithSwitch extends StatelessWidget {
  final String text;

  _ItemWithSwitch(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 48,
      color: appWhite,
      padding: EdgeInsets.only(left: _leftPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            text,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
          ),
          Switch(
              activeColor: appSettingsBlue,
              value: false,
              onChanged: (value) {}),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: appWhite,
      padding: EdgeInsets.only(left: _leftPadding, top: 16),
      child: Text(
        title.toUpperCase(),
        style: drawerLabelsEditStyle.copyWith(
            color: appSettingsBlue, fontSize: 11, letterSpacing: 0.5),
      ),
    );
  }
}

class _MyDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      color: Colors.grey[350],
    );
  }
}

class TimePickerItem extends StatefulWidget {
  final String title;

  TimePickerItem(this.title);

  @override
  _TimePickerItemState createState() => _TimePickerItemState();
}

class _TimePickerItemState extends State<TimePickerItem> {
  TimeOfDay chosenTime = TimeOfDay.now();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        var selectedTime = await showTimePicker(
            context: context, initialTime: TimeOfDay.now());

        if (selectedTime != null) {
          setState(() {
            chosenTime = selectedTime;
          });
        }
      },
      child: Container(
        width: double.infinity,
        height: 48,
        color: appWhite,
        padding: EdgeInsets.symmetric(horizontal: _leftPadding),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              widget.title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
            ),
            Text(
              chosenTime.format(context),
              style: TextStyle(fontSize: 16),
            )
          ],
        ),
      ),
    );
  }
}

enum ChosenTheme { light, dark, systemDefault }

class AppThemePickerItem extends StatefulWidget {
  @override
  _AppThemePickerItemState createState() => _AppThemePickerItemState();
}

class _AppThemePickerItemState extends State<AppThemePickerItem> {
  ChosenTheme chosenTheme = ChosenTheme.systemDefault;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        var theme = await showDialog<ChosenTheme>(
            context: context,
            barrierDismissible: false,
            builder: (context) => ThemePickerDialog());

        setState(() {
          chosenTheme = theme;
        });
      },
      child: Container(
        width: double.infinity,
        height: 48,
        color: appWhite,
        padding: EdgeInsets.symmetric(horizontal: _leftPadding),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              'Theme',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
            ),
            Text(
              chosenTheme.toString(),
              style: TextStyle(fontSize: 16),
            )
          ],
        ),
      ),
    );
  }
}

class ThemePickerDialog extends StatefulWidget {
  @override
  _ThemePickerDialogState createState() => _ThemePickerDialogState();

  final ChosenTheme previousTheme;

  ThemePickerDialog({this.previousTheme});
}

class _ThemePickerDialogState extends State<ThemePickerDialog> {
  ChosenTheme chosenTheme;

  @override
  void initState() {
    super.initState();
    chosenTheme = widget.previousTheme;
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text('Choose theme'),
      children: <Widget>[
        RadioListTile<ChosenTheme>(
            title: Text('Light'),
            value: ChosenTheme.light,
            groupValue: chosenTheme,
            selected: ChosenTheme.light == chosenTheme,
            onChanged: (newValue) {
              setState(() {
                chosenTheme = newValue;
              });
            }),
        RadioListTile<ChosenTheme>(
            title: Text('Dark'),
            value: ChosenTheme.dark,
            groupValue: chosenTheme,
            selected: ChosenTheme.dark == chosenTheme,
            onChanged: (newValue) {
              setState(() {
                chosenTheme = newValue;
              });
            }),
        RadioListTile<ChosenTheme>(
            title: Text('System default'),
            value: ChosenTheme.systemDefault,
            selected: ChosenTheme.systemDefault == chosenTheme,
            groupValue: chosenTheme,
            onChanged: (newValue) {
              setState(() {
                chosenTheme = newValue;
              });
            }),
        RaisedButton(onPressed: () {
          Navigator.pop(context, chosenTheme);
        }),
      ],
    );
  }
}
