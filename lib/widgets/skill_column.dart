import 'package:flutter/material.dart';
import 'package:repx/models/skill.dart'; // Package import
import 'package:repx/widgets/skill_box.dart'; // Package import

class SkillColumn extends StatelessWidget {
  final String title;
  final List<Skill> skills;
  final double skillBoxSize;
  final Function(Skill) onSkillTap; // Callback when a skill is tapped

  const SkillColumn({
    super.key,
    required this.title,
    required this.skills,
    this.skillBoxSize = 80.0,
    required this.onSkillTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min, // So column doesn't expand infinitely
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontSize: 18, // Adjusted for column title
                ),
            textAlign: TextAlign.center,
          ),
        ),
        // If you want to draw connecting lines, this is where you might use a Stack
        // For now, simple column of SkillBoxes
        ListView.builder(
          shrinkWrap: true, // Important for ListView inside Column
          physics: const NeverScrollableScrollPhysics(), // Column will handle scrolling
          itemCount: skills.length,
          itemBuilder: (context, index) {
            final skill = skills[index];
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0), // Spacing between boxes
              child: SkillBox(
                skill: skill,
                size: skillBoxSize,
                onTap: () => onSkillTap(skill),
              ),
            );
          },
        ),
      ],
    );
  }
}
