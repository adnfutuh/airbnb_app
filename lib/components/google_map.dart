import 'package:another_carousel_pro/another_carousel_pro.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'my_icon_button.dart';

class GoogleMapFlutter extends StatefulWidget {
  const GoogleMapFlutter({super.key});

  @override
  State<GoogleMapFlutter> createState() => _GoogleMapFlutterState();
}

class _GoogleMapFlutterState extends State<GoogleMapFlutter> {
  LatLng myLocation = const LatLng(-6.2349, 106.9896);
  BitmapDescriptor customIcon = BitmapDescriptor.defaultMarker;
  late GoogleMapController googleMapController;
  final CustomInfoWindowController _customInfoWindowController =
      CustomInfoWindowController();
  final CollectionReference placeCollection =
      FirebaseFirestore.instance.collection("myPlace");

  List<Marker> markers = [];
  @override
  void initState() {
    super.initState();
    _loadMarkers();
  }

  Future<void> _loadMarkers() async {
    customIcon = await BitmapDescriptor.asset(
      const ImageConfiguration(),
      "assets/images/marker.png",
      height: 40,
      width: 30,
    );
    if (!mounted) return;
    Size size = MediaQuery.of(context).size;

    placeCollection.snapshots().listen((QuerySnapshot streamSnapshot) {
      if (streamSnapshot.docs.isNotEmpty) {
        final List allMarkers = streamSnapshot.docs;
        List<Marker> myMarker = [];
        for (final marker in allMarkers) {
          final dat = marker.data();
          final data = (dat) as Map;
          myMarker.add(
            Marker(
                markerId: MarkerId(
                  data['address'],
                ),
                position: LatLng(
                  data['latitude'],
                  data['longitude'],
                ),
                onTap: () {
                  _customInfoWindowController.addInfoWindow!(
                    Container(
                      height: size.height * 0.26,
                      width: size.width * 0.7,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              SizedBox(
                                height: size.height * 0.160,
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(25),
                                    topRight: Radius.circular(25),
                                  ),
                                  child: AnotherCarousel(
                                    images: data['imageUrls']
                                        .map((url) => NetworkImage(url))
                                        .toList(),
                                    dotSize: 5,
                                    indicatorBgPadding: 5,
                                    dotBgColor: Colors.transparent,
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 10,
                                left: 15,
                                right: 15,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 5,
                                        horizontal: 12,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      child: const Text(
                                        "Guest Favorite",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const Spacer(),
                                    const MyIconButton(
                                      icon: Icons.favorite_border,
                                      radius: 15,
                                    ),
                                    const SizedBox(width: 13),
                                    InkWell(
                                      onTap: () {
                                        _customInfoWindowController
                                            .hideInfoWindow!();
                                      },
                                      child: const MyIconButton(
                                        icon: Icons.close,
                                        radius: 15,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 8,
                              left: 10,
                              right: 10,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      data["address"],
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const Spacer(),
                                    const Icon(Icons.star),
                                    const SizedBox(width: 5),
                                    Text(data['rating'].toString()),
                                  ],
                                ),
                                Text(
                                  data['date'],
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.black54,
                                  ),
                                ),
                                Text.rich(
                                  TextSpan(
                                    text: '\$${data['price']}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    children: const [
                                      TextSpan(
                                        text: "night",
                                        style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    LatLng(
                      data['latitude'],
                      data['longitude'],
                    ),
                  );
                },
                icon: customIcon),
          );
        }
        setState(() {
          markers = myMarker;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: myLocation,
            ),
            onMapCreated: (GoogleMapController controller) {
              googleMapController = controller;
              _customInfoWindowController.googleMapController = controller;
            },
            onTap: (argument) {
              _customInfoWindowController.hideInfoWindow!();
            },
            onCameraMove: (position) {
              _customInfoWindowController.onCameraMove!();
            },
            markers: markers.toSet(),
          ),
          CustomInfoWindow(
            controller: _customInfoWindowController,
            height: size.height * 0.28,
            width: size.width * 0.79,
            offset: 50,
          ),
        ],
      ),
    );
  }
}
