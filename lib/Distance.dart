import 'package:geocoder/geocoder.dart';
import 'package:vector_math/vector_math.dart' show radians;
import 'dart:math' show sin, cos, sqrt, atan2;


class Distance {
  static final double earthRadius = 6371000;

  static Future<Coordinates> _getCoordinates(String query) async {
    var addresses = await Geocoder.local.findAddressesFromQuery(query);
    var first = addresses.first;
    print(' lat - lon ${first.coordinates}');
    return first.coordinates;
  }

  static Future<double> getDistance(String address1, String address2) async {
    var coord1 = await _getCoordinates(address1);
    var coord2 = await _getCoordinates(address2);
    var dLat = radians(coord1.latitude - coord2.latitude);
    var dLng = radians(coord1.latitude - coord2.latitude);
    var a = sin(dLat/2) * sin(dLat/2) + cos(radians(coord1.latitude)) * cos(radians(coord2.latitude)) * sin(dLng/2) * sin(dLng/2);
    var c = 2 *atan2(sqrt(a), sqrt(1-a));
    var d = earthRadius * c;
    double mileFromMeter = d / 1609.344;
    print(mileFromMeter);
    return mileFromMeter;
  }
}