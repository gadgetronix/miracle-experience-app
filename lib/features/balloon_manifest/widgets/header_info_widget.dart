part of 'passengers_table_widget.dart';

class HeaderInfoWidget extends StatelessWidget {
  const HeaderInfoWidget({super.key, required this.label, required this.value});

  final String label, value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: fontStyleRegular10.copyWith(color: ColorConst.whiteColor),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: fontStyleBold14.copyWith(color: ColorConst.whiteColor),
        ),
      ],
    );
  }
}