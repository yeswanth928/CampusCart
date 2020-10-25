import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_app_code/custom_widgets/custom_search.dart';
import 'package:social_app_code/models/user.dart';
import 'package:social_app_code/source_code/cart.dart';
import 'main_drawer.dart';
import '../list/tabBarList.dart';

// The landing page after the user logs in, and has a tab bar view.
class TheHomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TheHomePage();
  }
}

class _TheHomePage extends State<TheHomePage> with TickerProviderStateMixin {
  final _scaffoldKey = GlobalKey<ScaffoldState>(); // The scaffold key
  List tabBarBody = tabBodyScreens; // The screens that used in tab bar view
  List tabBarIcons = tabBarItems; // Icons used in tab bar.
  TabController _tabController; // Tab  bar controller

  @override
  void initState() {
    // Initialize the user details from firestore.
    FirebaseFirestore.instance
        .collection('users')
        .doc(TheUser.id)
        .get()
        .then((value) => {
              Provider.of<TheUser>(context, listen: false).user_Name(
                  value.data()['name'],
                  value.data()['college'],
                  value.data()['collegeAddress'],
                  value.data()['savedItems'],
                  value.data()['avatar'])
            });
    _tabController = TabController(length: tabBarBody.length, vsync: this);
    _tabController.addListener(() {
      _tabChanged();
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  void _tabChanged() {
    if (_tabController.indexIsChanging) {
      return tabBarBody[_tabController.index];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomPadding: false,
      appBar: PreferredSize(
          child: AppBar(
            backgroundColor: Theme.of(context).primaryColor,
            elevation: 1,
            shape: RoundedRectangleBorder(
                side: BorderSide.none,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(5),
                    bottomRight: Radius.circular(5))),
            leading: ImageIcon(
              AssetImage("images/logo_white_png_1080.png"),
              color: Theme.of(context).backgroundColor,
              size: MediaQuery.of(context).size.height * 0.04,
            ),
            title: Text(
              "Campus Cart",
              style: TextStyle(
                  fontSize:
                      MediaQuery.of(context).orientation == Orientation.portrait
                          ? MediaQuery.of(context).size.height * 0.03
                          : MediaQuery.of(context).size.height * 0.05,
                  color: Theme.of(context).backgroundColor),
            ),
            actions: <Widget>[
              IconButton(
                  icon: Icon(Icons.shopping_cart,
                      color: Theme.of(context).backgroundColor),
                  onPressed: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => TheCart()));
                  }),
              IconButton(
                icon: Icon(
                  Icons.more_vert,
                  color: Theme.of(context).backgroundColor,
                ),
                onPressed: () {
                  _scaffoldKey.currentState.openEndDrawer();
                },
              )
            ],
          ),
          preferredSize:
              (MediaQuery.of(context).orientation == Orientation.portrait)
                  ? Size.fromHeight(MediaQuery.of(context).size.height * 0.08)
                  : Size.fromHeight(MediaQuery.of(context).size.height * 0.1)),
      endDrawer: TheMainDrawer(),
      body: TabBarView(
        children: tabBarBody,
        controller: _tabController,
      ),
      bottomNavigationBar: TabBar(
        tabs: tabBarIcons,
        controller: _tabController,
        indicatorColor: Theme.of(context).primaryColor,
        labelColor: Theme.of(context).tabBarTheme.labelColor,
        unselectedLabelColor:
            Theme.of(context).tabBarTheme.unselectedLabelColor,
        labelPadding: Theme.of(context).tabBarTheme.labelPadding,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        elevation: 5,
        backgroundColor:
            Theme.of(context).floatingActionButtonTheme.backgroundColor,
        onPressed: () {
          showSearch(context: context, delegate: TheCustomSearchPage(context));
          // Navigator.push(
          //     context, MaterialPageRoute(builder: (context) => Search()));
        },
        child: Icon(
          Icons.search,
          color: Theme.of(context).floatingActionButtonTheme.foregroundColor,
        ),
      ),
    );
  }
}
