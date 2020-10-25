import 'package:flutter/material.dart';
import 'package:social_app_code/source_code/listview.dart';

// The first tab in the tab bar view. This is used to choose the product category that you want to view.
class TheHomePageView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Theme.of(context).backgroundColor,
        child: Column(
          children: <Widget>[
            Flexible(
                flex:
                    (MediaQuery.of(context).orientation == Orientation.portrait)
                        ? 8
                        : 6,
                fit: FlexFit.tight,
                child: Container(
                    child: (MediaQuery.of(context).orientation ==
                            Orientation.portrait)
                        ? Column(
                            children: <Widget>[
                              Expanded(
                                  child: Row(
                                children: <Widget>[
                                  TheTile(1, Icons.import_contacts, "Books"),
                                  TheTile(2, Icons.directions_bike, "Bicycle")
                                ],
                              )),
                              Expanded(
                                  child: Row(
                                children: <Widget>[
                                  TheTile(
                                      3, Icons.devices_other, "Electronics"),
                                  TheTile(4, Icons.add_box, "Others")
                                ],
                              ))
                            ],
                          )
                        : Row(
                            children: <Widget>[
                              TheTile(1, Icons.import_contacts, "Books"),
                              TheTile(2, Icons.directions_bike, "Bicycle"),
                              TheTile(3, Icons.devices_other, "Electronics"),
                              TheTile(4, Icons.add_box, "Others")
                            ],
                          ))),
          ],
        ));
  }
}

//In these widgets we will be adding clickable images so as users can select what they want to view.
class TheTile extends StatelessWidget {
  final int goto; // The identifier used to know the catergory
  final IconData theIcon; // Icon that has to displayed in the category tile
  final String theTitle; // category name.
  TheTile(this.goto, this.theIcon, this.theTitle);
  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.width * 0.5,
        width: MediaQuery.of(context).size.width * 0.5,
        padding: EdgeInsets.all(
            (MediaQuery.of(context).orientation == Orientation.portrait)
                ? MediaQuery.of(context).size.width * 0.05
                : MediaQuery.of(context).size.height * 0.025),
        child: Card(
            color: Theme.of(context).primaryColor,
            child: InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            TheListView(category: this.theTitle)));
              },
              splashColor: Theme.of(context).splashColor,
              child: Column(
                children: <Widget>[
                  Expanded(
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(
                              MediaQuery.of(context).size.width * 0.025),
                          child: Icon(
                            this.theIcon,
                            color: Theme.of(context).backgroundColor,
                            size: MediaQuery.of(context).size.width * 0.1,
                          )),
                      flex: 3),
                  Expanded(
                    child: Center(
                      child: Text(
                        this.theTitle,
                        style: TextStyle(
                            color: Theme.of(context).backgroundColor,
                            fontSize: 16),
                      ),
                    ),
                    flex: 1,
                  )
                ],
              ),
            )));
  }
}
