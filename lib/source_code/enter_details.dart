import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:social_app_code/custom_widgets/show_dialog.dart';
import 'package:social_app_code/models/user.dart';
import 'package:social_app_code/decoration/formTextFieldBorder.dart';

// The Scaffold that is used to enter user details like name, college, college Address.
class ModifyDetailsPage extends StatefulWidget {
// EditdetailsPage is used to edit users name, college, collegeAddress
  @override
  _ModifyDetailsPageState createState() => _ModifyDetailsPageState();
}

class _ModifyDetailsPageState extends State<ModifyDetailsPage> {
  //Form key
  final _editFormKey = GlobalKey<FormState>();

  // TexteditingControllers for three fields i.e ProfileName, CollegeName, CollegeAddress.
  TextEditingController name =
      TextEditingController(); // controller for name field.

  TextEditingController college =
      TextEditingController(); // controller for college field.

  TextEditingController collegeAddress =
      TextEditingController(); // controller for collegeAddress field.

  SharedPreferences myPrefs; // SharedPreference variable to get instance of it.

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final userVar = Provider.of<TheUser>(context, listen: false);
      name.text = userVar.userName();
      college.text = userVar.userCollege();
      collegeAddress.text = userVar.userCollegeAddress();
    });
    super.initState();
  }

  // Upload the entered details to firestore.
  uploadDetailsToFirestore() async {
    await FirebaseFirestore.instance.collection('users').doc(TheUser.id).set({
      "name": name.text.trim(),
      "college": college.text.trim(),
      "collegeAddress": collegeAddress.text.trim(),
    }, SetOptions(merge: true));
  }

// We will use this function to fetch data from firestore and updata local data.
  reInitializeTheUserFromFirestore(context) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(TheUser.id)
        .get()
        .then((value) => {
              Provider.of<TheUser>(context).user_Name(
                  value.data()['name'],
                  value.data()['college'],
                  value.data()['collegeAddress'],
                  value.data()['savedItems'],
                  value.data()["avatar"])
            });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Form(
          key: _editFormKey,
          child: Column(
            children: [
              // The name Text form field
              Expanded(
                flex: 3,
                child: Padding(
                  // Padding widget is used to apply padding on all the sides pf text form field.
                  padding: const EdgeInsets.all(10.0),

                  child: TextFormField(
                    controller: name, // assigned the name controller.

                    decoration: inputBorder(context, "Name", Icons.person),

                    style: TextStyle(color: Theme.of(context).primaryColor),

                    cursorColor: Theme.of(context).primaryColor,

                    validator: (value) {
                      if (name.text.length == 0 || name.text.length > 30) {
                        return "Enter a valid name. And name should be less than 30 characters.";
                      }
                      return null;
                    },
                  ),
                ),
              ),

              Expanded(
                child: Container(),
                flex: 3,
              ),

              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextFormField(
                    controller: college, // assigned the colllege controller.

                    cursorColor: Theme.of(context).primaryColor,

                    style: TextStyle(color: Theme.of(context).primaryColor),

                    decoration: inputBorder(context, "College", Icons.business),

                    validator: (value) {
                      if (name.text.length == 0) {
                        return "!Enter a valid College name.";
                      }
                      return null;
                    },
                  ),
                ),
              ),

              Expanded(
                child: Container(),
                flex: 3,
              ),

              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextFormField(
                    controller:
                        collegeAddress, // assigned the collegeAddress controller.

                    cursorColor: Theme.of(context).primaryColor,

                    style: TextStyle(color: Theme.of(context).primaryColor),

                    decoration: inputBorder(
                        context, "College Address", Icons.add_location),

                    validator: (value) {
                      if (name.text.length == 0) {
                        return "Enter a valid College Address.";
                      }
                      return null;
                    },
                  ),
                ),
              ),

              Expanded(
                child: Container(),
                flex: 3,
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: RaisedButton(
                      elevation: 10,
                      onPressed: () {
                        if (_editFormKey.currentState.validate()) {
                          uploadDetailsToFirestore();
                          reInitializeTheUserFromFirestore(context);
                          showAlertDialogBox(
                              context,
                              "The Details Have been successfully updated",
                              "Info");
                        }
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      color: Theme.of(context).primaryColor,
                      child: Text(
                        "Submit",
                        style: TextStyle(
                          color: Theme.of(context).backgroundColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(flex: 1, child: Container())
            ],
          )),
    );
  }
}
