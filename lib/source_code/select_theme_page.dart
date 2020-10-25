import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_app_code/themes/theme_model.dart';

// Tab bar view to select the color of the app
class SelectThemeClass extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Container(
        height: MediaQuery.of(context).size.width * 0.6,
        width: MediaQuery.of(context).size.width * 0.6,
        child: GestureDetector(
          onTap: () => _showModal(context),
          child: CircleAvatar(
            backgroundColor: Theme.of(context).primaryColor,
          ),
        ),
      ),
    );
  }

// The bottom modal sheets that displays list tiles that allows you to choose the color
  void _showModal(context) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(MediaQuery.of(context).size.height * 0.015),
        ),
        context: context,
        builder: (BuildContext context) {
          return Container(
              height: MediaQuery.of(context).size.height * 0.4,
              child: ListView(
                children: <Widget>[
                  Center(
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.6,
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  color: Theme.of(context).primaryColor,
                                  width: 4))),
                      padding: EdgeInsets.only(top: 10, bottom: 10),
                      alignment: Alignment.center,
                      child: Text(
                        "Select Theme Color",
                        style: TextStyle(
                            color: Theme.of(context).textTheme.headline6.color),
                      ),
                    ),
                  ),
                  ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.pink,
                    ),
                    title: Text("Pink"),
                    onTap: () {
                      Provider.of<ThemeModel>(context, listen: false)
                          .changeToPink();
                    },
                  ),
                  // ListTile(
                  //   leading: CircleAvatar(
                  //     backgroundColor: Colors.cyanAccent,
                  //   ),
                  //   title: Text("Cyan"),
                  //   onTap: () {
                  //     Provider.of<ThemeModel>(context, listen: false)
                  //         .changeToCyan();
                  //   },
                  // ),
                  ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.greenAccent[700],
                    ),
                    title: Text("Green"),
                    onTap: () {
                      Provider.of<ThemeModel>(context, listen: false)
                          .changeToGreen();
                    },
                  ),
                  ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.redAccent,
                    ),
                    title: Text("Red"),
                    onTap: () {
                      Provider.of<ThemeModel>(context, listen: false)
                          .changeToRed();
                    },
                  ),
                  // ListTile(
                  //   leading: CircleAvatar(
                  //     backgroundColor: Colors.yellowAccent,
                  //   ),
                  //   title: Text("Yellow"),
                  //   onTap: () {
                  //     Provider.of<ThemeModel>(context, listen: false)
                  //         .changeToYellow();
                  //   },
                  // )
                ],
              ));
        });
  }
}
