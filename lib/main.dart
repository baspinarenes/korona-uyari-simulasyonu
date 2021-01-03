import 'dart:math';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:control_pad/control_pad.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:geolocator/geolocator.dart';
import "dart:collection";

Person me = Person();

Map<String, int> inSocialDistance = {
  "positive": 0,
  "negative": 0,
};

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // setupFirebase();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bana Yaklaşma',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Anasayfa(),
      ),
    );
  }
}

class Anasayfa extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width * 0.8,
          height: MediaQuery.of(context).size.height * 0.8,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(
                image: AssetImage('assets/corona-virus.png'),
                height: 200,
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'KoronApp',
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.black,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              GridView.count(
                padding: EdgeInsets.all(20),
                shrinkWrap: true,
                crossAxisCount: 3,
                children: [
                  Card(
                    color: Colors.blueAccent,
                    child: IconButton(
                      icon: Image.asset('assets/person_1.png'),
                      iconSize: 50,
                      onPressed: () {
                        me.name = "person_1";
                        me.location =
                            LatLng(40.814710708066436, 29.918302905265076);
                        BitmapDescriptor.fromAssetImage(
                                ImageConfiguration(size: Size(96, 96)),
                                'assets/person_1.png')
                            .then((onValue) {
                          me.icon = onValue;
                        });

                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => FireMap()),
                        );
                      },
                    ),
                  ),
                  Card(
                    color: Colors.blueAccent,
                    child: IconButton(
                      icon: Image.asset('assets/person_2.png'),
                      iconSize: 50,
                      onPressed: () {
                        me.name = "person_2";
                        me.location =
                            LatLng(40.81712592009916, 29.924846930323028);
                        BitmapDescriptor.fromAssetImage(
                                ImageConfiguration(size: Size(96, 96)),
                                'assets/person_2.png')
                            .then((onValue) {
                          me.icon = onValue;
                        });

                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => FireMap()),
                        );
                      },
                    ),
                  ),
                  Card(
                    color: Colors.blueAccent,
                    child: IconButton(
                      icon: Image.asset('assets/person_3.png'),
                      iconSize: 50,
                      onPressed: () {
                        me.name = "person_3";
                        me.location =
                            LatLng(40.82024376550104, 29.922486586479568);
                        BitmapDescriptor.fromAssetImage(
                                ImageConfiguration(size: Size(96, 96)),
                                'assets/person_3.png')
                            .then((onValue) {
                          me.icon = onValue;
                        });

                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => FireMap()),
                        );
                      },
                    ),
                  ),
                  Card(
                    color: Colors.blueAccent,
                    child: IconButton(
                      icon: Image.asset('assets/person_4.png'),
                      iconSize: 50,
                      onPressed: () {
                        me.name = "person_4";
                        me.location =
                            LatLng(40.82490402157399, 29.918924613060373);
                        BitmapDescriptor.fromAssetImage(
                                ImageConfiguration(size: Size(96, 96)),
                                'assets/person_4.png')
                            .then((onValue) {
                          me.icon = onValue;
                        });

                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => FireMap()),
                        );
                      },
                    ),
                  ),
                  Card(
                    color: Colors.blueAccent,
                    child: IconButton(
                      icon: Image.asset('assets/person_5.png'),
                      iconSize: 50,
                      onPressed: () {
                        me.name = "person_5";
                        me.location =
                            LatLng(40.822062440975444, 29.929825110012445);
                        BitmapDescriptor.fromAssetImage(
                                ImageConfiguration(size: Size(96, 96)),
                                'assets/person_5.png')
                            .then((onValue) {
                          me.icon = onValue;
                        });

                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => FireMap()),
                        );
                      },
                    ),
                  ),
                  Card(
                    color: Colors.blueAccent,
                    child: IconButton(
                      icon: Image.asset('assets/person_6.png'),
                      iconSize: 50,
                      onPressed: () {
                        me.name = "person_6";
                        me.location =
                            LatLng(40.821526586419054, 29.92362384304561);
                        BitmapDescriptor.fromAssetImage(
                                ImageConfiguration(size: Size(96, 96)),
                                'assets/person_6.png')
                            .then((onValue) {
                          me.icon = onValue;
                        });

                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => FireMap()),
                        );
                      },
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class FireMap extends StatefulWidget {
  State createState() => FireMapState();
}

var socialDistance = 350.0;

class FireMapState extends State<FireMap> {
  GoogleMapController mapController;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  List<Circle> circles = [];

  build(context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('people').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (circles.isEmpty) {
              circles.add(Circle(
                circleId: CircleId("home"),
                center: LatLng(me.location.latitude, me.location.longitude),
                radius: socialDistance,
                fillColor: Color.fromRGBO(89, 182, 91, 0.6),
                strokeColor: Color.fromRGBO(0, 0, 0, 0),
              ));
            } else {
              circles[0] = Circle(
                circleId: CircleId("home"),
                center: LatLng(me.location.latitude, me.location.longitude),
                radius: socialDistance,
                fillColor: Color.fromRGBO(89, 182, 91, 0.6),
                strokeColor: Color.fromRGBO(0, 0, 0, 0),
              );
            }
          }
          getMarkers(snapshot);
          calculatePeopleDistance(snapshot);

