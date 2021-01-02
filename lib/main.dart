import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:control_pad/control_pad.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:firebase_core/firebase_core.dart';

Person me = Person();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Google Maps Demo',
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
                radius: 500,
                fillColor: Color.fromRGBO(89, 182, 91, 0.6),
                strokeColor: Color.fromRGBO(0, 0, 0, 0),
              ));
            } else {
              circles[0] = Circle(
                circleId: CircleId("home"),
                center: LatLng(me.location.latitude, me.location.longitude),
                radius: 500,
                fillColor: Color.fromRGBO(89, 182, 91, 0.6),
                strokeColor: Color.fromRGBO(0, 0, 0, 0),
              );
            }
          }
          getMarkers(snapshot);

          return Stack(
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
            ],
          );
        });
  }

  Future<void> getMarkers(AsyncSnapshot<QuerySnapshot> snapshot) async {
    BitmapDescriptor _icon;
    for (var doc in snapshot.data.docs) {
      if (doc['name'] != me.name) {
        await BitmapDescriptor.fromAssetImage(
                ImageConfiguration(size: Size(96, 96)),
                'assets/${doc['name']}.png')
            .then((onValue) {
          print(onValue);
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

class Person {
  String name;
  LatLng location;
  BitmapDescriptor icon;

  Person({this.name, this.location});
}
