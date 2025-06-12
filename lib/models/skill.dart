enum SkillStatus {
  completed,
  current,
  locked,
}

class Skill {
  final String id;
  final String name;
  final String pathId; // To group skills by path (e.g., "push_ups", "pull_ups")
  final int level; // Level or order within the path
  final SkillStatus status;

  Skill({
    required this.id,
    required this.name,
    required this.pathId,
    required this.level,
    required this.status,
  });
}
