import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:TENKI/main_page.dart';
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
  State<TwoColumnLocationView> createState() => _TwoColumnLocationViewState();
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
              .doc(householdId)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: Text("Lädt..."));
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
  final String location;
  const StorageTabContent({Key key = const Key(''), this.location = ''})
      : super(key: key);

  @override
  StorageTabContentState createState() => StorageTabContentState();
}

class StorageTabContentState extends State<StorageTabContent> {
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
                          border: Border.all(color: Colors.black87, width: 1),
                          color: TenkiColor4(),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 3,
                            ),
                          ],
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back, size: 35),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const TenkiMainPage()),
                            );
                          },
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.45,
                        height: 50,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                            color: Colors.grey,
                            width: 0.5,
                          ),
                          color: TenkiColor2(),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 3,
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(10),
                        child: Text(
                          widget.location,
                          style: const TextStyle(
                            letterSpacing: 2,
                            fontSize: 18.0,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                backgroundColor: TenkiColor3(),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                title: const Text('Wie funktioniert das TENKI Vorratslager?'),
                                content: const Text(
                                    "Zunächst legst du dir deine Lagerorte, wie du sie zu Hause trennst, an. Hierfür kannst du auf der Vorratsseite einen Ort mit einem Icon deiner Wahl hinzufügen.\nAnschließend fügst du die im jeweiligen Lagerort liegenden Items hinzu. Dazu drücke auf das 'Plus' und gib einen Namen, eine Ist- und Sollmenge, sowie deine präferierte Einheit an.\nDie Differenz zwischen Soll und Ist Bestand deines Lagers wird jederzeit automatisch der Einkaufsliste hinzugefügt.\nWenn du Items oder Lagerorte aus deinem Vorrat entfernen möchtest halte einfach das entsprechende Element in der Liste gedrückt!"),
                                actions: [
                                  Center(
                                    child: TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text(
                                        'Verstanden',
                                        style:
                                        TextStyle(color: Colors.black87, letterSpacing: 1.5),
                                      ),
                                      style: TextButton.styleFrom(
                                        backgroundColor: TenkiColor1(),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(7.0),
                                        ),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 1.0, vertical: 1.0),
                                        elevation: 3.0,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: Row(
                          children: [
                            const Icon(
                              Icons.info_outline,
                              color: Colors.black87,
                            ),
                          ],
                        ),
                        style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          side: const BorderSide(width: 1.0, color: Colors.black87),
                          elevation: 3.0,
                          backgroundColor: TenkiColor3(),
                        ),
                      ),
                      Container(
                        width: 50.0,
                        height: 50.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.black87, width: 1),
                          color: TenkiColor4(),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 3,
                            ),
                          ],
                        ),
                        child: Container(
                          alignment: Alignment.center,
                          child: IconButton(
                            icon: const Icon(Icons.add, size: 35),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return PopupAddItem(
                                    location: widget.location,
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      )
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
                  .doc(householdId)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: Text("Lädt..."));
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
                          return GestureDetector(
                            onLongPress: () {
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
                                              color: Colors.white, size: 35),
                                          onPressed: () async {
                                            DatabaseInterface dbInterface =
                                                DatabaseInterface();
                                            await dbInterface
                                                .deleteItemByName(item["name"]);

                                            //close ModalBottomSheet
                                            Navigator.pop(context);
                                          },
                                        ),
                                        Text(
                                          item["name"] + " dauerhaft löschen?",
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 16),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                            child: SingleChildScrollView(
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
                                        SizedBox(
                                          height: 140,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.52,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Container(
                                                height: 45,
                                                width: 150,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5.0),
                                                  color:
                                                      const Color(0xfff5f5f5),
                                                ),
                                                child: FittedBox(
                                                  fit: BoxFit.scaleDown,
                                                  child: Text(
                                                    item["name"],
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                height: 45,
                                                width: 100,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5.0),
                                                  color:
                                                      const Color(0xfff5f5f5),
                                                ),
                                                child: FittedBox(
                                                  fit: BoxFit.scaleDown,
                                                  child: Text(
                                                    item["unit"],
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          height: 140,
                                          color: Colors.transparent,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Container(
                                                height: 70,
                                                padding:
                                                    const EdgeInsets.all(10),
                                                child: Row(
                                                  children: [
                                                    Container(
                                                        width: 65,
                                                        color:
                                                            Colors.transparent,
                                                        child: const Text(
                                                          "Aktuell:",
                                                          textAlign:
                                                              TextAlign.center,
                                                        )),
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.2,
                                                      height: 45,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5.0),
                                                        color: const Color(
                                                            0xfff5f5f5),
                                                      ),
                                                      child: TextFormField(
                                                        initialValue: item[
                                                        'stockQuantity']
                                                            .toString(),
                                                        keyboardType:
                                                        TextInputType
                                                            .number,
                                                        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))],
                                                        onFieldSubmitted: (value) =>
                                                            updateStockQuantity(
                                                                value, item),
                                                        decoration:
                                                        InputDecoration(
                                                          contentPadding:
                                                          const EdgeInsets
                                                              .symmetric(
                                                              horizontal:
                                                              15.0),
                                                          hintText: 'Bestand',
                                                          border:
                                                          InputBorder.none,
                                                        ),
                                                        textAlign:
                                                        TextAlign.center,
                                                        style: TextStyle(),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                height: 70,
                                                padding:
                                                    const EdgeInsets.all(10),
                                                child: Row(
                                                  children: [
                                                    Container(
                                                        width: 65,
                                                        color:
                                                            Colors.transparent,
                                                        child: const Text(
                                                          "Soll: ",
                                                          textAlign:
                                                              TextAlign.center,
                                                        )),
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.2,
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5.0),
                                                      ),
                                                      child: TextFormField(
                                                        initialValue: item[
                                                                'targetQuantity']
                                                            .toString(),
                                                        keyboardType:
                                                            TextInputType
                                                                .number,
                                                        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))],
                                                        onFieldSubmitted: (value) =>
                                                            updateTargetQuantity(
                                                                value, item),
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          fontSize: 14,
                                                        ),
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
                                          height: 140,
                                          width: 140,
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
                                          height: 140,
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
                            ),
                          );
                        },
                      ),
                    );
                  } else {
                    // define the dialog content
                    return const Center(
                        child: Text(
                            "Leerer Lagerort. Bitte Items über '+' hinzufügen."));
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
  PopupAddLocationState createState() => PopupAddLocationState();
}

