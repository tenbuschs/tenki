import 'package:flutter/material.dart';
import 'package:tenki/main_page.dart';
import 'package:tenki/tenki_material/tenki_icons.dart';
import 'barcode_scan.dart' as barcode_scan_page;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firestore_interface.dart';
import 'tenki_material/tenki_colors.dart';
import 'tenki_material/location_items.dart';
import 'tenki_material/category_items.dart';
import 'tenki_material/units.dart';

String currentLocation = '';

class TwoColumnLocationView extends StatefulWidget {
  const TwoColumnLocationView({Key? key}) : super(key: key);

  @override
  _TwoColumnLocationViewState createState() => _TwoColumnLocationViewState();
}

class _TwoColumnLocationViewState extends State<TwoColumnLocationView> {
  int selectedIndex = 0;
  //final PageController _pageControllerStorage = PageController();

  bool _showOverlay = false;
  bool _showPopup = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
            colors: [Color(0xFFE2DCCE), Color(0xFFFFFFFF)],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            tileMode: TileMode.clamp),
      ),
      padding: const EdgeInsets.all(10.0),
      child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("locationMaps")
              .doc(uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: Text("Waiting..."));
            } else if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            } else if (snapshot.hasData) {
              // transfer to useful format
              final DocumentSnapshot<Map<String, dynamic>>? newData =
                  snapshot.data;
              late Map<String, dynamic>? currentLocations =
                  newData?.data()?['locationMap'];

              return Stack(
                children: [
                  ListView.builder(
                    itemCount:
                        (currentLocations?["locations"].length / 2).ceil(),
                    itemBuilder: (BuildContext context, int index) {
                      int itemIndex = index * 2;
                      return Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                if (currentLocations?['locations'][itemIndex]
                                        ['title'] !=
                                    "Neuer Lagerort") {
                                  setState(() {
                                    _showOverlay = true;
                                  });

                                  currentLocation =
                                      currentLocations?['locations'][itemIndex]
                                          ['title'];
                                } else {
                                  setState(() {
                                    _showPopup = true;
                                  });
                                }
                              },
                              onLongPress: () {
                                if (currentLocations?['locations'][itemIndex]
                                        ['title'] !=
                                    "Neuer Lagerort") {
                                  // Show delete button
                                  showModalBottomSheet(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return Container(
                                        height: 120,
                                        color: Colors.redAccent,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            IconButton(
                                              icon: const Icon(Icons.delete,
                                                  color: Colors.white,
                                                  size: 35),
                                              onPressed: () async {
                                                DatabaseInterface dbInterface =
                                                    DatabaseInterface();
                                                await dbInterface
                                                    .deleteLocationAndItems(
                                                        currentLocations?[
                                                                    'locations']
                                                                [itemIndex]
                                                            ['title']);
                                                //close ModalBottomSheet
                                                Navigator.pop(context);
                                              },
                                            ),
                                            Text(
                                              currentLocations?['locations']
                                                      [itemIndex]['title'] +
                                                  " samt Inhalt dauerhaft löschen?",
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                } else {
                                  //"Neuer Lagerort" is not allowed to be deletable
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(18),
                                child: Container(
                                  height:
                                      MediaQuery.of(context).size.width * 0.4,
                                  decoration: BoxDecoration(
                                    color: TenkiColor1(),
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 75,
                                        height: 75,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.white,
                                          border: Border.all(
                                              color: Colors.grey, width: 2),
                                        ),
                                        child:
                                            LocationIcons.getLocationItemById(
                                                id: currentLocations?[
                                                        'locations'][itemIndex]
                                                    ['iconId'],
                                                size: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.14),
                                      ),
                                      SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.03),
                                      Text(
                                        currentLocations?['locations']
                                            [itemIndex]['title'],
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: itemIndex + 1 <
                                    currentLocations?["locations"].length
                                ? GestureDetector(
                                    onTap: () {
                                      if (currentLocations?['locations']
                                              [itemIndex + 1]['title'] !=
                                          "Neuer Lagerort") {
                                        setState(() {
                                          _showOverlay = true;
                                        });

                                        currentLocation =
                                            currentLocations?['locations']
                                                [itemIndex + 1]['title'];
                                      } else {
                                        setState(() {
                                          _showPopup = true;
                                        });
                                      }
                                    },
                                    onLongPress: () {
                                      if (currentLocations?['locations']
                                              [itemIndex + 1]['title'] !=
                                          "Neuer Lagerort") {
                                        // Show delete button
                                        showModalBottomSheet(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return Container(
                                              height: 120,
                                              color: Colors.redAccent,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  IconButton(
                                                    icon: const Icon(
                                                        Icons.delete,
                                                        color: Colors.white,
                                                        size: 35),
                                                    onPressed: () async {
                                                      DatabaseInterface
                                                          dbInterface =
                                                          DatabaseInterface();
                                                      await dbInterface
                                                          .deleteLocationAndItems(
                                                              currentLocations?[
                                                                      'locations']
                                                                  [itemIndex +
                                                                      1]['title']);
                                                      //close ModalBottomSheet
                                                      Navigator.pop(context);
                                                    },
                                                  ),
                                                  Text(
                                                    currentLocations?[
                                                                    'locations']
                                                                [itemIndex + 1]
                                                            ['title'] +
                                                        " samt Inhalt dauerhaft löschen?",
                                                    style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 16),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        );
                                      } else {
                                        //"Neuer Lagerort" is not allowed to be deletable
                                      }
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(18),
                                      child: Container(
                                        height:
                                            MediaQuery.of(context).size.width *
                                                0.4,
                                        decoration: BoxDecoration(
                                          color: TenkiColor1(),
                                          border:
                                              Border.all(color: Colors.grey),
                                          borderRadius:
                                              BorderRadius.circular(3),
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              width: 75,
                                              height: 75,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.white,
                                                border: Border.all(
                                                    color: Colors.grey,
                                                    width: 2),
                                              ),
                                              child: LocationIcons
                                                  .getLocationItemById(
                                                      id: currentLocations?[
                                                                  'locations']
                                                              [itemIndex + 1]
                                                          ['iconId'],
                                                      size:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.14),
                                            ),
                                            SizedBox(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.03),
                                            Text(
                                              currentLocations?['locations']
                                                  [itemIndex + 1]['title'],
                                              style:
                                                  const TextStyle(fontSize: 16),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                : Container(),
                          ),
                        ],
                      );
                    },
                  ),
                  _showOverlay
                      ? Center(
                          child: StorageTabContent(location: currentLocation))
                      : const SizedBox(),
                  _showPopup
                      ? const Center(child: PopupAddLocation())
                      : const SizedBox(),
                ],
              );
            } else {
              return const Center(child: Text("Unexpected Error"));
            }
          }),
    );
  }
}

