import 'package:flutter/material.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_semantic_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../shared/components/app_button.dart';
import '../../domain/models/analytics_summary_model.dart';

// Payout Breakdown & Settlement History Modal Bottom Sheet
class PayoutBreakdownBottomSheet extends StatelessWidget {
  final AnalyticsSummaryModel summary;

  const PayoutBreakdownBottomSheet({
    super.key,
    required this.summary,
  });

  static Future<void> show(
    BuildContext context, {
    required AnalyticsSummaryModel summary,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => PayoutBreakdownBottomSheet(summary: summary),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor = colors.surface;
    final borderColor = isDark ? const Color(0xFF2C3039) : const Color(0xFFDFE2EE);

    return Container(
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: AppRadius.sheetTop,
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 30,
            offset: Offset(0, -4),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(
        24.0,
        AppSpacing.md,
        24.0,
        AppSpacing.xl,
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Drag Handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF5C5D64) : const Color(0xFFDFE2EE),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Payout & Settlement Breakdown',
                  style: AppTypography.titleMedium.copyWith(
                    color: colors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, size: 20),
                  onPressed: () => Navigator.of(context).pop(),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),

            // Pending Amount Highlight Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E232D) : const Color(0xFFF0F3FF),
                borderRadius: AppRadius.md,
                border: Border.all(color: borderColor, width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'PENDING PAYOUT',
                    style: AppTypography.labelSmall.copyWith(
                      color: colors.textSecondary,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    Formatters.formatCurrency(summary.pendingPayouts),
                    style: AppTypography.headlineMedium.copyWith(
                      color: colors.primary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    children: [
                      Icon(
                        Icons.schedule_outlined,
                        size: 16,
                        color: colors.textSecondary,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Estimated settlement: ${summary.nextPayoutDate}',
                        style: AppTypography.bodySmall.copyWith(
                          color: colors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Details List
            _buildDetailRow(
              context,
              title: 'Total Settled Payouts',
              value: Formatters.formatCurrency(summary.settledPayouts),
              colors: colors,
            ),
            const Divider(height: AppSpacing.lg),
            _buildDetailRow(
              context,
              title: 'Linked Bank Account',
              value: summary.bankAccountMasked,
              colors: colors,
            ),
            const Divider(height: AppSpacing.lg),
            _buildDetailRow(
              context,
              title: 'Payout Frequency',
              value: 'Weekly (Every Friday)',
              colors: colors,
            ),
            const SizedBox(height: AppSpacing.xl),

            // Statement Download Action
            AppButton(
              text: 'Download Financial Statement',
              isFullWidth: true,
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Statement for ${summary.range.label} period downloaded successfully.',
                    ),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context, {
    required String title,
    required String value,
    required AppSemanticColors colors,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: AppTypography.bodyMedium.copyWith(
            color: colors.textSecondary,
          ),
        ),
        Text(
          value,
          style: AppTypography.bodyMedium.copyWith(
            color: colors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
