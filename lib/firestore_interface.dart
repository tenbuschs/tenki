import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

String uid = FirebaseAuth.instance.currentUser!.uid;
String householdId = "";

class DatabaseInterface {
  final CollectionReference users =
      FirebaseFirestore.instance.collection('users');

  static Future<void> addExampleDataMap(String hid) async {
    householdId = hid;
    CollectionReference storageMaps =
        FirebaseFirestore.instance.collection('storageMaps');
    await storageMaps.doc(householdId).set({
      'storageMap': {
        "items": [],
      },
    });
  }


  Future<void> addItemToStorageMap(Map<String, dynamic> itemMap) async {
    try {
      final hid = await getHouseholdId();
      final DocumentReference<Map<String, dynamic>> documentReference =
          FirebaseFirestore.instance.collection('storageMaps').doc(hid);
      final DocumentSnapshot<Map<String, dynamic>> snapshot =
          await documentReference.get();
      final Map<String, dynamic> storageMap = snapshot.data()!['storageMap'];
      List<Map<String, dynamic>> items =
          List<Map<String, dynamic>>.from(storageMap['items']);
      items.add(itemMap);
      storageMap['items'] = items;
      await documentReference.set({'storageMap': storageMap});
    } catch (e) {
      print('Error adding item to storage map: $e');
    }
  }

  Future<void> updateItemByName(
      String itemName, Map<String, dynamic> updatedItemData) async {
    final hid = await getHouseholdId();
    final storageMapRef =
        FirebaseFirestore.instance.collection('storageMaps').doc(hid);
    final storageMapDoc = await storageMapRef.get();

    final storageMap = storageMapDoc.data()?['storageMap'] ?? {};
    final items = storageMap['items'] ?? [];

    final updatedItems = items.map((item) {
      if (item['name'] == itemName) {
        return {...item, ...updatedItemData};
      }
      return item;
    }).toList();

    final updatedStorageMapData = {
      'storageMap': {'items': updatedItems}
    };
    await storageMapRef.update(updatedStorageMapData);
  }

  Future<void> deleteItemByName(String itemName) async {
    final hid = await getHouseholdId();
    final storageMapRef =
        FirebaseFirestore.instance.collection('storageMaps').doc(hid);
    final storageMapDoc = await storageMapRef.get();

    final storageMap = storageMapDoc.data()?['storageMap'] ?? {};
    final items = storageMap['items'] ?? [];

    final updatedItems =
        items.where((item) => item['name'] != itemName).toList();

    final updatedStorageMapData = {
      'storageMap': {'items': updatedItems}
    };
    await storageMapRef.update(updatedStorageMapData);
  }

  static Future<void> addExampleLocationMap(String hid) async {
    CollectionReference locationMaps =
        FirebaseFirestore.instance.collection('locationMaps');
    await locationMaps.doc(hid).set({
      'locationMap': {
        "locations": [
          {
            'title': 'Neuer Lagerort',
            'iconId': 16,
          },
        ],
      },
    });
  }

  Future<void> addLocation(String title, int iconId) async {
    final hid = await getHouseholdId();
    CollectionReference locationMaps =
        FirebaseFirestore.instance.collection('locationMaps');
    DocumentReference docRef = locationMaps.doc(hid);
    DocumentSnapshot docSnapshot = await docRef.get();
    Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;
    List<dynamic> locations = data['locationMap']['locations'];
    locations.insert(locations.length - 1, {'title': title, 'iconId': iconId});
    await docRef.update({'locationMap.locations': locations});
  }

/*
* Delets a location and all items, that are stored in it
* */
  Future<void> deleteLocationAndItems(String locationTitle) async {
    try {
      final hid = await getHouseholdId();

      // Get the locationMap document and remove the location with the given title
      final DocumentReference<Map<String, dynamic>> locationDocumentReference =
          FirebaseFirestore.instance.collection('locationMaps').doc(hid);
      final DocumentSnapshot<Map<String, dynamic>> locationSnapshot =
          await locationDocumentReference.get();
      final Map<String, dynamic> locationMap =
          locationSnapshot.data()!['locationMap'];
      List<Map<String, dynamic>> locations =
          List<Map<String, dynamic>>.from(locationMap['locations']);
      int locationIndex = -1;
      for (int i = 0; i < locations.length; i++) {
        if (locations[i]['title'] == locationTitle) {
          locationIndex = i;
          break;
        }
      }
      if (locationIndex == -1) {
        //print('Location not found.');
        return;
      }
      locations.removeAt(locationIndex);
      locationMap['locations'] = locations;
      await locationDocumentReference.set({'locationMap': locationMap});

      // Get the storageMap document and remove items that are associated with the deleted location
      final DocumentReference<Map<String, dynamic>> storageDocumentReference =
          FirebaseFirestore.instance.collection('storageMaps').doc(hid);
      final DocumentSnapshot<Map<String, dynamic>> storageSnapshot =
          await storageDocumentReference.get();
      final Map<String, dynamic> storageMap =
          storageSnapshot.data()!['storageMap'];
      List<Map<String, dynamic>> items =
          List<Map<String, dynamic>>.from(storageMap['items']);
      List<Map<String, dynamic>> updatedItems = [];
      for (int i = 0; i < items.length; i++) {
        if (items[i]['location'] != locationTitle) {
          updatedItems.add(items[i]);
        }
      }
      storageMap['items'] = updatedItems;
      await storageDocumentReference.set({'storageMap': storageMap});
    } catch (e) {
      // print('Error deleting location and items: $e');
    }
  }

