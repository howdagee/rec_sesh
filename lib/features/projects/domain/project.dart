class Project {
  const Project({
    required this.name,
    required this.path,
    required this.dateModified,
    this.trackCount = 0,
  });

  final String name;
  final String path;
  final DateTime dateModified;
  final int trackCount;

  @override
  String toString() => 'Project($name, $dateModified, $trackCount)';
}