          return Material(
            type: MaterialType.transparency,
            child: Stack(
              children: [
                GoogleMap(
                  markers: Set<Marker>.of(markers.values),
                  initialCameraPosition: CameraPosition(
                    target: me.location,
                    zoom: 15,
                  ),
                  onMapCreated: _onMapCreated,
                  circles: circles.toSet(),
                ),
                Positioned(
                  bottom: 25,
                  left: 25,
                  child: JoystickView(
                    size: 150,
                    showArrows: false,
                    opacity: 0.8,
                    interval: Duration(seconds: 1),
                    innerCircleColor: Colors.white,
                    backgroundColor: Colors.white38,
                    onDirectionChanged: (double angle, double distance) {
                      var radian = angle * pi / 180;
                      var delta_latitude = distance * cos(radian) / 10000;
                      var delta_longitude = distance * sin(radian) / 10000;

                      changeMeLocation(delta_latitude, delta_longitude);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color.fromRGBO(2500, 0, 0, 0.6),
                      ),
                      width: MediaQuery.of(context).size.width * 0.85,
                      height: 70,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 5, top: 10, right: 5, bottom: 10),
                          child: FittedBox(
                            child: Column(
                              children: [
                                Text(
                                  'Yakınlarınızda bulunan ve korona\ntesti pozitif '
                                  'çıkan insanların oranı:',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  '${me.percentOfCorona.toStringAsFixed(2)}%.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  Future<void> calculatePeopleDistance(
      AsyncSnapshot<QuerySnapshot> snapshot) async {
    inSocialDistance["positive"] = 0;
    inSocialDistance["negative"] = 0;

    for (var doc in snapshot.data.docs) {
      if (doc['name'] != me.name) {
        var distance = Geolocator.distanceBetween(
            doc['location'].latitude,
            doc['location'].longitude,
            me.location.latitude,
            me.location.longitude);

        if (distance < socialDistance) {
          if (doc['corona_test'] == 'positive') {
            inSocialDistance['positive'] += 1;
          } else {
            inSocialDistance['negative'] += 1;
          }
        }
      }
    }

    me.percentOfCorona = inSocialDistance["positive"] /
        (inSocialDistance["negative"] + inSocialDistance["positive"]) *
        100;
    if (me.percentOfCorona.isNaN) {
      me.percentOfCorona = 0;
    }

    print('Etrafımızdaki insanların sayısı: ${inSocialDistance}');
  }

  Future<void> getMarkers(AsyncSnapshot<QuerySnapshot> snapshot) async {
    BitmapDescriptor _icon;
    for (var doc in snapshot.data.docs) {
      if (doc['name'] != me.name) {
        await BitmapDescriptor.fromAssetImage(
                ImageConfiguration(size: Size(96, 96)),
                'assets/${doc['name']}.png')
            .then((onValue) {
          _icon = onValue;
        });
        LatLng loc =
            LatLng(doc['location'].latitude, doc['location'].longitude);
        _add(doc['name'], loc, _icon);
      }
    }
  }

  void changeMeLocation(delta_latitude, delta_longitude) async {
    setState(() {
      me.location = LatLng(me.location.latitude + delta_latitude,
          me.location.longitude + delta_longitude);
      _add(me.name, me.location, me.icon);
      _firestoreLocationUpdate();
    });
  }

  void _firestoreLocationUpdate() async {
    FirebaseFirestore.instance
        .collection("people")
        .where("name", isEqualTo: me.name)
        .get()
        .then((query) {
      query.docs[0].reference.update(
          {'location': GeoPoint(me.location.latitude, me.location.longitude)});
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
      _add(me.name, me.location, me.icon);
    });
  }

  void _add(String id, LatLng loc, BitmapDescriptor ico) {
    Marker marker = Marker(
      markerId: MarkerId(id),
      position: loc,
      icon: ico,
    );

    markers[MarkerId(id)] = marker;
  }
}

void setupFirebase() async {
  List<GeoPoint> waypoints = [
    GeoPoint(40.814710708066436, 29.918302905265076),
    GeoPoint(40.81712592009916, 29.924846930323028),
    GeoPoint(40.82024376550104, 29.922486586479568),
    GeoPoint(40.82490402157399, 29.918924613060373),
    GeoPoint(40.822062440975444, 29.929825110012445),
    GeoPoint(40.821526586419054, 29.92362384304561),
  ];

  for (var i = 0; i < waypoints.length; i++) {
    await FirebaseFirestore.instance.collection("people").add({
      'name': 'person_${i + 1}',
      'location': waypoints[i],
      'corona_test': 'negative',
    });
  }

  Random r = new Random();

  for (var i = 0; i < 40; i++) {
    double randomLat = 40.81488 + (40.82559 - 40.81488) * r.nextDouble();
    double randomLng = 29.91369 + (29.93088 - 29.91369) * r.nextDouble();

    if (i < 20) {
      await FirebaseFirestore.instance.collection("people").add({
        'name': 'bot_${i + 1}',
        'location': GeoPoint(randomLat, randomLng),
        'corona_test': 'positive',
      });
    } else {
      await FirebaseFirestore.instance.collection("people").add({
        'name': 'bot_${i + 1}',
        'location': GeoPoint(randomLat, randomLng),
        'corona_test': 'negative',
      });
    }
  }
}

class Person {
  String name;
  LatLng location;
  BitmapDescriptor icon;
  double percentOfCorona;

  Person({this.name, this.location});
}
