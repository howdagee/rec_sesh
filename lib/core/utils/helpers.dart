Duration parseDuration(String s) {
  List<String> parts = s.split(':');
  if (parts.length == 2) {
    int minutes = int.tryParse(parts[0]) ?? 0;
    int seconds = int.tryParse(parts[1]) ?? 0;
    return Duration(minutes: minutes, seconds: seconds);
  }
  if (parts.length == 1) {
    int seconds = int.tryParse(parts[0]) ?? 0;
    return Duration(seconds: seconds);
  }
  return Duration.zero;
}

String formatDuration(Duration d) {
  String twoDigits(int n) => n.toString().padLeft(2, "0");
  String twoDigitMinutes = twoDigits(d.inMinutes.remainder(60));
  String twoDigitSeconds = twoDigits(d.inSeconds.remainder(60));
  return "$twoDigitMinutes:$twoDigitSeconds";
}
