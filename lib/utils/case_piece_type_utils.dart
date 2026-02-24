enum CasePieceType {CASE,PIECE}

class CasePieceTypeUtils{
  static String toStr(CasePieceType type){
    switch (type){
      case CasePieceType.CASE:
       return "Case";
      case CasePieceType.PIECE:
        return "Pcs";
    }
  }

  static int toSize(CasePieceType type, int packSize){
    return type==CasePieceType.CASE?packSize:1;
  }
}