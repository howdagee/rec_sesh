import 'package:rec_sesh/core/utils/helpers.dart';

class AudioFile {
  const AudioFile({
    required this.name,
    required this.dateCreated,
    this.duration,
  });

  final String name;
  final Duration? duration;
  final DateTime dateCreated;

  // String get createdAt => DateTimeFormatter.getShortMonthDay(dateCreated);

  String get formattedDuration =>
      duration != null ? formatDuration(duration!) : '';

  AudioFile copyWith({
    String? name,
    Duration? duration,
    DateTime? dateCreated,
  }) {
    return AudioFile(
      name: name ?? this.name,
      duration: duration ?? this.duration,
      dateCreated: dateCreated ?? this.dateCreated,
    );
  }
}
