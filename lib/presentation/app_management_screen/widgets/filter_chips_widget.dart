import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class FilterChipsWidget extends StatelessWidget {
  final List<String> options;
  final String selectedFilter;
  final ValueChanged<String> onFilterChanged;

  const FilterChipsWidget({
    super.key,
    required this.options,
    required this.selectedFilter,
    required this.onFilterChanged,
  });

  IconData _getFilterIcon(String filter) {
    switch (filter) {
      case 'Recently Used':
        return Icons.access_time;
      case 'Alphabetical':
        return Icons.sort_by_alpha;
      case 'Size':
        return Icons.storage;
      case 'Category':
        return Icons.category;
      default:
        return Icons.filter_list;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 6.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        itemCount: options.length,
        separatorBuilder: (context, index) => SizedBox(width: 2.w),
        itemBuilder: (context, index) {
          final option = options[index];
          final isSelected = option == selectedFilter;

          return AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            child: FilterChip(
              selected: isSelected,
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomIconWidget(
                    iconName: _getFilterIcon(option).codePoint.toString(),
                    color: isSelected
                        ? AppTheme.backgroundBlack
                        : AppTheme.primaryCyan,
                    size: 4.w,
                  ),
                  SizedBox(width: 1.w),
                  Text(
                    option,
                    style: AppTheme.darkTheme.textTheme.labelMedium?.copyWith(
                      color: isSelected
                          ? AppTheme.backgroundBlack
                          : AppTheme.primaryCyan,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                ],
              ),
              onSelected: (selected) {
                if (selected) {
                  onFilterChanged(option);
                }
              },
              backgroundColor: AppTheme.surfaceDark,
              selectedColor: AppTheme.primaryCyan,
              checkmarkColor: AppTheme.backgroundBlack,
              side: BorderSide(
                color: isSelected ? AppTheme.primaryCyan : AppTheme.borderColor,
                width: isSelected ? 2 : 1,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: 3.w,
                vertical: 1.h,
              ),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              elevation: isSelected ? 4 : 0,
              shadowColor: isSelected
                  ? AppTheme.primaryCyan.withValues(alpha: 0.3)
                  : Colors.transparent,
            ),
          );
        },
      ),
    );
  }
}
