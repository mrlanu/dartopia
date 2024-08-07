class Api {
  Api._();

  //dart server
  //static const baseURL = 'http://10.0.2.2:8080';

  //java server
  static const baseURL = 'http://10.0.2.2:8282';

  //web
  //static const baseURL = 'http://localhost:8282';

  static String signup() {
    return '/auth/signup';
  }

  static String signin() {
    return '/auth/login';
  }

  static String fetchPartOfWorld() {
    return '/world';
  }

  static String fetchTileDetails() {
    return '/world/tiles';
  }

  static String fetchSettlementsInfoList() {
    return '/settlements';
  }

  static String fetchSettlementById(String id) {
    return '/settlements/$id';
  }

  static String upgradeBuilding(String settlementId) {
    return '/settlements/$settlementId/constructions';
  }

  static String reorderBuildings(String settlementId) {
    return '/settlements/$settlementId/reorder_buildings';
  }

  static String orderTroops(String settlementId) {
    return '/settlements/$settlementId/order_troops';
  }

  static String sendTroopsContract(String settlementId) {
    return '/settlements/$settlementId/troops_send_contract';
  }

  static String sendTroops(String settlementId) {
    return '/settlements/$settlementId/send_units';
  }

  static String fetchAllReportsBrief() {
    return '/reports';
  }

  static String fetchReportById(String reportId) {
    return '/reports/$reportId';
  }

  static String deleteReportById(String reportId) {
    return '/reports/$reportId';
  }

  static String fetchStatistics(String? page, String sort) {
    final pg = page == null ? '' : '&page=$page';
    return '/statistics?sort=$sort$pg';
  }

  static String sendMessage(){
    return '/messages';
  }

  static String fetchMessages(String? page, String? pageSize,
      {bool sent = false}) {
    return '/messages?page=${page ?? '1'}&pageSize=${pageSize ?? '3'}&sent=$sent';
  }

  static String countNewMessages() {
    return '/messages/count-new';
  }

  static String deleteMessages() {
    return '/messages/delete';
  }

  static String fetchMessageById({String?messageId}) {
    return '/messages/$messageId';
  }

}
