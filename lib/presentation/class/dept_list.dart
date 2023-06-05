import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:timetablr/core/colors.dart';
import 'package:timetablr/core/constants.dart';
import 'package:timetablr/domain/class/department_repo.dart';
import 'package:timetablr/domain/class/model/dept_model.dart';
import 'package:timetablr/presentation/class/sem_list.dart';
import 'package:timetablr/presentation/common/appbar.dart';
import 'package:timetablr/presentation/common/floating_button.dart';
import 'package:timetablr/presentation/homepage/widgets/submitbtn.dart';

class DeptList extends StatelessWidget {
  const DeptList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbar(title: 'Departments'),
      floatingActionButton: FloatingButton(
          onPressed: () {
            _addDepartment(context);
          },
          icon: Icons.add_rounded),
      body: ValueListenableBuilder(
          valueListenable: DepartmentRepo.instance.departments,
          builder: (context, value, child) {
            return ListView.separated(
                itemBuilder: (context, index) {
                  final DepartmentModel dept = value[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: ListTile(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => SemsterList(
                            deptIndex: index,
                          ),
                        ));
                      },
                      tileColor: Colors.white12,
                      title: Text(dept.name,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 19,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'popins',
                            letterSpacing: 1.5,
                          )),
                      subtitle: Text(''),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) => kheight10,
                itemCount: DepartmentRepo.instance.departments.value.length);
          }),
    );
  }
}

_addDepartment(context) {
  final nameController = TextEditingController();
  final shortNameController = TextEditingController();
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: primaryColor,
      elevation: 1,
      title: Text('Add Department',
          style: TextStyle(
            color: Colors.white,
            fontSize: 19,
            fontWeight: FontWeight.w400,
            fontFamily: 'popins',
            letterSpacing: 1.5,
          )),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: nameController,
            style: TextStyle(
              color: Colors.white,
            ),
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(
              hintText: 'Department Name',
              hintStyle: TextStyle(
                color: const Color.fromARGB(92, 255, 255, 255),
                fontSize: 16,
                fontWeight: FontWeight.w400,
                fontFamily: 'popins',
                letterSpacing: 1.5,
              ),
              border: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
            ),
          ),
          TextFormField(
            style: TextStyle(
              color: Colors.white,
            ),
            controller: shortNameController,
            textCapitalization: TextCapitalization.characters,
            decoration: InputDecoration(
              hintText: 'Short Name',
              hintStyle: TextStyle(
                color: const Color.fromARGB(92, 255, 255, 255),
                fontSize: 16,
                fontWeight: FontWeight.w400,
                fontFamily: 'popins',
                letterSpacing: 1.5,
              ),
              border: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
            ),
          ),
          kheight10,
          EvenOdd(
            colorbox: secondaryColor,
            textData: Text('Save'),
            pressed: () async {
              nameController.text = nameController.text.trim();
              shortNameController.text = shortNameController.text.trim();
              if (nameController.text.isEmpty ||
                  shortNameController.text.isEmpty) {
                return;
              }
              if (shortNameController.text.isEmpty) {
                return;
              }
              final dep = DepartmentModel(
                name: nameController.text,
                shortName: shortNameController.text,
                semesters: [],
                subjects: [],
                faculties: [],
              );
              await DepartmentRepo.instance.addDepartment(department: dep);
              Navigator.pop(context);
            },
          )
        ],
      ),
    ),
  );
}
