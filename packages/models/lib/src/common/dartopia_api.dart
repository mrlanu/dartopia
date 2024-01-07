class Api {
  Api._();

  static const baseURL = '10.0.2.2:8080';

  static Map<String, String> headerAuthorization({required String token}) =>
      {'Authorization': 'Bearer $token'};

  static String signup() {
    return '/signup';
  }

  static String signin() {
    return '/signin';
  }

  static String fetchPartOfWorld() {
    return '/world';
  }

  static String fetchTileDetails() {
    return '/world/tiles';
  }

  static String fetchSettlementsListByUserId(String userId) {
    return '/settlements';
  }

  static String fetchSettlementById(String id) {
    return '/settlements/$id';
  }

  static String upgradeBuilding(String settlementId) {
    return '/settlements/$settlementId/constructions';
  }

  static String sendTroopsContract(String settlementId) {
    return 'settlements/$settlementId/troops_send_contract';
  }

  static String sendTroops(String settlementId) {
    return 'settlements/$settlementId/send_units';
  }

  static String fetchMovements(String settlementId) {
    return 'settlements/$settlementId/movements';
  }

  static String fetchAllReportsBrief() {
    return 'reports';
  }

  static String fetchReportById(String reportId) {
    return 'reports/$reportId';
  }

  static String deleteReportById(String reportId) {
    return 'reports/$reportId';
  }
}
