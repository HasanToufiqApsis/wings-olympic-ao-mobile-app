enum DigitalLearningType { video, pdf, image }

class DigitalLearningUtils {
  static DigitalLearningType toType(String str) {
    switch (str) {
      case "mp4":
        return DigitalLearningType.video;
      case "png":
      case "jpg":
      case "jpeg":
        return DigitalLearningType.image;
      case "pdf":
        return DigitalLearningType.pdf;
      default:
        return DigitalLearningType.video;
    }
  }

  static String toStr(DigitalLearningType type){
    switch (type){
      case DigitalLearningType.video:
        return "video";
      case DigitalLearningType.pdf:
        return "pdf";
      case DigitalLearningType.image:
        return "pdf";
      default:
        return "video";
    }
  }
}
