/// Formats a [Duration] object into a human-readable string representation.
///
/// The format produced is `HH:MM:SS` if the duration includes hours,
/// or `MM:SS` if it only includes minutes and seconds.
String formatDuration(Duration duration) {
  String twoDigits(int n) => n.toString().padLeft(2, '0');
  final minutes = twoDigits(duration.inMinutes.remainder(60));
  final seconds = twoDigits(duration.inSeconds.remainder(60));
  final hours = twoDigits(duration.inHours);
  return "${hours == '00' ? '' : '$hours:'}$minutes:$seconds";
}
