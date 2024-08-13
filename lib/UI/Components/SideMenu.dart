import 'package:flutter/material.dart';
import 'package:googlekeepnotesclone/UI/Screen/Settings.dart';
import 'package:googlekeepnotesclone/Utilities/colors.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({super.key});

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    var height = mq.height;
    var width = mq.width;
    return SafeArea(
      child: Drawer(
        backgroundColor: bgColor,
        child: Padding(
          padding: EdgeInsets.fromLTRB(0,0,10,0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 20, 0, 2),
                child: Text(
                  "Google Keep",
                  style: TextStyle(
                      color: white, fontSize: 25, fontWeight: FontWeight.bold),
                ),
              ),
              Divider(
                color: white.withOpacity(0.2),
              ),
              TextButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.orangeAccent.withOpacity(0.3)),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(50),
                              bottomRight: Radius.circular(50))))),
                  onPressed: () {},
                  child: Row(
                    children: [
                      Icon(
                        Icons.lightbulb,
                        color: white,
                        size: 25,
                      ),
                      SizedBox(
                        width: width * 0.04,
                      ),
                      Text(
                        "Notes",
                        style: TextStyle(fontSize: 18, color: white),
                      )
                    ],
                  )),
              // TextButton(
              //     onPressed: () {
              //       Navigator.push(context, MaterialPageRoute(builder: (context)=>ArchiveNotesScreen()));
              //     },
              //     child: Row(
              //       children: [
              //         Icon(
              //           Icons.archive_outlined,
              //           color: white,
              //           size: 25,
              //         ),
              //         SizedBox(
              //           width: width * 0.04,
              //         ),
              //         Text(
              //           "Archive",
              //           style: TextStyle(fontSize: 18, color: white),
              //         )
              //       ],
              //     )),
              // TextButton(
              //     onPressed: () {
              //       Navigator.push(context, MaterialPageRoute(builder: (context)=>SettingsScreen()));
              //     },
              //     child: Row(
              //       children: [
              //         Icon(
              //           Icons.settings,
              //           color: white,
              //           size: 25,
              //         ),
              //         SizedBox(
              //           width: width * 0.04,
              //         ),
              //         Text(
              //           "Settings",
              //           style: TextStyle(fontSize: 18, color: white),
              //         )
              //       ],
              //     ))
            ],
          ),
        ),
      ),
    );
  }
}
