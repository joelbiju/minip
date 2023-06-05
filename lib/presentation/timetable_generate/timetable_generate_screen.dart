import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';
import 'package:timetablr/core/colors.dart';
import 'package:timetablr/core/constants.dart';
import 'package:timetablr/domain/algorithm.dart';
import 'package:timetablr/domain/class/department_repo.dart';
import 'package:timetablr/domain/class/model/dept_model.dart';
import 'package:timetablr/domain/class/model/semester_model.dart';
import 'package:timetablr/presentation/timetable_generate/timetable_screen.dart';

import '../../domain/faculty/model/faculty_model.dart';

class TimeTableGenerateScreen extends StatefulWidget {
  const TimeTableGenerateScreen({super.key});

  @override
  State<TimeTableGenerateScreen> createState() =>
      _TimeTableGenerateScreenState();
}

class _TimeTableGenerateScreenState extends State<TimeTableGenerateScreen> {
  List<Faculty> faculties = [];
  List selectedfaculties = [];
  List selectedSemesters = [];

  DepartmentModel? _selectedDepartment;

  @override
  void initState() {
    DepartmentRepo.instance.departments.value.forEach((dept) {
      dept.faculties.forEach((faculty) {
        faculties.add(faculty);
      });
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              kheight20,
              Text(
                'Select Faculties and Classes',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              kheight20,
              Divider(
                color: Colors.white,
              ),
              kheight20,
              MultiSelectFormField(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.white)),
                fillColor: secondaryColor.withOpacity(0.1),
                autovalidate: AutovalidateMode.disabled,
                chipBackGroundColor: Colors.green,
                chipLabelStyle: TextStyle(fontWeight: FontWeight.bold),
                dialogTextStyle: TextStyle(fontWeight: FontWeight.bold),
                checkBoxActiveColor: Colors.green,
                checkBoxCheckColor: Colors.white,
                dialogShapeBorder: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.all(Radius.circular(12.0))),
                title: Text(
                  "Faculties",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
                dataSource: List.generate(
                  faculties.length,
                  (index) => {
                    "display": faculties[index].name,
                    "value": faculties[index],
                  },
                ),
                textField: 'display',
                valueField: 'value',
                okButtonLabel: 'OK',
                cancelButtonLabel: 'CANCEL',
                hintWidget: Text('Select Faculties',
                    style: TextStyle(
                        color: const Color.fromARGB(122, 255, 255, 255))),
                initialValue: selectedfaculties,
                onSaved: (value) {
                  if (value == null) return;
                  setState(() {
                    selectedfaculties = value;
                  });
                },
              ),
              kheight20,
              SizedBox(
                width: double.infinity,
                child: DropdownButton<String>(
                  underline: SizedBox.shrink(),
                  dropdownColor: primaryColor,
                  hint: Text(
                    'Select department',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: TextStyle(color: Colors.white),
                  value: _selectedDepartment?.shortName,
                  items: DepartmentRepo.instance.departments.value.map((val) {
                    return DropdownMenuItem<String>(
                      value: val.shortName,
                      child: Text(val.shortName),
                      onTap: () {
                        setState(() {
                          _selectedDepartment = val;
                        });
                      },
                    );
                  }).toList(),
                  onChanged: (newValue) {},
                ),
              ),
              kheight20,
              MultiSelectFormField(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.white)),
                fillColor: secondaryColor.withOpacity(0.1),
                autovalidate: AutovalidateMode.disabled,
                chipBackGroundColor: Colors.green,
                chipLabelStyle: TextStyle(fontWeight: FontWeight.bold),
                dialogTextStyle: TextStyle(fontWeight: FontWeight.bold),
                checkBoxActiveColor: Colors.green,
                checkBoxCheckColor: Colors.white,
                dialogShapeBorder: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.all(Radius.circular(12.0))),
                title: Text(
                  "Semesters",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
                dataSource: List.generate(
                    _selectedDepartment == null
                        ? 0
                        : _selectedDepartment!.semesters.length,
                    (index) => {
                          "display": _selectedDepartment!.semesters[index].sem,
                          "value": _selectedDepartment!.semesters[index],
                        }),
                textField: 'display',
                valueField: 'value',
                okButtonLabel: 'OK',
                hintWidget: Text('Select Semesters',
                    style: TextStyle(
                        color: const Color.fromARGB(122, 255, 255, 255))),
                cancelButtonLabel: 'CANCEL',
                initialValue: selectedSemesters,
                onSaved: (value) {
                  if (value == null) return;
                  setState(() {
                    selectedSemesters = value;
                  });
                },
              ),
              kheight20,
              ElevatedButton(
                onPressed: () async {
                  bool isvalid = true;
                  final service = Service(
                    faculties: selectedfaculties.map((e) {
                      return e as Faculty;
                    }).toList(),
                    Semesters: selectedSemesters.map((e) {
                      return e as SemesterModel;
                    }).toList(),
                  );
                  await service.main(context);
                  await Future.forEach(selectedSemesters, (sem) {
                    final semester = sem as SemesterModel;
                    if (semester.timeTable[0]
                        .every((element) => element == null)) {
                      isvalid = false;
                    }
                  });
                  if (!isvalid) {
                    return;
                  }
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TimetableScreen(
                          departmentModel: _selectedDepartment!,
                          classes: selectedSemesters.map((e) {
                            return e as SemesterModel;
                          }).toList(),
                          faculties: selectedfaculties.map((e) {
                            return e as Faculty;
                          }).toList(),
                        ),
                      ));
                },
                child: Text('Generate'),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Color(0xFF1DC192)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
