import '../outlet_model.dart';

class AddedPosmModel {
  final int brandId;
  final OutletModel outlet;
  final int quantity;
  final String imageName;
  final String imagePath;
  final int posmTypeId;
  final int posmConfigId;

  AddedPosmModel({
    required this.brandId,
    required this.outlet,
    required this.quantity,
    required this.imageName,
    required this.imagePath,
    required this.posmTypeId,
    required this.posmConfigId,
  });
}
