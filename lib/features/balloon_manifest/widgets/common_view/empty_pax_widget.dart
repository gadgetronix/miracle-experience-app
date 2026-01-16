part of '../../balloon_manifest_body.dart';

class EmptyPaxWidget extends StatelessWidget {
  const EmptyPaxWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.symmetric(vertical: 12),
      child: Padding(
        padding: const EdgeInsets.all(48.0),
        child: Center(
          child: Column(
            children: [
              Icon(Icons.people_outline, size: 64, color: Colors.grey.shade400),
              const SizedBox(height: 16),
              Text(
                AppString.noPassengersAssigned,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}