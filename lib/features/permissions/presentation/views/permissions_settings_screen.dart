import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/components/app_card.dart';
import '../../../../shared/components/app_switch.dart';
import '../../../../shared/components/app_circular_back_button.dart';
import '../../../../shared/components/app_toast.dart';
import '../../domain/models/app_permission_type.dart';
import '../../domain/models/permission_status_model.dart';
import '../controllers/permission_controller.dart';
import '../widgets/permission_rationale_dialog.dart';

// Permissions & Privacy Settings Screen
class PermissionsSettingsScreen extends StatelessWidget {
  const PermissionsSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final controller = context.watch<PermissionController>();

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkCanvas : AppColors.lightCanvas,
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF161B22) : const Color(0xFFFFFFFF),
        elevation: 0,
        scrolledUnderElevation: 0,
        leadingWidth: 56,
        leading: const AppCircularBackButton(),
        title: Text(
          'App Permissions',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w900,
            letterSpacing: -0.2,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: isDark ? AppColors.darkBorder : const Color(0xFFEEF0F2),
            height: 1.0,
          ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Overview Header Card
            AppCard(
              padding: const EdgeInsets.all(18),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.security_rounded,
                      color: AppColors.primary,
                      size: 22,
                    ),
                  ),
                  AppSpacing.hGap14,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Privacy & OS Capabilities',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Manage device hardware and alert access used to fulfill vendor operations.',
                          style: TextStyle(
                            fontSize: 11,
                            color: isDark ? AppColors.textMutedDark : const Color(0xFF6B7280),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            AppSpacing.vGap20,

            Text(
              'DEVICE PERMISSIONS',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.0,
                color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
              ),
            ),
            AppSpacing.vGap8,

            // Permission Items
            ...AppPermissionType.values.map((type) {
              final isGranted = controller.isGranted(type);

              return Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: AppCard(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: type.color.withValues(alpha: 0.12),
                          borderRadius: AppRadius.md,
                        ),
                        child: Icon(type.icon, color: type.color, size: 20),
                      ),
                      AppSpacing.hGap12,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              type.title,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              type.description,
                              style: TextStyle(
                                fontSize: 10.5,
                                color: isDark ? AppColors.textSecondaryDark : const Color(0xFF4B5563),
                              ),
                            ),
                          ],
                        ),
                      ),
                      AppSpacing.hGap10,
                      AppSwitch(
                        value: isGranted,
                        onChanged: (val) async {
                          if (val) {
                            final allowed = await PermissionRationaleDialog.show(
                              context: context,
                              permissionType: type,
                            );
                            if (allowed == true) {
                              controller.setPermissionStatus(type, AppPermissionStatus.granted);
                              if (context.mounted) {
                                AppToast.showSuccess(
                                  context,
                                  title: '${type.title} Enabled',
                                  message: 'Access granted for merchant workflows.',
                                );
                              }
                            }
                          } else {
                            controller.setPermissionStatus(type, AppPermissionStatus.denied);
                            if (context.mounted) {
                              AppToast.showWarning(
                                context,
                                title: '${type.title} Disabled',
                                message: 'Access revoked in merchant settings.',
                              );
                            }
                          }
                        },
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
