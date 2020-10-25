import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:social_app_code/custom_widgets/show_dialog.dart';
import 'package:social_app_code/custom_widgets/show_snack_bar.dart';
import 'package:social_app_code/functions/split_string.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:social_app_code/decoration/formTextFieldBorder.dart';

// This page has only portarit mode configuration please change to satisfy landscape orientation too.

class TheImagePickerScreen extends StatefulWidget {
  TheImagePickerScreen();

  @override
  _TheImagePickerScreenState createState() => _TheImagePickerScreenState();
}

class _TheImagePickerScreenState extends State<TheImagePickerScreen> {
  final _formkey = GlobalKey<FormState>(); // form key

  TextEditingController _nameOfProduct =
      TextEditingController(); // contoller for name field of the form
  TextEditingController _priceOfProduct =
      TextEditingController(); // controller for price field of the form
  TextEditingController _descriptionOfProduct =
      TextEditingController(); // controller for descrption field of the form

  bool _canBeUploaded =
      false; // This variable is used to upload your product only if you have entered your details already else an alert dialog box will be displayed.

  bool _isUploading =
      false; // This variable is used to set a progressbar while the product is uploading.

  String _value; // The value used in dropdown menu.

  File _image1, _image2, _image3;

  String userName;
  String userCollege;
  String userCollegeAddress;
  String userID;
  String usermail;

  List images = [
    null,
    null,
    null
  ]; // The three images that has to be selected by the user to upload.
  List urls = new List();

// function used to pick the image and crop it and return the cropped image
  Future selectImage() async {
    var image = await ImagePicker().getImage(source: ImageSource.gallery);

    // Now we call the ImageCropper package to crop the image to the required 4:3 aspect ratio.
    File croppedImage = await ImageCropper.cropImage(
        sourcePath: image.path,
        aspectRatio: CropAspectRatio(ratioX: 4.0, ratioY: 3.0),
        androidUiSettings: AndroidUiSettings(
            toolbarColor: Theme.of(context).primaryColor,
            toolbarWidgetColor: Theme.of(context).backgroundColor,
            statusBarColor: Theme.of(context).primaryColor,
            hideBottomControls: false,
            activeControlsWidgetColor: Theme.of(context).primaryColor));
    // return File(image.path);
    return croppedImage;
  }

// This function is used to upload the enterd details and selected images to firebase storage and firestore.
  uploadPics(BuildContext context) async {
    if (images.length == 3 &&
        images[0] != null &&
        images[1] != null &&
        images[2] != null) {
      setState(() {
        _isUploading = true;
      });
      images.forEach((element) async {
        String imageName = "SocialAppCode" +
            Uuid().v1() +
            ".jpg"; // The unique name that will be used for the image going to be stored in firebase storage.
        StorageReference fireStorageRef =
            FirebaseStorage.instance.ref().child(_value).child(imageName);
        //  + usermail + DateTime.now().toLocal().toString()
        StorageUploadTask uploadTask = fireStorageRef.putFile(element);
        // ignore: unused_local_variable
        StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
        setState(() async {
          if (uploadTask.isSuccessful) {
            var add1 = await fireStorageRef.getDownloadURL();
            urls.add(add1);
            if (urls.length == 3) {
              // After all three images have been uploaded to firebase we start adding the product details to firestore.
              FirebaseFirestore.instance.collection("products").add({
                "name": _nameOfProduct.text.trim(),
                "description": _descriptionOfProduct.text.trim(),
                "price": _priceOfProduct.text.trim(),
                "category": _value,
                "uid": userID,
                "userEmail": usermail,
                "userName": userName,
                "college": userCollege,
                "collegeAddress": userCollegeAddress,
                "searchArray":
                    returnSplitStringList(_nameOfProduct.text.trim()),
                "url1": urls[0],
                "url2": urls[1],
                "url3": urls[2]
              }).then((value) => {
                    FirebaseFirestore.instance
                        .collection("users")
                        .doc(userID)
                        .set({
                      "addedItems": FieldValue.arrayUnion([
                        {
                          "name": _nameOfProduct.text,
                          "description": _descriptionOfProduct.text,
                          "price": _priceOfProduct.text,
                          "pid": value.id,
                          "category": _value,
                          "userEmail": usermail,
                          "userName": userName,
                          "college": userCollege,
                          "collegeAddress": userCollegeAddress,
                          "url1": urls[0],
                          "url2": urls[1],
                          "url3": urls[2]
                        }
                      ])
                    }, SetOptions(merge: true))
                  });
              setState(() {
                _isUploading = false;
              });
              showSnackBar(
                  context: context,
                  theContent: "Uploaded Product details successfully");
              // toshowSnackBar("Uploaded Product details successfully");
            }
          } else {
            setState(() {
              _isUploading = false;
            });
            showSnackBar(
                context: context,
                theContent:
                    "There seems to be some problem in uploading images please try again.");
            // toshowSnackBar(
            // "There seems to be some problem in uploading images please try again.");
          }
        });
      });
    } else {
      setState(() {
        // toshowSnackBar("Please select all three images");
        showSnackBar(
            context: context, theContent: "Please select all three images");
      });
    }
  }

