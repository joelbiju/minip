import 'package:flutter/material.dart';
import 'package:timetablr/core/colors.dart';
import 'package:timetablr/core/constants.dart';
import 'package:timetablr/domain/timetable/model/timetable_model.dart';
import 'package:timetablr/domain/timetable/timetable.dart';

class SavedTimetablesScreen extends StatefulWidget {
  const SavedTimetablesScreen({super.key});

  @override
  State<SavedTimetablesScreen> createState() => _SavedTimetablesScreenState();
}

class _SavedTimetablesScreenState extends State<SavedTimetablesScreen>
    with SingleTickerProviderStateMixin {
  late final TabController tabController;
  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text('Saved Timetables'),
        bottom: TabBar(
          controller: tabController,
          tabs: [
            Tab(
              text: 'Classrooms',
            ),
            Tab(
              text: 'Faculties',
            )
          ],
        ),
      ),
      body: TabBarView(controller: tabController, children: [
        _TimetableList(
            timetableModelList:
                TimetableRepo.instance.classTimetableNotifier.value),
        _TimetableList(
            timetableModelList:
                TimetableRepo.instance.facultiesTimetableNotifier.value)
      ]),
    );
  }
}

class _TimetableList extends StatelessWidget {
  const _TimetableList({super.key, required this.timetableModelList});
  final List<TimetableModel> timetableModelList;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: List.generate(timetableModelList.length, (index) {
          final TimetableModel timetableModel = timetableModelList[index];
          return Column(
            children: [
              kheight10,
              Text(
                timetableModel.sem == null
                    ? timetableModel.faculty!
                    : timetableModel.sem!,
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
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                  crossAxisSpacing: 2.0,
                  mainAxisSpacing: 2.0,
                ),
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color.fromARGB(255, 255, 255, 255),
                        width: 0.5,
                      ),
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        timetableModel.timeTable[index] == null
                            ? ''
                            : timetableModel.timeTable[index]!.code,
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
        }),
      ),
    );
  }
}
