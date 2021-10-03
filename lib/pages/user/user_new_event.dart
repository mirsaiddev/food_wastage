import 'package:flutter/material.dart';
import 'package:food_wastage/constants/colors.dart';
import 'package:food_wastage/helpers/show.dart';
import 'package:food_wastage/models/event.dart';
import 'package:food_wastage/pages/user/place_picker_page.dart';
import 'package:food_wastage/services/firestore_service.dart';
import 'package:food_wastage/services/location_permission_service.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_wastage/widgets/build_default_button.dart';
import 'package:food_wastage/widgets/build_textfield.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class UserNewEvent extends StatefulWidget {
  UserNewEvent({Key? key}) : super(key: key);

  @override
  _UserNewEventState createState() => _UserNewEventState();
}

class _UserNewEventState extends State<UserNewEvent> {
  Event _event = Event();
  TextEditingController _controller = TextEditingController();
  String _errorText = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_event.locationString == 'Click to pick location') {
            _errorText = 'Pick a location';
            setState(() {});
          } else {
            Show.dialog(
              context,
              AlertDialog(
                title: Text('Warning!'),
                content: Text('Are you sure that you want to add this event?'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () async {
                      await FirestoreService().addNewEvent(_event);
                      Navigator.pop(context);
                      Show.snackbar(context, 'The event added succesfully');
                      _event = Event();
                      _controller.clear();
                      setState(() {});
                    },
                    child: Text('Add'),
                  ),
                ],
              ),
            );
          }
        },
        child: Icon(Icons.add_rounded),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            BuildDefaultButton2(
              text: Text(_event.locationString),
              onPressed: () async {
                await LocationService().locationPermissions();
                var _result = await Navigator.push(context, MaterialPageRoute(builder: (context) => PlacePickerPage()));
                _event.location = _result.first;
                _event.locationString = _result.last;
                _errorText = '';
                setState(() {});
              },
              color: MyColors.red,
            ),
            SizedBox(height: 30.h),
            Text('Confirm the food condition'),
            SfSlider(
              min: 1,
              max: 5,
              value: _event.foodCondition,
              interval: 1,
              showTicks: true,
              showLabels: true,
              minorTicksPerInterval: 0,
              onChanged: (dynamic value) {
                setState(() {
                  _event.foodCondition = value.round();
                });
              },
            ),
            BuildTextField2(
              onChanged: (value) {
                setState(() {
                  _event.note = value;
                });
              },
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please fill this field';
                }
              },
              controller: _controller,
              hintText: 'Type your note to food recipient here',
              prefixIcon: Icon(Icons.create_outlined),
              keyboardType: TextInputType.name,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 40.w),
                child: Text(_errorText, style: TextStyle(color: Colors.red)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
