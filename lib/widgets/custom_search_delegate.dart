import 'package:flutter/material.dart';
import 'package:todo_app/data/local_storage.dart';
import 'package:todo_app/main.dart';
import 'package:todo_app/models/task_model.dart';
import 'package:todo_app/widgets/task_list_item.dart';
import 'package:easy_localization/easy_localization.dart';


class CustomSearchDelegate extends SearchDelegate {
  final List<Task> allTasks;

  CustomSearchDelegate({required this.allTasks});

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query.isEmpty ? null : query = '';
          },
          icon: const Icon(Icons.clear))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return GestureDetector(
        onTap: () {
          close(context, null);
        },
        child: const Icon(
          Icons.arrow_back_ios,
          color: Colors.black,
          size: 24,
        ));
  }

  @override
  Widget buildResults(BuildContext context) {
    var filteredList = allTasks
        .where((element) =>
            element.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
    return filteredList.isNotEmpty? ListView.builder(
              itemCount: filteredList.length,
              itemBuilder: (context, index) {
                var _oAnkiListeElemani = filteredList[index];
                return Dismissible(
                  background: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:  [
                    const  Icon(Icons.delete ),
                   const   SizedBox(width: 8,),
                    const  Text("remove_task").tr()
                    ],
                  ),
                  key: Key(_oAnkiListeElemani.id),
                  onDismissed: (direction) async{
                    filteredList.removeAt(index);
                   await locator<LocalStorage>().deleteTask(task: _oAnkiListeElemani);
                  },
                  child:TaskItem (task:_oAnkiListeElemani),
                );
              },
            ): Center(child:const Text("search_not_found").tr(),);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
}
