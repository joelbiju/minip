import 'package:flutter/material.dart';
import 'package:timetablr/core/colors.dart';
import 'package:timetablr/core/constants.dart';
import 'package:timetablr/domain/faculty/faculty_repo.dart';
import 'package:timetablr/domain/faculty/model/faculty_model.dart';
import 'package:timetablr/presentation/faculty/widgets/faculty_details_page.dart';
import 'package:timetablr/presentation/homepage/homesc.dart';

class FacultyListTile extends StatelessWidget {
  const FacultyListTile({super.key, required this.faculty});
  final Faculty faculty;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ListTile(
        onLongPress: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                backgroundColor: primaryColor,
                title: Text("Delete Faculty",
                    style: TextStyle(color: Colors.white)),
                content: Row(
                  children: [
                    ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(secondaryColor)),
                        onPressed: () async {
                          FacultyRepo.instance.deleteFaculty(
                              dept: faculty.department, faculty: faculty);
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (context) => HomeScreen(),
                              ),
                              (route) => false);
                        },
                        child: Text('Yes')),
                    kwidth20,
                    ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(secondaryColor)),
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text('No')),
                  ],
                ),
              );
            },
          );
        },
        onTap: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => FacultyDetailsPage(faculty: faculty),
        )),
        tileColor: Colors.white12,
        title: Text(faculty.name,
            style: TextStyle(
              color: Colors.white,
              fontSize: 19,
              fontWeight: FontWeight.w400,
              fontFamily: 'popins',
              letterSpacing: 1.5,
            )),
        subtitle: Text(
          faculty.subjects.join(', '),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Colors.white,
            height: 2,
            fontSize: 15,
            fontWeight: FontWeight.normal,
            fontFamily: 'popins',
            wordSpacing: 1.5,
            letterSpacing: 1.5,
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
