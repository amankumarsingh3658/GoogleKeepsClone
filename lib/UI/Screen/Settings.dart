import 'package:flutter/material.dart';
import 'package:googlekeepnotesclone/Utilities/colors.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool value = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_outlined,color: white,)),
        backgroundColor: bgColor,
        elevation: 0.0,
        title: Text(
          "Settings",
          style: TextStyle(color: white),
        ),
      ),
      backgroundColor: bgColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  "Sync",
                  style: TextStyle(color: white, fontSize: 18),
                ),
                Spacer(),
                Switch.adaptive(
                    value: value,
                    onChanged: (switchvalue) {
                      setState(() {
                        this.value = switchvalue;
                      });
                    })
              ],
            )
          ],
        ),
      ),
    );
  }
}
