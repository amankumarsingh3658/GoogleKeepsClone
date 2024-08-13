// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:googlekeepnotesclone/Services/Mynotemodel.dart';
import 'package:googlekeepnotesclone/Services/db.dart';
import 'package:googlekeepnotesclone/UI/Screen/Home.dart';
import 'package:googlekeepnotesclone/UI/Screen/editnotescreen.dart';
import 'package:googlekeepnotesclone/Utilities/colors.dart';

class NoteScreen extends StatefulWidget {
  Note note;
  NoteScreen({super.key, required this.note});

  @override
  State<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    final height = mq.height;
    // final width = mq.width;
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => Home()));
            },
            icon: Icon(
              Icons.arrow_back_outlined,
              color: white,
            )),
        backgroundColor: bgColor,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            EditNotesScreen(note: widget.note)));
              },
              icon: Icon(
                Icons.edit_outlined,
                color: white,
              )),
          IconButton(
              onPressed: () {
                NotesDatabase.instance.deleteNote(widget.note);
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => Home()));
              },
              icon: Icon(
                Icons.delete_forever_outlined,
                color: white,
              )),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.note.title,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold)),
            SizedBox(
              height: height * 0.01,
            ),
            Text(
              widget.note.content,
              style: TextStyle(color: Colors.white),
            )
          ],
        ),
      ),
    );
  }
}
