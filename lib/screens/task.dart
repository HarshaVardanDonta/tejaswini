// ignore_for_file: prefer_const_constructors, unused_local_variable, deprecated_member_use, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tejaswini/constants.dart';
import 'package:tejaswini/widgets.dart';

class Task extends StatefulWidget {
  const Task({Key? key}) : super(key: key);

  @override
  State<Task> createState() => _TaskState();
}

class _TaskState extends State<Task> {
  FirebaseFirestore db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth auth = FirebaseAuth.instance;

    User? currentUser = auth.currentUser;
    bool taskDone = true;
    Map<int, String> tasks = {0: 'one', 1: 'two', 2: 'three'};
    List<dynamic> names = [];

    getData() async {
      await db
          .collection("employees")
          .doc("${currentUser?.displayName}")
          .get()
          .then((value) {
        names.add(value.data()!['task']);
      });
      print(names);
    }

    getData();
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(8),
      decoration:
          BoxDecoration(color: back, borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          CustomText(
              color: text,
              content: 'Your tasks',
              size: 20,
              weight: FontWeight.normal),
          StreamBuilder(
              stream: db.collection("employees").snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                return Expanded(
                  child: ListView.builder(
                      itemCount: names[0].length,
                      key: UniqueKey(),
                      itemBuilder: (context, index) {
                        return Dismissible(
                            key: UniqueKey(),
                            confirmDismiss: (direction) async {
                              return await showDialog(
                                  // barrierColor: back,
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      // backgroundColor: back,
                                      title: CustomText(
                                          color: container,
                                          content: 'Confirm',
                                          size: 20,
                                          weight: FontWeight.w600),
                                      // title: const Text("Confirm"),
                                      content: CustomText(
                                          color: container,
                                          content:
                                              'Are you sure this task is over',
                                          size: 20,
                                          weight: FontWeight.w600),
                                      // content: const Text(
                                      //     "Are you sure this task is over?"),
                                      actions: <Widget>[
                                        FlatButton(
                                          onPressed: () async {
                                            return await showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    title: CustomText(
                                                        color: container,
                                                        content:
                                                            "would you like to add any comment ?",
                                                        size: 20,
                                                        weight:
                                                            FontWeight.normal),
                                                    actions: <Widget>[
                                                      SizedBox(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.55,
                                                          child: TextField()),
                                                      IconButton(
                                                          onPressed: () async {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                            Navigator.of(
                                                                    context)
                                                                .pop(true);
                                                            await db
                                                                .collection(
                                                                    "employees")
                                                                .doc(
                                                                    "${currentUser?.displayName}")
                                                                .update({
                                                              "task": FieldValue
                                                                  .arrayRemove([
                                                                names[0][index]
                                                              ])
                                                            });
                                                            setState((){});
                                                          },
                                                          icon:
                                                              Icon(Icons.send)),
                                                    ],
                                                  );
                                                });
                                          },
                                          child: CustomText(
                                              color: container,
                                              content: 'Mark as done',
                                              size: 20,
                                              weight: FontWeight.w600),
                                        ),
                                        FlatButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(false),
                                          child: CustomText(
                                              color: container,
                                              content: 'Cancel',
                                              size: 20,
                                              weight: FontWeight.w600),
                                        ),
                                      ],
                                    );
                                  });
                            },
                            onDismissed: (direction) {
                              tasks.remove(index);
                              print(tasks);
                            },
                            background: Container(color: container),
                            child: ListTile(
                              title: CustomText(
                                  color: text,
                                  content: '${names[0][index]}',
                                  size: 20,
                                  weight: FontWeight.normal),
                            ));
                      }),
                );
              }
              // child: Expanded(
              //   child: ListView.builder(
              //       itemCount: tasks.length,
              //       key: UniqueKey(),
              //       itemBuilder: (context, index) {
              //         final item = tasks[index];
              //         return Dismissible(
              //             key: UniqueKey(),
              //             confirmDismiss: (direction) async {
              //               return await showDialog(
              //                   // barrierColor: back,
              //                   context: context,
              //                   builder: (BuildContext context) {
              //                     return AlertDialog(
              //                       // backgroundColor: back,
              //                       title: CustomText(
              //                           color: container,
              //                           content: 'Confirm',
              //                           size: 20,
              //                           weight: FontWeight.w600),
              //                       // title: const Text("Confirm"),
              //                       content: CustomText(
              //                           color: container,
              //                           content: 'Are you sure this task is over',
              //                           size: 20,
              //                           weight: FontWeight.w600),
              //                       // content: const Text(
              //                       //     "Are you sure this task is over?"),
              //                       actions: <Widget>[
              //                         FlatButton(
              //                           onPressed: () async {
              //                             return await showDialog(
              //                                 context: context,
              //                                 builder: (BuildContext context) {
              //                                   return AlertDialog(
              //                                     title: CustomText(
              //                                         color: container,
              //                                         content:
              //                                             "would you like to add any comment ?",
              //                                         size: 20,
              //                                         weight: FontWeight.normal),
              //                                     actions: <Widget>[
              //                                       SizedBox(
              //                                           width:
              //                                               MediaQuery.of(context)
              //                                                       .size
              //                                                       .width *
              //                                                   0.55,
              //                                           child: TextField()),
              //                                       IconButton(
              //                                           onPressed: () {
              //                                             Navigator.of(context)
              //                                                 .pop();
              //                                             Navigator.of(context)
              //                                                 .pop(true);
              //                                           },
              //                                           icon: Icon(Icons.send)),
              //                                     ],
              //                                   );
              //                                 });
              //                           },
              //                           child: CustomText(
              //                               color: container,
              //                               content: 'Mark as done',
              //                               size: 20,
              //                               weight: FontWeight.w600),
              //                         ),
              //                         FlatButton(
              //                           onPressed: () =>
              //                               Navigator.of(context).pop(false),
              //                           child: CustomText(
              //                               color: container,
              //                               content: 'Cancel',
              //                               size: 20,
              //                               weight: FontWeight.w600),
              //                         ),
              //                       ],
              //                     );
              //                   });
              //             },
              //             onDismissed: (direction) {
              //               tasks.remove(index);
              //               print(tasks);
              //             },
              //             background: Container(color: container),
              //             child: ListTile(
              //               title: CustomText(
              //                   color: text,
              //                   content: '${tasks[index]}',
              //                   size: 20,
              //                   weight: FontWeight.normal),
              //             ));
              //       }),
              // ),
              )
        ],
      ),
    );
  }
}
