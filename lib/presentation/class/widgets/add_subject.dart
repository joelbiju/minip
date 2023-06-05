import 'package:flutter/material.dart';
import 'package:timetablr/core/constants.dart';
import 'package:timetablr/domain/class/department_repo.dart';
import 'package:timetablr/domain/class/model/semester_model.dart';
import 'package:timetablr/domain/class/model/subject_model.dart';
import 'package:timetablr/domain/class/subject_repo.dart';
import 'package:timetablr/presentation/class/widgets/heading_with_textfield.dart';
import 'package:timetablr/presentation/homepage/homesc.dart';
import '../../homepage/widgets/submitbtn.dart';

class AddSubjects extends StatelessWidget {
  AddSubjects({Key? key, required this.departmentName, required this.semester})
      : super(key: key);
  final String departmentName;
  final String semester;
  final List<TextEditingController> courseControllers =
      List.generate(9, (index) => TextEditingController(), growable: false);
  final List<TextEditingController> codeControllers =
      List.generate(9, (index) => TextEditingController(), growable: false);
  final List<TextEditingController> hourControllers =
      List.generate(9, (index) => TextEditingController(), growable: false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF14252C),
      body: SafeArea(
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
                  'Add Subjects',
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
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          kheight10,
                          ...List.generate(
                              7,
                              (index) => TextFieldWithHeading(
                                    heading: 'Subject ${index + 1}',
                                    hintText: 'Course',
                                    controller: courseControllers[index],
                                    courseCodeHint: 'Code',
                                    codeController: codeControllers[index],
                                    hourController: hourControllers[index],
                                    hourHint: 'hrs/week',
                                  )),
                          ...List.generate(
                              2,
                              (index) => TextFieldWithHeading(
                                    heading: 'Lab ${index + 1}',
                                    hintText: 'Lab',
                                    controller: courseControllers[index + 7],
                                    courseCodeHint: 'Code',
                                    codeController: codeControllers[index + 7],
                                    hourController: hourControllers[index + 7],
                                    hourHint: 'hrs/week',
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
                      int length = 0;
                      final List<TextEditingController> _courseControllers = [],
                          _codeControllers = [],
                          _hourControllers = [];
                      for (int i = 0; i < courseControllers.length; i++) {
                        if (courseControllers[i].text.isNotEmpty) {
                          length++;
                          _courseControllers.add(courseControllers[i]);
                          _codeControllers.add(codeControllers[i]);
                          _hourControllers.add(hourControllers[i]);
                        }
                      }
                      final subjects = List.generate(
                          length,
                          (index) => SubjectModel(
                              name: _courseControllers[index].text,
                              code: _codeControllers[index].text,
                              hours: int.parse(_hourControllers[index].text)));
                      await SubjectRepo.instance.addSubjects(
                          dept: departmentName,
                          sem: semester,
                          subjects: subjects);
                      await DepartmentRepo.instance.getDepartments();
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    },
                    colorbox: Color(0xFF1DC192),
                    textData: Text('Next')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