  initializeUserDetails() async {
    var _auth = FirebaseAuth.instance;
    var firUserDoc = await FirebaseFirestore.instance
        .collection("users")
        .doc(_auth.currentUser.uid)
        .get();
    var userVar = _auth.currentUser;
    userName = firUserDoc.data()["name"];
    userID = _auth.currentUser.uid.toString();
    userCollege = firUserDoc.data()["college"];
    userCollegeAddress = firUserDoc.data()["collegeAddress"];
    usermail = userVar.email;
    if ((usermail != null) && (userName != null) && (userCollege != null)) {
      _canBeUploaded = true;
    }
  }

  @override
  void initState() {
    initializeUserDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _isUploading
        ? Container(
            height: MediaQuery.of(context).size.height * 0.1,
            width: MediaQuery.of(context).size.height * 0.1,
            child: Center(child: CircularProgressIndicator()),
          )
        : Container(
            child: Form(
              key: _formkey,
              child: Column(
                children: [
                  Expanded(
                      flex: 9,
                      child: Container(
                        padding: EdgeInsets.all(15),
                        // height: MediaQuery.of(context).size.height * 0.5,
                        // width: MediaQuery.of(context).size.width * 0.8,

                        child: Container(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            children: [
                              //  Widget for dispalying and text form field of NAME.
                              Expanded(
                                  flex: 2,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextFormField(
                                      controller: _nameOfProduct,
                                      keyboardType: TextInputType.name,
                                      cursorColor:
                                          Theme.of(context).primaryColor,
                                      decoration: inputBorder(
                                          context,
                                          "Name of Product",
                                          Icons.import_contacts),
                                      validator: (value) {
                                        if (_nameOfProduct.text.length == 0) {
                                          return "Name of the Product is required.";
                                        }
                                        return null;
                                      },
                                    ),
                                  )),

                              //  Widget for dispalying and text form field of DESCRIPTION
                              Expanded(
                                  flex: 2,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextFormField(
                                      cursorColor:
                                          Theme.of(context).primaryColor,
                                      keyboardType: TextInputType.text,
                                      controller: _descriptionOfProduct,
                                      decoration: inputBorder(context,
                                          "Description of Product", Icons.info),
                                    ),
                                  )),

                              // Displays Row widget containing CATEGORY dropdown and PRICE foem field.
                              Expanded(
                                  flex: 2,
                                  child: Container(
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: DropdownButtonFormField(
                                            decoration: InputDecoration(
                                                errorStyle: TextStyle(
                                                    color: Theme.of(context)
                                                        .primaryColor),
                                                border: OutlineInputBorder(
                                                    borderSide:
                                                        BorderSide.none)),
                                            hint: Text(
                                              "Category",
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .primaryColor),
                                            ),
                                            icon: Icon(
                                              Icons.arrow_drop_down,
                                              color: Theme.of(context)
                                                  .iconTheme
                                                  .color,
                                            ),
                                            value: _value,
                                            items: [
                                              _dropDownItem("Books"),
                                              _dropDownItem("Bicycle"),
                                              _dropDownItem("Electronics"),
                                              _dropDownItem("Others")
                                            ],
                                            onChanged: (value) {
                                              setState(() {
                                                _value = value;
                                              });
                                            },
                                            validator: (value) {
                                              if (_value == null) {
                                                return "Please select a category";
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                        Expanded(
                                          child: TextFormField(
                                            controller: _priceOfProduct,
                                            keyboardType: TextInputType.number,
                                            decoration: inputBorder(context,
                                                "Price", Icons.attach_money),
                                            validator: (value) {
                                              if ((_priceOfProduct
                                                          .text.length ==
                                                      0) ||
                                                  _priceOfProduct.text.contains(
                                                      new RegExp(
                                                          r'[A-Za-z]'))) {
                                                return "Price of product is required.";
                                              }
                                              return null;
                                            },
                                          ),
                                        )
                                      ],
                                    ),
                                  )),
                              Expanded(
                                flex: 3,
                                child: Container(
                                  child: Row(
                                    // The row widget containing the three upload icons. On clicking them u can choose the image and crop it.
                                    children: [
                                      Expanded(
                                          flex: 2,
                                          child: GestureDetector(
                                            onTap: () async {
                                              var image1 = await selectImage();
                                              if (image1.path != null) {
                                                images.removeAt(0);
                                                images.insert(
                                                    0, File(image1.path));
                                              }
                                              setState(() {
                                                _image1 = File(image1.path);
                                              });
                                            },
                                            child: Container(
                                                padding: EdgeInsets.all(5),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                child: (_image1 != null)
                                                    ? Icon(
                                                        Icons
                                                            .check_circle_outline,
                                                        color: Theme.of(context)
                                                            .primaryColor,
                                                      )
                                                    : Icon(
                                                        Icons.file_upload,
                                                        // size: MediaQuery.of(context)
                                                        //         .size
                                                        //         .width *
                                                        //     0.1,
                                                        color: Theme.of(context)
                                                            .primaryColor,
                                                      )),
                                          )),
                                      Expanded(
                                          flex: 2,
                                          child: GestureDetector(
                                            onTap: () async {
                                              var image1 = await selectImage();
                                              if (image1.path != null) {
                                                images.removeAt(1);
                                                images.insert(
                                                    1, File(image1.path));
                                              }
                                              setState(() {
                                                _image2 = File(image1.path);
                                              });
                                            },
                                            child: Container(
                                                padding: EdgeInsets.all(5),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                child: (_image2 != null)
                                                    ? Icon(
                                                        Icons
                                                            .check_circle_outline,
                                                        color: Theme.of(context)
                                                            .primaryColor,
                                                      )
                                                    : Icon(
                                                        Icons.file_upload,
                                                        color: Theme.of(context)
                                                            .primaryColor,
                                                      )),
                                          )),
                                      Expanded(
                                          flex: 2,
                                          child: GestureDetector(
                                            onTap: () async {
                                              var image1 = await selectImage();
                                              if (image1.path != null) {
                                                images.removeAt(2);
                                                images.insert(
                                                    2, File(image1.path));
                                              }
                                              setState(() {
                                                _image3 = File(image1.path);
                                              });
                                            },
                                            child: Container(
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                child: (_image3 != null)
                                                    ? Icon(
                                                        Icons
                                                            .check_circle_outline,
                                                        color: Theme.of(context)
                                                            .primaryColor,
                                                      )
                                                    : Icon(
                                                        Icons.file_upload,
                                                        // size: MediaQuery.of(context)
                                                        //         .size
                                                        //         .width *
                                                        //     0.1,
                                                        color: Theme.of(context)
                                                            .primaryColor,
                                                      )),
                                          ))
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )),
                  Expanded(flex: 1, child: Container()),
                  Expanded(
                      flex: 1,
                      child: Container(
                        child: Row(
                          children: <Widget>[
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.05,
                            ),

                            // Clicking this button allows us to upload the selcted image to Firebase cloud storage
                            Container(
                              width: MediaQuery.of(context).size.width * 0.9,
                              alignment: Alignment.center,
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.6,
                                child: RaisedButton(
                                  onPressed: () {
                                    if (_formkey.currentState.validate()) {
                                      if (_canBeUploaded == true) {
                                        // Your product will be uploaded only if you have already entered your details.
                                        uploadPics(context);
                                      } else {
                                        // else an alert dialog box will be displayed asking you to enter your details.
                                        showAlertDialogBox(
                                            context,
                                            "Please make sure your name, college has been updated.",
                                            "info");
                                      }
                                    }
                                  },
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30)),
                                  color: Theme.of(context).primaryColor,
                                  child: Text(
                                    "Upload Image",
                                    style: TextStyle(
                                        color:
                                            Theme.of(context).backgroundColor),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.05,
                            ),
                          ],
                        ),
                      )),
                  Expanded(flex: 1, child: Container()),
                  // Expanded(
                  //     child: Container(
                  //   padding: EdgeInsets.all(5),
                  //   child: Text(
                  //     "Note: The preferres size of images is 300x200",
                  //     style: TextStyle(color: Theme.of(context).primaryColor),
                  //   ),
                  // ))
                ],
              ),
            ),
          );
  }

// A function for returning drop down menu item.
  DropdownMenuItem _dropDownItem(String value) {
    return DropdownMenuItem(
      child: Text(
        value,
        style: TextStyle(color: Theme.of(context).primaryColor),
      ),
      value: value,
      onTap: () {
        _value = value;
      },
    );
  }
}
