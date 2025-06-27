class AudioTrack {
  const AudioTrack({
    required this.id,
    required this.name,
    required this.duration,
    required this.dateCreated,
  });

  final String id;
  final String name;
  final Duration duration;
  final DateTime dateCreated;

  AudioTrack copyWith({
    String? name,
    Duration? duration,
    DateTime? dateCreated,
  }) {
    return AudioTrack(
      id: id,
      name: name ?? this.name,
      duration: duration ?? this.duration,
      dateCreated: dateCreated ?? this.dateCreated,
    );
  }
}
