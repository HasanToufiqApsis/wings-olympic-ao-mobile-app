
class NewRegisteredOutletModel{
  String? outletName;
  String? outletNameBn;
  String? ownerName;
  String? contactNumber;
  String? nidNumber;
  String? address;
  String? businessType;
  String? channelCategory;
  String? coolerStatus;
  String? cooler;

  NewRegisteredOutletModel({required this.outletName, required this.outletNameBn, required this.ownerName, required this.contactNumber, required this.address, required this.businessType, required this.channelCategory, required this.coolerStatus, required this.nidNumber, required this.cooler});

  factory NewRegisteredOutletModel.from(NewRegisteredOutletModel oldModel){
    return NewRegisteredOutletModel(
      outletName: oldModel.outletName,
      outletNameBn: oldModel.outletNameBn,
      ownerName: oldModel.ownerName,
      contactNumber: oldModel.contactNumber,
      nidNumber: oldModel.nidNumber,
      address: oldModel.address,
      businessType: oldModel.businessType,
      channelCategory: oldModel.channelCategory,
      coolerStatus: oldModel.coolerStatus,
      cooler: oldModel.cooler
    );
  }
}