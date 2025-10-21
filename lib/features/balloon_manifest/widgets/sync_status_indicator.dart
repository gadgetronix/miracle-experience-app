import 'package:flutter/material.dart';

/// Status indicator showing time sync status in app bar
class SyncStatusIndicator extends StatelessWidget {
  final String cacheStatus;
  final VoidCallback? onTap;

  const SyncStatusIndicator({
    super.key,
    required this.cacheStatus,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: _getStatusColor().withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _getStatusColor(),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _getStatusIcon(),
              size: 14,
              color: _getStatusColor(),
            ),
            const SizedBox(width: 6),
            Text(
              _getShortStatus(),
              style: TextStyle(
                color: _getStatusColor(),
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor() {
    if (cacheStatus.contains('restarted')) {
      return Colors.orange;
    } else if (cacheStatus.contains('ago')) {
      return Colors.green;
    }
    return Colors.grey;
  }

  IconData _getStatusIcon() {
    if (cacheStatus.contains('restarted')) {
      return Icons.sync_problem;
    } else if (cacheStatus.contains('ago')) {
      return Icons.check_circle;
    }
    return Icons.info;
  }

  String _getShortStatus() {
    if (cacheStatus.contains('restarted')) {
      return 'Sync needed';
    } else if (cacheStatus.contains('ago')) {
      final match = RegExp(r'(\d+)\s+hours?').firstMatch(cacheStatus);
      if (match != null) {
        return '${match.group(1)}h ago';
      }
      return 'Synced';
    }
    return 'Status';
  }
}
