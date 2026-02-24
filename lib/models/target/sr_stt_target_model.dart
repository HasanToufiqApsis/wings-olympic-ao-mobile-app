class SRDetailTargetModel {
  int id;
  String name;
  int target;
  num achievement;
  int imageId;
  String? materialCode;
  SRDetailTargetModel({
    required this.id,
    required this.name,
    required this.target,
    required this. achievement,
    required this.imageId,
    this.materialCode,
});
}