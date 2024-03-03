class Config {
  Config._();
  static const String mongoDBUrl ='mongodb://mrlanu:pass@localhost:27017/'
      'dartopia?authSource=admin&retryWrites=true&w=majority';
  static const String jwtSecret = 'mySecret';
  static const int worldWidth = 50;
  static const int worldHeight = 50;
  static const int oasesAmount = 100;
}
