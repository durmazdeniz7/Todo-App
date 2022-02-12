import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:todo_app/data/local_storage.dart';
import 'package:todo_app/helper/tranlations.dart';
import 'package:todo_app/main.dart';
import 'package:todo_app/models/task_model.dart';
import 'package:todo_app/widgets/custom_search_delegate.dart';
import 'package:todo_app/widgets/task_list_item.dart';
import 'package:easy_localization/easy_localization.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<Task> _allTasks;

  late LocalStorage _localStorage;

  @override
  void initState() {
    super.initState();
    _localStorage = locator<LocalStorage>();
    _allTasks = <Task>[];
    _geAllTaskFromDb();
  }

  _geAllTaskFromDb() async {
    _allTasks = await _localStorage.getAllTask();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: GestureDetector(
          onTap: () {
            _showAddTaskBottomShet();
          },
          child: const Text(
            "title",
            style: TextStyle(color: Colors.black),
          ).tr(),
        ),
        centerTitle: false,
        actions: [
          IconButton(
              onPressed: () {
                _showSearchPage();
              },
              icon: const Icon(Icons.search)),
          IconButton(
              onPressed: () {
                _showAddTaskBottomShet();
              },
              icon: const Icon(Icons.add)),
        ],
      ),
      body: _allTasks.isNotEmpty
          ? ListView.builder(
              itemCount: _allTasks.length,
              itemBuilder: (context, index) {
                var _oAnkiListeElemani = _allTasks[index];
                return Dismissible(
                  background: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:  [
                     const Icon(Icons.delete),
              const        SizedBox(
                        width: 8,
                      ),
                 const     Text("remove_task").tr()
                    ],
                  ),
                  key: Key(_oAnkiListeElemani.id),
                  onDismissed: (direction) {
                    _allTasks.removeAt(index);
                    _localStorage.deleteTask(task: _oAnkiListeElemani);
                    setState(() {});
                  },
                  child: TaskItem(task: _oAnkiListeElemani),
                );
              },
            )
          :  Center(
              child:const Text("empty_task_list").tr(),
            ),
    );
  }

  void _showAddTaskBottomShet() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            width: MediaQuery.of(context).size.width,
            child: ListTile(
              title: TextField(
                autofocus: true,
                style: const TextStyle(fontSize: 20),
                decoration:  InputDecoration(
                    hintText: "add_task".tr(), border: InputBorder.none),
                onSubmitted: (value) {
                  Navigator.of(context).pop();
                  if (value.length > 3) {
                    DatePicker.showTimePicker(context, showSecondsColumn: false,
                    locale: TranslationsHelper.getDeviceLanguage(context),
                        onConfirm: (time) {
                      var yeniEklenecekGorev =
                          Task.create(name: value, createdAt: time);
                      _allTasks.insert(0, yeniEklenecekGorev);

                      _localStorage.addTask(task: yeniEklenecekGorev);
                      setState(() {});
                    });
                  }
                },
              ),
            ),
          );
        });
  }

  void _showSearchPage() async {
    await showSearch(
        context: context, delegate: CustomSearchDelegate(allTasks: _allTasks));
        _geAllTaskFromDb();
  }
}
