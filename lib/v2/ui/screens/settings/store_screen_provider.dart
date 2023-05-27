import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:p2u_wallet/v2/core/models/base_view_model.dart';
import 'package:p2u_wallet/v2/core/services/API/user_api_service.dart';
import '../../../core/enums/view_state.dart';

class StoreScreenProvider extends BaseViewModal {
  List<Marker> stores = [];
  UserAPIServices _userAPI = UserAPIServices();
  final Completer<GoogleMapController> controller =
      Completer<GoogleMapController>();

  CameraPosition? kGooglePlex;

  StoreScreenProvider() {
    init();
  }
  init() async {
    setState(ViewState.busy);
    await fetchAffiliateStoreInfo();
    bool permitted = false;
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      var returnData = await Geolocator.requestPermission();
      permitted = returnData != LocationPermission.denied;
    } else {
      permitted = true;
    }
    if (permitted) {
      var position = await Geolocator.getCurrentPosition();
      kGooglePlex = CameraPosition(
        target: LatLng(position.latitude, position.longitude),
        zoom: 16,
      );
    }
    setState(ViewState.idle);
  }

  fetchAffiliateStoreInfo() async {
    try {
      var response = await _userAPI.fetchAffiliateStores();
      print(response);
      // if (response != false) {
      for (var store in response) {
        stores.add(
          Marker(
            markerId: MarkerId(store['name']),
            position: LatLng(double.parse(store['location']['lat'].toString()),
                double.parse(store['location']['lng'].toString())),
            infoWindow: InfoWindow(
              title: store['name'],
              snippet: store['address'],
              onTap: () {},
            ),
          ),
        );
      }
      // }
    } catch (e) {}
  }
}
