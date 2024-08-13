import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:googlekeepnotesclone/Services/Mynotemodel.dart';
import 'package:googlekeepnotesclone/Services/db.dart';

import 'package:googlekeepnotesclone/UI/Components/SideMenu.dart';
import 'package:googlekeepnotesclone/UI/Screen/CreateNoteScreen.dart';
import 'package:googlekeepnotesclone/UI/Screen/NotesScreen.dart';
import 'package:googlekeepnotesclone/Utilities/colors.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController searchcontroller = TextEditingController();
  List<Note> notesList = [];
  bool isLoading = true;
  GlobalKey<ScaffoldState> globalKey = GlobalKey();

  List<Note> localFetchedNote = [];
  List<int> localid = [];

  Future createEntry(Note note) async {
    await NotesDatabase.instance.createEntry(note);
  }

  Future getAllNotes() async {
    notesList = await NotesDatabase.instance.readNotes();
    setState(() {
      isLoading = false;
    });
  }

  Future updateNotes(Note note) async {
    await NotesDatabase.instance.updateNote(note);
  }

  Future getoneNote(int id) async {
    await NotesDatabase.instance.readoneNote(id);
  }

  Future deleteDb() async {
    NotesDatabase.instance.deletedb("Notes.db");
  }

  // Future searchresults(String query) async {
  //   searchresultnotes.clear();
  //   setState(() {
  //     isLoading = true;
  //   });
  //   final searchId = await NotesDatabase.instance.getNoteString(query);
  //   List<Note> searchresultnotesLocal = [];
  //   searchId.forEach((index) async {
  //     final Note searchnote = await NotesDatabase.instance.readoneNote(index);
  //     searchresultnotesLocal.add(searchnote);
  //     setState(() {
  //       searchresultnotes.add(searchnote);
  //     });
  //     setState(() {
  //       isLoading = false;
  //     });
  //   });
  // }

  Future<List<Note>> SearchResult(String query) async {
    localFetchedNote.clear();
    final List<int> searchids =
        await NotesDatabase.instance.getAllNotesId(query);
    for (var i in searchids) {
      localFetchedNote.add(await NotesDatabase.instance.readoneNote(i));
    }
    print(localFetchedNote.map((e) => e.toJson()).toList());
    return localFetchedNote;
  }

  Future deleteallrecord() async {
    notesList.forEach((element) {
      NotesDatabase.instance.deleteNote(element);
    });
  }

  @override
  void initState() {
    // createEntry(Note(
    //     pin: false,
    //     title: "Hello",
    //     content: "First Note",
    //     createdtime: DateTime.now()));
    // deleteDb();
    getAllNotes();
    // SearchResult('hello');
    // updateNotes();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    // searchcontroller.dispose();
  }

  bool isList = true;
  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    var height = mq.height;
    var width = mq.width;
    return isLoading
        ? Scaffold(
            backgroundColor: bgColor,
            body: Center(
              child: CircularProgressIndicator(
                color: white,
              ),
            ),
          )
        : Scaffold(
            floatingActionButton: FloatingActionButton(
              backgroundColor: cardColor,
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (contex) => CreateNoteScreen()));
              },
              child: Icon(
                Icons.add,
                color: white,
                size: 25,
              ),
            ),
            drawerEnableOpenDragGesture: true,
            key: globalKey,
            drawer: SideMenu(),
            backgroundColor: bgColor,
            body: SafeArea(
                child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10),
                    child: Container(
                      height: 55,
                      width: width,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: cardColor,
                          boxShadow: [
                            BoxShadow(
                                color: black.withOpacity(0.2),
                                spreadRadius: 1,
                                blurRadius: 3)
                          ]),
                      child: Row(
                        children: [
                          IconButton(
                              onPressed: () {
                                globalKey.currentState!.openDrawer();
                              },
                              icon: Icon(
                                Icons.menu,
                                color: white,
                              )),
                          SizedBox(
                            width: width * 0.01,
                          ),
                          Expanded(
                            child: Form(
                              child: TextFormField(
                                controller: searchcontroller,
                                decoration: InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: width * 0.02),
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide.none),
                                    hintText: "Search Your Notes",
                                    hintStyle:
                                        TextStyle(color: white, fontSize: 15)),
                                style: TextStyle(color: white, fontSize: 16),
                                onChanged: (value) {
                                  setState(() {
                                    SearchResult(value.toLowerCase());
                                  });
                                },
                              ),
                            ),
                          ),
                          IconButton(
                              onPressed: () {
                                isList = !isList;
                                setState(() {});
                              },
                              icon: isList
                                  ? Icon(
                                      Icons.list,
                                      color: white,
                                    )
                                  : Icon(
                                      Icons.grid_view,
                                      color: white,
                                    )),
                          SizedBox(
                            width: width * 0.01,
                          ),
                          IconButton(
                              onPressed: () {
                                deleteallrecord();
                                setState(() {
                                  getAllNotes();
                                });
                              },
                              icon: Icon(
                                Icons.delete_sweep_outlined,
                                color: white,
                              )),
                          SizedBox(
                            width: width * 0.04,
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height * 0.002,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          notesList.isEmpty
                              ? Center(
                                  child: Text(
                                    "You don't Have Any Note Right Now",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        color: white.withOpacity(0.5)),
                                  ),
                                )
                              : Text(
                                  "All",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                      color: white.withOpacity(0.5)),
                                ),
                          SizedBox(
                            height: height * 0.01,
                          ),
                          isList
                              ? searchcontroller.text.isNotEmpty
                                  ? MasonryGridView.builder(
                                      physics: BouncingScrollPhysics(),
                                      mainAxisSpacing: 2,
                                      crossAxisSpacing: 4,
                                      shrinkWrap: true,
                                      gridDelegate:
                                          SliverSimpleGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 1),
                                      itemCount: localFetchedNote.length,
                                      itemBuilder: (context, index) {
                                        return InkWell(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        NoteScreen(
                                                            note:
                                                                localFetchedNote[
                                                                    index])));
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color:
                                                        white.withOpacity(0.4)),
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 10),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                      localFetchedNote[index]
                                                          .title,
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                  SizedBox(
                                                    height: height * 0.01,
                                                  ),
                                                  Text(
                                                    localFetchedNote[index]
                                                        .content,
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      })
                                  : MasonryGridView.builder(
                                      physics: BouncingScrollPhysics(),
                                      mainAxisSpacing: 2,
                                      crossAxisSpacing: 4,
                                      shrinkWrap: true,
                                      gridDelegate:
                                          SliverSimpleGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 1),
                                      itemCount: notesList.length,
                                      itemBuilder: (context, index) {
                                        return InkWell(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        NoteScreen(
                                                            note: notesList[
                                                                index])));
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color:
                                                        white.withOpacity(0.4)),
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 10),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(notesList[index].title,
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                  SizedBox(
                                                    height: height * 0.01,
                                                  ),
                                                  Text(
                                                    notesList[index].content,
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      })
                              : searchcontroller.text.isNotEmpty
                                  ? MasonryGridView.builder(
                                      physics: BouncingScrollPhysics(),
                                      mainAxisSpacing: 2,
                                      crossAxisSpacing: 4,
                                      shrinkWrap: true,
                                      gridDelegate:
                                          SliverSimpleGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 2),
                                      itemCount: localFetchedNote.length,
                                      itemBuilder: (context, index) {
                                        return InkWell(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        NoteScreen(
                                                            note:
                                                                localFetchedNote[
                                                                    index])));
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color:
                                                        white.withOpacity(0.4)),
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 10),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                      localFetchedNote[index]
                                                          .title,
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                  SizedBox(
                                                    height: height * 0.01,
                                                  ),
                                                  Text(
                                                    localFetchedNote[index]
                                                        .content,
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      })
                                  : MasonryGridView.builder(
                                      physics: BouncingScrollPhysics(),
                                      mainAxisSpacing: 2,
                                      crossAxisSpacing: 4,
                                      shrinkWrap: true,
                                      gridDelegate:
                                          SliverSimpleGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 2),
                                      itemCount: notesList.length,
                                      itemBuilder: (context, index) {
                                        return InkWell(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        NoteScreen(
                                                            note: notesList[
                                                                index])));
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color:
                                                        white.withOpacity(0.4)),
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 10),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(notesList[index].title,
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                  SizedBox(
                                                    height: height * 0.01,
                                                  ),
                                                  Text(
                                                    notesList[index].content,
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      })
                        ]),
                  )
                ],
              ),
            )),
          );
  }
}
