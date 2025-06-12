import 'package:flutter/material.dart';
import 'package:repx/models/skill.dart'; // Package import
import 'package:repx/widgets/skill_column.dart'; // Package import

class SkillPathOverviewPage extends StatefulWidget {
  const SkillPathOverviewPage({super.key});

  @override
  State<SkillPathOverviewPage> createState() => _SkillPathOverviewPageState();
}

class _SkillPathOverviewPageState extends State<SkillPathOverviewPage> {
  late Map<String, List<Skill>> _skillPaths;

  @override
  void initState() {
    super.initState();
    _loadMockData();
  }

  void _loadMockData() {
    _skillPaths = {
      "Push Ups": [
        Skill(id: "pu1", name: "Wall Push Up", pathId: "push_ups", level: 1, status: SkillStatus.completed),
        Skill(id: "pu2", name: "Incline Push Up", pathId: "push_ups", level: 2, status: SkillStatus.completed),
        Skill(id: "pu3", name: "Knee Push Up", pathId: "push_ups", level: 3, status: SkillStatus.current),
        Skill(id: "pu4", name: "Full Push Up", pathId: "push_ups", level: 4, status: SkillStatus.locked),
        Skill(id: "pu5", name: "Diamond Push Up", pathId: "push_ups", level: 5, status: SkillStatus.locked),
      ],
      "Pull Ups": [
        Skill(id: "pl1", name: "Passive Hang", pathId: "pull_ups", level: 1, status: SkillStatus.completed),
        Skill(id: "pl2", name: "Active Hang", pathId: "pull_ups", level: 2, status: SkillStatus.current),
        Skill(id: "pl3", name: "Scapular Pulls", pathId: "pull_ups", level: 3, status: SkillStatus.locked),
        Skill(id: "pl4", name: "Assisted Pull Up", pathId: "pull_ups", level: 4, status: SkillStatus.locked),
        Skill(id: "pl5", name: "Full Pull Up", pathId: "pull_ups", level: 5, status: SkillStatus.locked),
      ],
      "Squats": [
        Skill(id: "sq1", name: "Assisted Squat", pathId: "squats", level: 1, status: SkillStatus.completed),
        Skill(id: "sq2", name: "Full Squat", pathId: "squats", level: 2, status: SkillStatus.completed),
        Skill(id: "sq3", name: "Close Squat", pathId: "squats", level: 3, status: SkillStatus.completed),
        Skill(id: "sq4", name: "Bulgarian Split Squat", pathId: "squats", level: 4, status: SkillStatus.current),
        Skill(id: "sq5", name: "Pistol Squat", pathId: "squats", level: 5, status: SkillStatus.locked),
      ],
    };
  }

  void _handleSkillTap(Skill skill) {
    if (!mounted) return;
    if (skill.status == SkillStatus.locked) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("${skill.name} is locked! Keep training!"),
          backgroundColor: Colors.grey.shade800,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          margin: const EdgeInsets.all(10),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Scaffold(
            appBar: AppBar(title: Text(skill.name)),
            body: Center(child: Text("Details for ${skill.name}\nStatus: ${skill.status.name}")),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    // Ensure at least 3 columns are somewhat visible, adjust divisor as needed
    // Add some padding factor, so N columns + (N+1) padding sections
    // If _skillPaths.length is 3, we might want screenWidth / (3 * 1.5) or similar.
    // Or, more simply, divide by a number slightly larger than the number of paths.
    double skillBoxTargetWidth = screenWidth / (_skillPaths.isEmpty ? 1 : _skillPaths.length + 0.5);
    double skillBoxSize = skillBoxTargetWidth.clamp(80.0, 120.0); // Clamp size

    return Scaffold(
      appBar: AppBar(
        title: const Text('Skill Paths'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: _skillPaths.length < 3 ? MainAxisAlignment.start : MainAxisAlignment.spaceAround,
          children: _skillPaths.entries.map((entry) {
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6.0), // Reduced horizontal padding
                child: SkillColumn(
                  title: entry.key,
                  skills: entry.value,
                  skillBoxSize: skillBoxSize,
                  onSkillTap: _handleSkillTap,
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
