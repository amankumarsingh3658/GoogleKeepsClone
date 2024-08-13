import 'package:flutter/material.dart';
import 'package:googlekeepnotesclone/Services/Mynotemodel.dart';
import 'package:googlekeepnotesclone/Services/db.dart';
import 'package:googlekeepnotesclone/UI/Screen/Home.dart';
import 'package:googlekeepnotesclone/Utilities/colors.dart';

class CreateNoteScreen extends StatefulWidget {
  const CreateNoteScreen({super.key});

  @override
  State<CreateNoteScreen> createState() => _CreateNoteScreenState();
}

class _CreateNoteScreenState extends State<CreateNoteScreen> {
  TextEditingController NoteController = TextEditingController();
  TextEditingController TitleController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    NoteController.dispose();
    TitleController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> Home()));
            },
            icon: Icon(
              Icons.arrow_back_outlined,
              color: white,
            )),
        backgroundColor: bgColor,
        actions: [
          IconButton(
              onPressed: () async {
                await NotesDatabase.instance.createEntry(Note(
                    pin: false,
                    title: TitleController.text,
                    content: NoteController.text,
                    createdtime: DateTime.now()));

                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => Home()));
              },
              icon: Icon(
                Icons.add,
                color: white,
              ))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            Container(
              color: bgColor,
              child: TextField(
                controller: TitleController,
                style: TextStyle(color: white),
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Title",
                    hintStyle: TextStyle(
                        fontSize: 18, color: Colors.grey.withOpacity(0.9))),
              ),
            ),
            Expanded(
              child: Container(
                child: TextField(
                  controller: NoteController,
                  keyboardType: TextInputType.multiline,
                  minLines: 10,
                  maxLines: null,
                  style: TextStyle(color: white),
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Note",
                      hintStyle:
                          TextStyle(color: Colors.grey.withOpacity(0.9))),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