// Baut den Inhalt der Lagerorte
class StorageTabContent extends StatefulWidget {
  String location = '';
  StorageTabContent({this.location = ''});

  @override
  _StorageTabContentState createState() => _StorageTabContentState();
}

class _StorageTabContentState extends State<StorageTabContent> {
  List<Map<String, dynamic>> _items = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
            colors: [Color(0xFFE2DCCE), Color(0xFFFFFFFF)],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            tileMode: TileMode.clamp),
      ),
      // padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              //color: Colors.grey,
              border: Border(
                bottom: BorderSide(
                  width: 1.0,
                  color: Colors.grey.shade300,
                ),
              ),
            ),
            child: Column(
              children: [
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 50.0,
                        height: 50.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.grey, width: 0.5),
                          color: TenkiColor4(),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 3,
                              offset: const Offset(1, 3),
                            ),
                          ],
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back, size: 30),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => TenkiMainPage()),
                            );
                          },
                        ),
                      ),
                      Container(
                        //width:150,
                        height: 50,
                        //                       color: TenkiColor1(),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                            color: Colors.grey,
                            width: 0.5,
                          ),
                          color: const Color(0xffadc4aa),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 3,
                              offset: const Offset(1, 3),
                            ),
                          ],
                        ),
                        padding: EdgeInsets.all(10),
                        child: Center(
                          child: Text(
                            widget.location,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 50.0,
                        height: 50.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.grey, width: 0.5),
                          color: TenkiColor4(),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 3,
                              offset: const Offset(1, 3),
                            ),
                          ],
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.add, size: 30),
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return PopupAddItem(
                                      location: widget.location);
                                });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
              ],
            ),
          ),
          StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("storageMaps")
                  .doc(uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: Text("Waiting..."));
                } else if (snapshot.hasError) {
                  return Center(child: Text(snapshot.error.toString()));
                } else if (snapshot.hasData) {
                  // transfer to useful format
                  final DocumentSnapshot<Map<String, dynamic>>? newData =
                      snapshot.data;
                  final Map<String, dynamic>? currentStorageMap =
                      newData?.data()?['storageMap'];

                  // just the items for the current location
                  _items = currentStorageMap?['items']
                      .where((item) => item['location'] == widget.location)
                      .toList()
                      .cast<Map<String, dynamic>>();

                  if (_items.isNotEmpty) {
                    return Flexible(
                      child: ListView.builder(
                        itemCount: _items.length,
                        itemBuilder: (BuildContext context, int index) {
                          final item = _items[index];
                          return SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Column(
                              children: [
                                const SizedBox(height: 8),
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.grey, width: 0.5),
                                    color: TenkiColor3(),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 2,
                                        blurRadius: 3,
                                        offset: const Offset(1, 3),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        height: 160,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.all(15),
                                              height: 80,
                                              width: 200,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  color:
                                                      const Color(0xfff5f5f5),
                                                ),
                                                child: Text(
                                                  item["name"],
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              padding: const EdgeInsets.all(15),
                                              height: 80,
                                              width: 200,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  color:
                                                      const Color(0xfff5f5f5),
                                                ),
                                                child: Text(
                                                  item["unit"],
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Container(
                                        height: 160,
                                        color: Colors.transparent,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Container(
                                              height: 80,
                                              padding: const EdgeInsets.all(10),
                                              child: Row(
                                                children: [
                                                  Container(
                                                      width: 50,
                                                      color: Colors.transparent,
                                                      child: const Text(
                                                        "Aktuell: ",
                                                        textAlign:
                                                            TextAlign.center,
                                                      )),
                                                  Container(
                                                    width: 80,
                                                    color: Colors.white,
                                                    child: TextFormField(
                                                      initialValue:
                                                          item['stockQuantity']
                                                              .toString(),
                                                      keyboardType:
                                                          TextInputType.number,
                                                      onFieldSubmitted: (value) =>
                                                          updateStockQuantity(
                                                              value, item),
                                                      decoration:
                                                          const InputDecoration(
                                                        hintText: 'Bestand',
                                                        border:
                                                            InputBorder.none,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              height: 80,
                                              padding: const EdgeInsets.all(10),
                                              child: Row(
                                                children: [
                                                  Container(
                                                      width: 50,
                                                      color: Colors.transparent,
                                                      child: const Text(
                                                        "Soll: ",
                                                        textAlign:
                                                            TextAlign.center,
                                                      )),
                                                  Container(
                                                    width: 80,
                                                    color: Colors.white,
                                                    child: TextFormField(
                                                      initialValue:
                                                          item['targetQuantity']
                                                              .toString(),
                                                      keyboardType:
                                                          TextInputType.number,
                                                      onFieldSubmitted: (value) =>
                                                          updateTargetQuantity(
                                                              value, item),
                                                      decoration:
                                                          const InputDecoration(
                                                        hintText: 'Soll',
                                                        border:
                                                            InputBorder.none,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 8),

                                      //Container for Shopping Category
                                      Container(
                                        height: 160,
                                        width: 160,
                                        color: TenkiColor3(),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              width: 60,
                                              height: 60,
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Colors.white,
                                                  border: Border.all(
                                                      color: Colors.grey,
                                                      width: 1)),
                                              child: HelperCategoryItems
                                                  .getCategoryWidget(
                                                      item['shoppingCategory']
                                                          .toString()),
                                            ),
                                            const SizedBox(height: 5),
                                            Text(item['shoppingCategory']
                                                .toString()),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      //Container for MHD
                                      Container(
                                        height: 160,
                                        color: TenkiColor4(),
                                        child: const Center(
                                          child: Text(
                                            'Hier steht iwan das MHD... ',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 24,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  } else {
                    // define the dialog content
                    return PopupAddItem(location: widget.location);
                  }
                } else {
                  return const Center(child: Text("UnexpectedError"));
                }
              }),
        ],
      ),
    );
  }
}

Future<void> updateTargetQuantity(
    String value, Map<String, dynamic> item) async {
  DatabaseInterface dbInterface = DatabaseInterface();

  if (double.parse(value) - item['stockQuantity'] <= 0) {
    await dbInterface.updateItemByName(item["name"], {'buyQuantity': 0});
  } else {
    await dbInterface.updateItemByName(item["name"],
        {'buyQuantity': double.parse(value) - item['stockQuantity']});
  }

  await dbInterface
      .updateItemByName(item["name"], {'targetQuantity': double.parse(value)});
}

Future<void> updateStockQuantity(
    String value, Map<String, dynamic> item) async {
  DatabaseInterface dbInterface = DatabaseInterface();

  if (item['targetQuantity'] - double.parse(value) <= 0) {
    await dbInterface.updateItemByName(item["name"], {'buyQuantity': 0});
  } else {
    await dbInterface.updateItemByName(item["name"],
        {'buyQuantity': item['targetQuantity'] - double.parse(value)});
  }
  await dbInterface
      .updateItemByName(item["name"], {'stockQuantity': double.parse(value)});
}

// Baut Popup
class PopupAddLocation extends StatefulWidget {
  const PopupAddLocation({Key? key}) : super(key: key);
  @override
  _PopupAddLocationState createState() => _PopupAddLocationState();
}

class _PopupAddLocationState extends State<PopupAddLocation> {
  final List<bool> _selected = List.generate(16, (index) => false);
  TextEditingController newLocationController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.7,
        child: Container(
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: TenkiColor3(),
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(color: Colors.black, width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10.0,
                spreadRadius: 5.0,
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const Center(
                  child: Text(
                "Neuer Lagerort...",
                style: TextStyle(
                  fontSize: 20,
                ),
              )),
              const SizedBox(height: 15.0),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                padding: const EdgeInsets.only(
                  top: 9,
                  bottom: 9,
                ),
                child: TextField(
                  controller: newLocationController,
                  textAlign: TextAlign.center,
                  cursorColor: Colors.grey,
                  decoration: const InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
              const SizedBox(height: 25.0),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.2,
                height: MediaQuery.of(context).size.width * 0.2 * 4,
                child: Container(
                  color: TenkiColor1(),
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                    ),
                    itemCount: 16,
                    itemBuilder: (BuildContext context, int index) {
                      Widget iconData =
                          locationIcons[index]; // get the icon data
                      Color borderColor =
                          _selected[index] ? Colors.red : Colors.transparent;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selected.fillRange(0, 16,
                                false); // clear previously selected circle
                            _selected[index] =
                                true; // mark current circle as selected
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: borderColor,
                                width: 2,
                              ),
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                            child: iconData,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () {
                          // Close button action
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TenkiMainPage()),
                          );
                        },
                        child: Container(
                          width: 40.0,
                          height: 40.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.black, width: 1),
                            color: TenkiColor4(),
                          ),
                          child: const Icon(Icons.close),
                        ),
                      ),
                      const SizedBox(width: 20.0),
                      InkWell(
                        onTap: () async {
                          // Confirm button action

                          // TODO: Eingabprüfung

                          DatabaseInterface dbInterface = DatabaseInterface();
                          // Add example data map for current user
                          await dbInterface.addLocation(
                              newLocationController.text,
                              _selected
                                  .indexWhere((element) => element == true));

                          //Close popup
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TenkiMainPage()),
                          );
                        },
                        child: Container(
                          width: 40.0,
                          height: 40.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.black, width: 1),
                            color: TenkiColor1(),
                          ),
                          child: const Icon(Icons.check),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Baut
class PopupAddItem extends StatefulWidget {
  //const PopupAddItem({Key? key}) : super(key: key);

  String location = '';
  PopupAddItem({this.location = ''});

  @override
  _PopupAddItemState createState() => _PopupAddItemState();
}

class _PopupAddItemState extends State<PopupAddItem> {
  // define text editing controllers for the input fields
  TextEditingController nameController = TextEditingController();
  TextEditingController targetQuantityController = TextEditingController();
  TextEditingController stockQuantityController = TextEditingController();

  String? selectedUnit='-Bitte wählen-';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {




    return AlertDialog(
      title: Center(child: const Text('Artikel hinzufügen')),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextField(
            controller: nameController,
            cursorColor: TenkiColor1(),
            decoration: InputDecoration(
              labelText: 'Name',
              labelStyle: TextStyle(color: Colors.grey[700], fontSize: 16),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: TenkiColor1(), width: 2),
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
            ),
          ),
          const SizedBox(height: 25),
          Row(
            children: const [
              Text('Mengen: '),
            ],
          ),
          const SizedBox(height: 5),
          TextField(
            controller: stockQuantityController,
            keyboardType: TextInputType.number,
            cursorColor: TenkiColor1(),
            decoration: InputDecoration(
              labelText: 'Aktuelle Menge',
              labelStyle: TextStyle(color: Colors.grey[700], fontSize: 16),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: TenkiColor1(), width: 2),
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
            ),
          ),
          const SizedBox(height: 5),
          TextField(
            controller: targetQuantityController,
            keyboardType: TextInputType.number,
            cursorColor: TenkiColor1(),
            decoration: InputDecoration(
              labelText: 'Soll-Menge',
              labelStyle: TextStyle(color: Colors.grey[700], fontSize: 16),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: TenkiColor1(), width: 2),
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
            ),
          ),
          const SizedBox(height: 25),
          DropdownButtonFormField<String>(
            value: selectedUnit,
            items: unitList.map((option) {
              return DropdownMenuItem(
                child: Text(option),
                value: option,
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                selectedUnit = value;
              });
            },
            decoration: InputDecoration(
              labelText: 'Einheit',
              labelStyle: TextStyle(color: Colors.grey[700]),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
                borderSide: BorderSide(color: TenkiColor1()),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: TenkiColor1(), width: 2),
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),

            ),
            dropdownColor: TenkiColor2(),
          ),
          const SizedBox(height: 15),
          HorizontalSelection(
            items: [
              Icons.home,
              Icons.search,
              Icons.favorite,
              Icons.shopping_cart,
              Icons.settings,
            ],
            onSelect: (int index) {
              print('Selected index: $index');
            },
          ),



        ],
      ),
      actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.barcode_reader),
          onPressed: () {
            // Todo: Replace
          },
        ),
        IconButton(
          icon: const Icon(Icons.cancel_outlined),
          onPressed: () {
            // Close Alert with No Operation
            Navigator.of(context).pop();
          },
        ),
        IconButton(
          icon: const Icon(Icons.check_circle, color: Colors.teal),
          onPressed: () async {
            // Todo: Replace

            // Close AlertDialog
            Navigator.of(context).pop();
          },
        ),
      ],
      backgroundColor: TenkiColor3(),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: const BorderSide(color: Colors.black, width: 1),
      ),
    );








    /*AlertDialog(
      title: const Text('Neues Lebensmittel'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextField(
            controller: nameController,
            decoration: const InputDecoration(
              labelText: 'Name',
            ),
          ),
          TextField(
            controller: unitController,
            decoration: const InputDecoration(
              labelText: 'Unit',
            ),
          ),
          TextField(
            controller: targetQuantityController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Target Quantity',
            ),
          ),
        ],
      ),
      actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.barcode_reader),
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return barcode_scan_page.BarcodeScanner();
                });
          },
        ),
        IconButton(
          icon: const Icon(Icons.cancel_outlined),
          onPressed: () {
            // CLose Alert with No Operation
            Navigator.of(context).pop();
          },
        ),
        IconButton(
          icon: const Icon(Icons.check_circle, color: Colors.teal),
          onPressed: () async {
            // retrieve the values entered by the user
            String name = nameController.text;
            String unit = selectedUnit;
            double targetQuantity =
                double.tryParse(targetQuantityController.text) ?? 0;
            double stockQuantity = 0;
            double buyQuantity = targetQuantity - stockQuantity;

            // Create a new map object with the new entry details
            Map<String, dynamic> newEntry = {
              "name": name,
              "location": widget.location,
              "unit": unit,
              "targetQuantity": targetQuantity,
              "stockQuantity": stockQuantity,
              "buyQuantity": buyQuantity,
              "shoppingCategory": "Sonstige",
            };

            // call function to add the new item
            DatabaseInterface dbInterface = DatabaseInterface();
            await dbInterface.addItemToStorageMap(newEntry);

            // Close AlertDialog
            Navigator.of(context).pop();
          },
        ),
      ],
    );*/







  }
}







class HorizontalSelection extends StatefulWidget {
  final List<IconData> items; // updated parameter type
  final Function(int) onSelect;

  HorizontalSelection({required this.items, required this.onSelect});

  @override
  _HorizontalSelectionState createState() => _HorizontalSelectionState();
}

class _HorizontalSelectionState extends State<HorizontalSelection> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width:200,
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.items.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedIndex = index;
                widget.onSelect(selectedIndex);
              });
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: selectedIndex == index ? Colors.blue : Colors.transparent,
                    width: 2,
                  ),
                ),
              ),
              child: Icon(
                widget.items[index], // updated to use Icon widget
                color: selectedIndex == index ? Colors.blue : Colors.grey,
                size: 24,
              ),
            ),
          );
        },
      ),
    );
  }
}

