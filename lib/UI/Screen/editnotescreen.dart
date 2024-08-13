// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:googlekeepnotesclone/Services/Mynotemodel.dart';
import 'package:googlekeepnotesclone/Services/db.dart';
import 'package:googlekeepnotesclone/UI/Screen/NotesScreen.dart';
import 'package:googlekeepnotesclone/Utilities/colors.dart';

class EditNotesScreen extends StatefulWidget {
  Note note;
  EditNotesScreen({super.key, required this.note});

  @override
  State<EditNotesScreen> createState() => _EditNotesScreenState();
}

class _EditNotesScreenState extends State<EditNotesScreen> {
  late String newTitle;
  late String newContent;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.newTitle = widget.note.title;
    this.newContent = widget.note.content;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () async {
              Note newnote = Note(
                    id: widget.note.id,
                    pin: widget.note.pin,
                    title: newTitle,
                    content: newContent,
                    createdtime: DateTime.now());
                await NotesDatabase.instance.updateNote(newnote);

                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NoteScreen(note: newnote)));
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_outlined,
              color: white,
            )),
        backgroundColor: bgColor,
        actions: [
          IconButton(
              onPressed: () async {
                Note newnote = Note(
                    id: widget.note.id,
                    pin: widget.note.pin,
                    title: newTitle,
                    content: newContent,
                    createdtime: DateTime.now());
                await NotesDatabase.instance.updateNote(newnote);

                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NoteScreen(note: newnote)));
              },
              icon: Icon(
                Icons.save_outlined,
                color: white,
              ))
        ],
      ),
      body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Form(
            child: Column(
              children: [
                Container(
                  color: bgColor,
                  child: TextFormField(
                    initialValue: newTitle,
                    style: TextStyle(color: white),
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Title",
                        hintStyle: TextStyle(
                            fontSize: 18, color: Colors.grey.withOpacity(0.9))),
                    onChanged: (value) {
                      newTitle = value;
                    },
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    initialValue: newContent,
                    keyboardType: TextInputType.multiline,
                    minLines: 10,
                    maxLines: null,
                    style: TextStyle(color: white),
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Note",
                        hintStyle:
                            TextStyle(color: Colors.grey.withOpacity(0.9))),
                    onChanged: (value) {
                      newContent = value;
                    },
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
