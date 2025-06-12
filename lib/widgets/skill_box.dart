import 'package:flutter/material.dart';
import 'package:repx/models/skill.dart'; // Package import

class SkillBox extends StatelessWidget {
  final Skill skill;
  final VoidCallback? onTap;
  final double size;

  const SkillBox({
    super.key,
    required this.skill,
    this.onTap,
    this.size = 80.0, // Default size, can be overridden
  });

  Color _getBorderColor(SkillStatus status, BuildContext context) {
    switch (status) {
      case SkillStatus.completed:
        return Colors.green.shade300;
      case SkillStatus.current:
        return Colors.blue.shade300;
      case SkillStatus.locked:
        return Colors.grey.shade600;
      default:
        return Colors.grey; // Should not happen
    }
  }

  IconData _getIcon(SkillStatus status) {
    switch (status) {
      case SkillStatus.completed:
        return Icons.check_circle_outline;
      case SkillStatus.current:
        return Icons.directions_run; // Placeholder for 'Running icon'
      case SkillStatus.locked:
        return Icons.lock_outline;
      default:
        return Icons.help_outline; // Should not happen
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color borderColor = _getBorderColor(skill.status, context);
    final IconData iconData = _getIcon(skill.status);
    final bool isLocked = skill.status == SkillStatus.locked;
    final Color iconColor = isLocked ? Colors.grey.shade700 : Theme.of(context).iconTheme.color ?? Colors.white;


    return Material( // Added Material for InkWell splash
      color: Colors.transparent, // Make Material transparent
      borderRadius: BorderRadius.circular(12.0), // Match the Container's border radius
      child: InkWell(
        onTap: isLocked ? null : onTap, // Disable tap if locked
        borderRadius: BorderRadius.circular(12.0), // Match the Container's border radius for splash shape
        splashColor: borderColor.withOpacity(0.3),
        highlightColor: borderColor.withOpacity(0.15),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            // The color is now handled by the Material parent for the InkWell, or can be explicit if different.
            // For a simple border and icon, the background can be transparent here if Material handles it.
            // Or, keep it for distinct visual layering if Material's color is for splash only.
            // Let's keep the original background color logic for the container itself.
            color: Theme.of(context).scaffoldBackgroundColor.withOpacity(isLocked ? 0.3 : 0.7), // Slightly more opaque for better visual
            border: Border.all(color: borderColor, width: 2.5),
            borderRadius: BorderRadius.circular(12.0), // Rounded corners
            boxShadow: [
              BoxShadow(
                color: borderColor.withOpacity(0.5),
                blurRadius: isLocked ? 2.0 : 5.0,
                spreadRadius: isLocked ? 0.5 : 1.0,
              )
            ],
          ),
          child: Center(
            child: Icon(
              iconData,
              size: size * 0.5, // Icon size relative to box size
              color: iconColor,
            ),
          ),
        ),
      ),
    );
  }
}