class PopupAddLocationState extends State<PopupAddLocation> {
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
                "Lagerort hinzufügen",
                style: TextStyle(
                  letterSpacing: 3.5,
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
                                builder: (context) => const TenkiMainPage()),
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

                          // Check if name and icon have been selected
                          if (newLocationController.text.isNotEmpty &&
                              _selected.contains(true)) {
                            // Add location to database
                            DatabaseInterface dbInterface = DatabaseInterface();
                            await dbInterface.addLocation(
                              newLocationController.text,
                              _selected
                                  .indexWhere((element) => element == true),
                            );

                            // Close popup
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => TenkiMainPage()),
                            );
                          } else {
                            // Show error message
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text(
                                    'Bitte gib einen Namen und wähle ein Icon aus!'),
                              ),
                            );
                          }
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

int selectedIconIndex = 0;

// Baut
class PopupAddItem extends StatefulWidget {
  //const PopupAddItem({Key? key}) : super(key: key);

  final String location;
  const PopupAddItem({Key key = const Key(''), this.location = ''})
      : super(key: key);

  @override
  PopupAddItemState createState() => PopupAddItemState();
}

class PopupAddItemState extends State<PopupAddItem> {
  // define text editing controllers for the input fields
  TextEditingController nameController = TextEditingController();
  TextEditingController targetQuantityController = TextEditingController();
  TextEditingController stockQuantityController = TextEditingController();
  String? selectedUnit = '-Bitte wählen-';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Center(
        child: Text(
          'Artikel hinzufügen',
          style: TextStyle(
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextField(
              controller: nameController,
              maxLength: 20,
              cursorColor: TenkiColor1(),
              decoration: InputDecoration(
                labelText: 'Name',
                labelStyle: TextStyle(color: Colors.grey[700], fontSize: 16),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: TenkiColor1(), width: 2),
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
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
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))],
              cursorColor: TenkiColor1(),
              decoration: InputDecoration(
                labelText: 'Aktuelle Menge',
                labelStyle: TextStyle(color: Colors.grey[700], fontSize: 16),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: TenkiColor1(), width: 2),
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
              ),
            ),
            const SizedBox(height: 5),
            TextField(
              controller: targetQuantityController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))],
              cursorColor: TenkiColor1(),
              decoration: InputDecoration(
                labelText: 'Soll - Menge',
                labelStyle: TextStyle(color: Colors.grey[700], fontSize: 16),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: TenkiColor1(), width: 2),
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
              ),
            ),
            const SizedBox(height: 25),
            DropdownButtonFormField<String>(
              value: selectedUnit,
              items: unitList.map((option) {
                return DropdownMenuItem(
                  value: option,
                  child: Text(option),
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
                  borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                  borderSide: BorderSide(color: TenkiColor1()),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: TenkiColor1(), width: 2),
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
              ),
              dropdownColor: TenkiColor2(),
            ),
            const SizedBox(height: 15),
            HorizontalSelection(
              itemIcons: categoryItems,
              onSelect: (int index) {
                setState(() {
                  selectedIconIndex = index;
                });
              },
            ),
          ],
        ),
      ),
      actions: <Widget>[
        IconButton(
          // Barcode Scanner as hiidden feature
          icon: Icon(Icons.barcode_reader, size: 40, color: TenkiColor3()),
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return barcode_scan_page.BarcodeScanner();
                });
          },
        ),
        Container(
          width: 40.0,
          height: 40.0,
          decoration: BoxDecoration(
            color: TenkiColor4(),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.black87, width: 1),
          ),
          child: InkWell(
            onTap: () {
              // Close Alert with No Operation
              Navigator.of(context).pop();
            },
            child: const Icon(Icons.close, size: 38, color: Colors.black87),
          ),
        ),
        const SizedBox(width: 20.0),
        Container(
          width: 40.0,
          height: 40.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.black87, width: 1),
            color: TenkiColor1(),
          ),
          child: InkWell(
            onTap: () async {
              // retrieve the values entered by the user
              String name = nameController.text;
              String? unit = selectedUnit;
              double targetQuantity =
                  double.tryParse(targetQuantityController.text) ?? 0;
              double stockQuantity = double.tryParse(stockQuantityController.text) ?? 0;
              double buyQuantity = targetQuantity - stockQuantity;

              // check if required fields are not empty
              if (name.isNotEmpty && unit != null && targetQuantity > 0) {
                // Create a new map object with the new entry details
                Map<String, dynamic> newEntry = {
                  "name": name,
                  "location": widget.location,
                  "unit": unit,
                  "targetQuantity": targetQuantity,
                  "stockQuantity": stockQuantity,
                  "buyQuantity": buyQuantity,
                  "shoppingCategory": categories[selectedIconIndex],
                };

                // call function to add the new item
                DatabaseInterface dbInterface = DatabaseInterface();
                await dbInterface.addItemToStorageMap(newEntry);

                // Close AlertDialog
                Navigator.of(context).pop();
              } else {
                // show an error message if required fields are empty
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Fehler'),
                    backgroundColor: TenkiColor3(),
                    content: Text(
                        'Bitte gib mindestens einen Namen, eine Soll-Menge und eine Einheit an!'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text(
                          'OK',
                          style: TextStyle(color: TenkiColor1()),
                        ),
                      ),
                    ],
                  ),
                );
              }
            },
            child: Icon(Icons.check, color: Colors.black87, size: 35),
          ),
        ),
      ],
      backgroundColor: TenkiColor3(),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: const BorderSide(color: Colors.black87, width: 1),
      ),
    );
  }
}

