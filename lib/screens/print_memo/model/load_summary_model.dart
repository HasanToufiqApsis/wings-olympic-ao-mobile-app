class LoadSummaryModel {
  int? sbuId;
  int? vehicleId;
  String? name;
  String? date;
  String? totalSku;
  String? totalPrice;
  String? orderDate;
  int? routeCost;
  int? depId;
  String? ffId;
  String? pint;
  String? address;
  String? vehicle;
  String? vehicleCapacity;
  String? dsrName;

  LoadSummaryModel({
    this.sbuId,
    this.vehicleId,
    this.name,
    this.date,
    this.totalSku,
    this.totalPrice,
    this.orderDate,
    this.routeCost,
    this.depId,
    this.ffId,
    this.pint,
    this.address,
    this.vehicle,
    this.vehicleCapacity,
    this.dsrName,
  });

  LoadSummaryModel.fromJson(Map<String, dynamic> json) {
    sbuId = json['sbu_id'];
    vehicleId = json['vehicle_id'];
    name = json['name'];
    date = json['date'];
    totalSku = json['total_sku'];
    totalPrice = json['total_price'];
    orderDate = json['order_date'];
    routeCost = json['route_cost'];
    depId = json['dep_id'];
    ffId = json['ff_id'].toString();
    pint = json['point_name'].toString();
    address = json['address'].toString();
    vehicle = json['vehicle'].toString();
    vehicleCapacity = json['capacity'].toString();
    dsrName = json['dsr_name'].toString();
  }
}
