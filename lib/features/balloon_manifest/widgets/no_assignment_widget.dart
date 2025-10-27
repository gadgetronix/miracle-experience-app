part of '../balloon_manifest_screen.dart';

class NoAssignmentWidget extends StatelessWidget {
  const NoAssignmentWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.assignment_outlined,
            size: 64,
            color: ColorConst.textGreyColor,
          ),
          const SizedBox(height: 16),
          Text(
            AppString.noAssignmentsAvailable,
            style: fontStyleMedium15.copyWith(
              color: ColorConst.textGreyColor,
            ),
          ),
        ],
      ),
    );
  }
}