// View Selection Category-Item
class HorizontalSelection extends StatefulWidget {
  final List<Widget> itemIcons;
  final Function(int) onSelect;
  final Key? key;

  const HorizontalSelection({
    required this.itemIcons,
    required this.onSelect,
    this.key,
  }) : super(key: key);

  @override
  State<HorizontalSelection> createState() => _HorizontalSelectionState();
}

class _HorizontalSelectionState extends State<HorizontalSelection> {
  final ScrollController _scrollController = ScrollController();
  int _selectedIconIndex = 0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    super.dispose();
  }

  void _onScroll() {
    final index = (_scrollController.offset / 60).round();
    if (index != _selectedIconIndex &&
        index >= 0 &&
        index < widget.itemIcons.length) {
      setState(() {
        _selectedIconIndex = index;
        widget.onSelect(_selectedIconIndex);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 200,
          height: 55,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(25)),
            border: Border.all(color: Colors.grey, width: 1),
            color: Colors.grey[200],
          ),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            controller: _scrollController,
            itemCount: widget.itemIcons.length + 2,
            itemBuilder: (BuildContext context, int index) {
              if (index == 0 || index == widget.itemIcons.length + 1) {
                return const SizedBox(width: 70);
              }
              final itemIndex = index - 1;

              if (categories[itemIndex] != "uncategorised") {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  alignment: Alignment.center,
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _selectedIconIndex == itemIndex
                          ? Colors.white
                          : Colors.grey[350],
                      border: Border.all(
                        color: _selectedIconIndex == itemIndex
                            ? TenkiColor1()
                            : Colors.grey,
                        width: _selectedIconIndex == itemIndex ? 3 : 0.5,
                      ),
                    ),
                    child: widget.itemIcons[itemIndex],
                  ),
                );
              } else {
                return const SizedBox(width: 0.1);
              }
            },
          ),
        ),
        const SizedBox(height: 2),
        Text(categories[_selectedIconIndex]),
      ],
    );
  }
}
