formatTime(int timeSeconds) {
  // Calculate hours, minutes, and seconds
  int hours = (timeSeconds ~/ 3600);
  int minutes = (timeSeconds % 3600) ~/ 60;
  int seconds = timeSeconds % 60;

  // Convert to strings and add leading zeros if necessary
  String hoursStr = hours.toString().padLeft(2, '0');
  String minutesStr = minutes.toString().padLeft(2, '0');
  String secondsStr = seconds.toString().padLeft(2, '0');

  // Format the time in HH:MM:SS format
  return '$hoursStr:$minutesStr:$secondsStr';
}
