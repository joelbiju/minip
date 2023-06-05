import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:timetablr/core/colors.dart';
import 'package:timetablr/core/constants.dart';
import 'package:timetablr/domain/class/department_repo.dart';
import 'package:timetablr/domain/class/model/dept_model.dart';
import 'package:timetablr/domain/class/model/subject_model.dart';
import 'package:timetablr/domain/faculty/faculty_repo.dart';
import 'package:timetablr/domain/faculty/model/faculty_model.dart';
import 'package:timetablr/presentation/common/loading.dart';
import 'package:timetablr/presentation/faculty/widgets/text_field_with_suggestion.dart';
import 'package:timetablr/presentation/homepage/homesc.dart';
import '../homepage/widgets/submitbtn.dart';

class FacProfile extends StatefulWidget {
  FacProfile({super.key, this.faculty});
  final Faculty? faculty;
  @override
  State<FacProfile> createState() => _FacProfileState();
}

class _FacProfileState extends State<FacProfile> {
  bool isLoading = false;
  final nameController = TextEditingController();

  final facCodeController = TextEditingController();
  final courseControllers =
      List.generate(6, (index) => TextEditingController(), growable: true);
  DepartmentModel? _selectedItem;
  final departments = DepartmentRepo.instance.departments;
  @override
  void initState() {
    if (widget.faculty != null) {
      nameController.text = widget.faculty!.name;
      facCodeController.text = widget.faculty!.code;
      departments.value.forEach((element) {
        if (element.shortName == widget.faculty!.department) {
          _selectedItem = element;
        }
      });

      for (var i = 0; i < widget.faculty!.subjects.length; i++) {
        courseControllers[i].text = widget.faculty!.subjects[i].code;
      }
    }
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFF14252C),
        body: Stack(
          children: [
            SafeArea(
                child: Container(
              child: SizedBox(
                width: double.infinity,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 25,
                      ),
                      Text(
                        'Faculty Profile',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'popins',
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Container(
                        height: 520,
                        width: 300,
                        decoration: BoxDecoration(
                          color: Color(0xFF2E3D47),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                kheight20,
                                Text(
                                  'Faculty Name',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.normal,
                                    fontFamily: 'popins',
                                    fontStyle: FontStyle.normal,
                                  ),
                                ),
                                TextField(
                                  controller: nameController,
                                  style: TextStyle(color: Colors.white),
                                  textCapitalization: TextCapitalization.words,
                                  decoration: InputDecoration(
                                    hintText: 'George Henry',
                                    hintStyle: TextStyle(
                                        color: Colors.white.withOpacity(0.5),
                                        fontStyle: FontStyle.italic,
                                        fontWeight: FontWeight.bold),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.grey),
                                    ),
                                  ),
                                ),
                                kheight20,
                                Text(
                                  'Faculty Code',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.normal,
                                    fontFamily: 'popins',
                                    fontStyle: FontStyle.normal,
                                  ),
                                ),
                                TextField(
                                  controller: facCodeController,
                                  style: TextStyle(color: Colors.white),
                                  textCapitalization: TextCapitalization.words,
                                  decoration: InputDecoration(
                                    hintText: 'ABC',
                                    hintStyle: TextStyle(
                                        color: Colors.white.withOpacity(0.5),
                                        fontStyle: FontStyle.italic,
                                        fontWeight: FontWeight.bold),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.grey),
                                    ),
                                  ),
                                ),
                                kheight10,
                                _SubHeading(
                                  heading: 'Department',
                                ),
                                Center(
                                  child: DropdownButton<String>(
                                    dropdownColor: primaryColor,
                                    hint: Text(
                                      'Select department',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    style: TextStyle(color: Colors.white),
                                    value: _selectedItem?.shortName,
                                    items: departments.value.map((val) {
                                      return DropdownMenuItem<String>(
                                        value: val.shortName,
                                        child: Text(val.shortName),
                                        onTap: () {
                                          setState(() {
                                            _selectedItem = val;
                                          });
                                        },
                                      );
                                    }).toList(),
                                    onChanged: (newValue) {},
                                  ),
                                ),
                                ...List.generate(
                                    courseControllers.length,
                                    (i) => Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            kheight20,
                                            _SubHeading(heading: 'Course $i'),
                                            TextFirldWithSuggestion(
                                              suggestions: _selectedItem == null
                                                  ? []
                                                  : _selectedItem!.subjects
                                                      .map((e) => e.code)
                                                      .toList(),
                                              controller: courseControllers[i],
                                            ),
                                          ],
                                        )),
                                kheight20
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      EvenOdd(
                          pressed: () async {
                            setState(() {
                              isLoading = true;
                            });
                            final List<SubjectModel> subjects = [];
                            for (var controller in courseControllers) {
                              for (var subject in _selectedItem!.subjects) {
                                if (subject.code == controller.text) {
                                  subjects.add(subject);
                                  break;
                                }
                              }
                            }
                            final faculty = Faculty(
                                department: _selectedItem!.shortName,
                                name: nameController.text,
                                code: facCodeController.text,
                                subjects: subjects);
                            if (widget.faculty != null) {
                              await FacultyRepo.instance.editFaculty(
                                  dept: _selectedItem!,
                                  faculty: widget.faculty!,
                                  newFaculty: faculty);
                              await DepartmentRepo.instance.getDepartments();
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                            } else {
                              await FacultyRepo.instance.addFaculty(
                                  dept: _selectedItem!, faculty: faculty);
                              await DepartmentRepo.instance.getDepartments();
                              Navigator.of(context).pop();
                            }
                          },
                          colorbox: Color(0xFF1DC192),
                          textData: Text('Save')),
                    ],
                  ),
                ),
              ),
            )),
            isLoading
                ? Container(
                    color: Colors.black.withOpacity(0.5),
                    width: double.infinity,
                    height: double.infinity,
                    child: Center(
                      child: LoadingWidget(),
                    ),
                  )
                : SizedBox.shrink()
          ],
        ));
  }
}

class _SubHeading extends StatelessWidget {
  const _SubHeading({
    super.key,
    required this.heading,
  });
  final String heading;
  @override
  Widget build(BuildContext context) {
    return Text(
      heading,
      style: TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.normal,
        fontFamily: 'popins',
        fontStyle: FontStyle.normal,
      ),
    );
  }
}