  Future<void> createHousehold(String hName) async {
    // store household map
    CollectionReference householdMaps =
        FirebaseFirestore.instance.collection('householdMaps');
    DocumentReference docRef = await householdMaps.add({
      'householdMap': {
        "household_name": hName,
        "key_user": uid,
      },
    });
    // print('Document added with ID: ${docRef.id}');

    //add household id to userMap
    await addUserMap(docRef.id);
    // add Storage Map
    await addExampleDataMap(docRef.id);
    // add Locations map
    await addExampleLocationMap(docRef.id);
  }

  static Future<void> addUserMap(String hid) async {
    uid = FirebaseAuth.instance.currentUser!.uid;
    CollectionReference userMaps =
        FirebaseFirestore.instance.collection('userMaps');
    await userMaps.doc(uid).set({
      'userMap': {
        "household_id": hid
        //"first_name":,
        //"last_name": ,
      },
    });
  }

  Future<bool> doesUserMapExist() async {
    uid = FirebaseAuth.instance.currentUser!.uid;
    try {
      final userMapDoc = await FirebaseFirestore.instance
          .collection('userMaps')
          .doc(uid)
          .get();
      return userMapDoc.exists;
    } catch (e) {
      // handle any exceptions here
      return false;
    }
  }

  Future<bool> doesHouseholdExist(String hid) async {
    try {
      final householdMapDoc = await FirebaseFirestore.instance
          .collection('householdMaps')
          .doc(hid)
          .get();
      return householdMapDoc.exists;
    } catch (e) {
      // handle any exceptions here
      return false;
    }
  }

  Future<void> joinHousehold(String hid) async {
    householdId = hid;
    await addUserMap(householdId);
  }

  Future<String?> getHouseholdName() async {

    String householdId = await getHouseholdId();

    // Get a reference to the household document
    DocumentReference docRef = FirebaseFirestore.instance
        .collection('householdMaps')
        .doc(householdId);

    // Retrieve the document data
    DocumentSnapshot snapshot = await docRef.get();
    Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;

    // If the document doesn't exist or has no data, return null
    if (snapshot.exists && data != null) {
      // Return the household name
      return data['householdMap']['household_name'];
    } else {
      return null;
    }
  }


  Future<String> getHouseholdId() async {
    uid = FirebaseAuth.instance.currentUser!.uid;
    try {
      final userMapDoc = await FirebaseFirestore.instance
          .collection('userMaps')
          .doc(uid)
          .get();
      if (userMapDoc.exists) {
        final userMap = userMapDoc.data()!['userMap'];
        if (userMap != null) {
          return userMap['household_id'];
        }
      }
      return "no household!";
    } catch (e) {
      // handle any exceptions here
      return "no household!";
    }
  }

  static Future<void> addFeedback({
    required String text,
    required DateTime dateTime,
  }) async {
    final feedbackRef = FirebaseFirestore.instance.collection('feedback');
    await feedbackRef.add({
      'text': text,
      'userId': uid,
      'dateTime': dateTime.toIso8601String(),
    });
  }
} // Ending class
