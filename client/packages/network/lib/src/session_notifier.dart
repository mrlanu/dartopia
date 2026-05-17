import 'dart:async';

/// Broadcasts when the API rejects the session (e.g. expired JWT).
class SessionNotifier {
  SessionNotifier._();

  static final SessionNotifier instance = SessionNotifier._();

  final _controller = StreamController<void>.broadcast();
  bool _notified = false;

  Stream<void> get onSessionExpired => _controller.stream;

  void notifySessionExpired() {
    if (_notified) {
      return;
    }
    _notified = true;
    _controller.add(null);
  }

  /// Call after a successful login so a future expiry can be detected again.
  void reset() {
    _notified = false;
  }
}
