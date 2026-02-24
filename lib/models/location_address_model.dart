class LocationAddressModel<T> {
  double lat;
  double long;
  T address;

  LocationAddressModel({
    required this.lat,
    required this.long,
    required this.address,
  });
}
