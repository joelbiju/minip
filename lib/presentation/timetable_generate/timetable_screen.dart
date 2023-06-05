import 'package:flutter/material.dart';
import 'package:timetablr/core/colors.dart';
import 'package:timetablr/core/constants.dart';
import 'package:timetablr/domain/class/model/dept_model.dart';
import 'package:timetablr/domain/class/model/semester_model.dart';
import 'package:timetablr/domain/faculty/model/faculty_model.dart';
import 'package:timetablr/domain/timetable/timetable.dart';
import 'package:timetablr/presentation/common/loading.dart';

class TimetableScreen extends StatefulWidget {
  const TimetableScreen(
      {super.key,
      required this.classes,
      required this.faculties,
      required this.departmentModel});

  final List<SemesterModel> classes;
  final List<Faculty> faculties;
  final DepartmentModel departmentModel;
  @override
  State<TimetableScreen> createState() => _TimetableScreenState();
}

class _TimetableScreenState extends State<TimetableScreen> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: Text('Timetable'),
            backgroundColor: primaryColor,
            actions: [
              TextButton(
                  onPressed: () async {
                    setState(() {
                      isLoading = true;
                    });
                    await TimetableRepo.instance.saveTimetable(
                        classes: widget.classes,
                        faculties: widget.faculties,
                        departmet: widget.departmentModel);
                    setState(() {
                      isLoading = false;
                    });
                  },
                  child: Text(
                    'Save',
                    style: TextStyle(
                        color: const Color.fromARGB(255, 161, 255, 164),
                        fontSize: 18),
                  ))
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                ...List.generate(
                  widget.classes.length,
                  (index) {
                    final subjects = widget.classes[index].timeTable
                        .expand((list) => list)
                        .toList();
                    return Column(
                      children: [
                        kheight10,
                        Text(
                          widget.classes[index].sem,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        kheight10,
                        GridView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 7,
                            crossAxisSpacing: 2.0,
                            mainAxisSpacing: 2.0,
                          ),
                          itemBuilder: (context, index) {
                            return Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color:
                                      const Color.fromARGB(255, 255, 255, 255),
                                  width: 0.5,
                                ),
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Text(
                                  subjects[index] == null
                                      ? ''
                                      : subjects[index]!.code,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            );
                          },
                          itemCount: 35,
                        ),
                        Divider(
                          color: const Color.fromARGB(255, 255, 255, 255),
                        )
                      ],
                    );
                  },
                ),
                ...List.generate(
                  widget.faculties.length,
                  (index) {
                    final subjects = widget.faculties[index].timeTable
                        .expand((list) => list)
                        .toList();
                    return Column(
                      children: [
                        kheight10,
                        Text(
                          widget.faculties[index].name,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        kheight10,
                        GridView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 7,
                            crossAxisSpacing: 2.0,
                            mainAxisSpacing: 2.0,
                          ),
                          itemBuilder: (context, index) {
                            return Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color:
                                      const Color.fromARGB(255, 255, 255, 255),
                                  width: 0.5,
                                ),
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Text(
                                  subjects[index] == null
                                      ? ''
                                      : subjects[index]!.code,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            );
                          },
                          itemCount: 35,
                        ),
                        Divider(
                          color: const Color.fromARGB(255, 255, 255, 255),
                        )
                      ],
                    );
                  },
                )
              ],
            ),
          ),
        ),
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
    );
  }
}
