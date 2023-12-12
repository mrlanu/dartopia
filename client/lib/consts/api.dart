class Api{
  Api._();
  static const baseURL = '10.0.2.2:8080';
  static String fetchSettlementsListByUserId(String userId){
    return '/users/$userId/settlements';
  }

  static String fetchSettlementById(String id){
    return '/settlement/$id';
  }

  static String upgradeBuilding(String settlementId){
    return '/settlement/$settlementId/construction';
  }

  static String sendTroops(String settlementId){
    return 'settlement/$settlementId/send_units';
  }

  static String fetchMovements(String settlementId){
    return 'settlement/$settlementId/movements';
  }
}

