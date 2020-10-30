import 'package:characters/characters.dart';

// This function is used while uploading a product to firestore.
// It takes a string and creates an array of strings that has length of multiples of 3.
// This function makes querying easy while using search feature.
List<String> returnSplitStringList(String theActualString) {
  int totalLength = theActualString.characters.length;
  List<String> returnList = [];
  List<int> additionalSearchStrings = [4, 5, 7, 8];
  // int arrayLength = totalLength ~/ 3;
  if (totalLength < 15) {
    for (int i = 3; i < totalLength; i += 3) {
      returnList.add(theActualString.substring(0, i).trim().toLowerCase());
    }
  } else {
    for (int i = 3; i < 15; i += 3) {
      returnList.add(theActualString.substring(0, i).trim().toLowerCase());
    }
  }
  additionalSearchStrings.forEach((element) {
    if (theActualString.trim().length > element) {
      returnList.add(theActualString.substring(0, element));
    }
  });
  // Adds the real product name to the list.
  returnList.add(theActualString.trim().toLowerCase());
  return returnList;
}
