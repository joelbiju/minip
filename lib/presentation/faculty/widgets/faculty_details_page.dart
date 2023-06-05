import 'package:flutter/material.dart';
import 'package:timetablr/domain/faculty/model/faculty_model.dart';
import 'package:timetablr/presentation/common/appbar.dart';
import 'package:timetablr/presentation/common/floating_button.dart';
import 'package:timetablr/presentation/faculty/facprofile.dart';

class FacultyDetailsPage extends StatelessWidget {
  const FacultyDetailsPage({super.key, required this.faculty});
  final Faculty faculty;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbar(title: faculty.name),
      floatingActionButton: FloatingButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => FacProfile(faculty: faculty),
          ));
        },
        icon: Icons.edit,
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.white24,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: ListView.separated(
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final subject = faculty.subjects[index];
                return ListTile(
                  title: Text(
                    '${subject.name}- ${subject.code}',
                    style: TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    'Hours : ${subject.hours.toString()}',
                    style: TextStyle(color: Colors.white),
                  ),
                );
              },
              separatorBuilder: (context, index) => Divider(
                    color: Colors.white54,
                  ),
              itemCount: faculty.subjects.length),
        ),
      ),
    );
  }
}
