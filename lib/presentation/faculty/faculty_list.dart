import 'package:flutter/material.dart';
import 'package:timetablr/core/constants.dart';
import 'package:timetablr/domain/class/department_repo.dart';
import 'package:timetablr/domain/class/model/subject_model.dart';
import 'package:timetablr/domain/faculty/model/faculty_model.dart';
import 'package:timetablr/presentation/common/appbar.dart';
import 'package:timetablr/presentation/common/floating_button.dart';
import 'package:timetablr/presentation/faculty/facprofile.dart';
import 'package:timetablr/presentation/faculty/widgets/faculty_list_tile.dart';

class FacultyList extends StatefulWidget {
  const FacultyList({
    super.key,
  });

  @override
  State<FacultyList> createState() => _FacultyListState();
}

class _FacultyListState extends State<FacultyList> {
  int numberOfFaculties = 0;
  @override
  void initState() {
    DepartmentRepo.instance.departments.value.forEach((element) {
      numberOfFaculties += element.faculties.length;
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbar(title: 'FACULTY'),
      body: ValueListenableBuilder(
          valueListenable: DepartmentRepo.instance.departments,
          builder: (context, value, child) {
            return SafeArea(
                child: SingleChildScrollView(
              child: Column(
                children: List.generate(
                  DepartmentRepo.instance.departments.value.length,
                  (index) {
                    final faculties = DepartmentRepo
                        .instance.departments.value[index].faculties;
                    return Column(
                      children: List.generate(
                        faculties.length,
                        (i) => Column(
                          children: [
                            FacultyListTile(
                              faculty: faculties[i],
                            ),
                            SizedBox(height: 10),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ));
          }),
      floatingActionButton: FloatingButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => FacProfile(),
          ));
        },
        icon: Icons.add_rounded,
      ),
    );
  }
}
