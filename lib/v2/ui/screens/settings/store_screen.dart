import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:p2u_wallet/v2/ui/screens/settings/store_screen_provider.dart';
import 'package:provider/provider.dart';

// import '../../../core/enums/view_state.dart';
import '../../../core/enums/view_state.dart';

class StoreScreen extends StatefulWidget {
  const StoreScreen({Key? key}) : super(key: key);

  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => StoreScreenProvider(),
      child: Consumer<StoreScreenProvider>(
        builder: (context, model, child) {
          return Scaffold(
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              iconTheme: IconThemeData(color: Colors.black, size: 36),
            ),
            body: (model.state == ViewState.busy)
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : GoogleMap(
                    // mapType: MapType.terrain,
                    zoomControlsEnabled: false,
                    initialCameraPosition: model.kGooglePlex!,
                    myLocationEnabled: true,
                    myLocationButtonEnabled: false,
                    markers: model.stores.toSet(),
                    onMapCreated: (GoogleMapController controller) {
                      model.controller.complete(controller);
                    },
                    // zoomControlsEnabled: true,
                  ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.white,
              onPressed: () async {
                var controller = await model.controller.future;
                controller.animateCamera(
                  CameraUpdate.newCameraPosition(
                    CameraPosition(
                      bearing: 0,
                      target: model.kGooglePlex!.target,
                      zoom: 16,
                    ),
                  ),
                );
              },
              child: Icon(Icons.my_location, color: Colors.black),
            ),
          );
        },
      ),
    );
  }
}
