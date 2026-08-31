import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_semantic_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../shared/components/app_button.dart';
import '../../../../shared/components/app_card.dart';
import '../../../../shared/components/app_text_field.dart';
import '../../../../shared/components/app_bottom_sheet.dart';
import '../../../../shared/components/app_circular_back_button.dart';
import '../../../../shared/components/app_toast.dart';
import '../../../notifications/presentation/controllers/notification_controller.dart';
import '../../../notifications/domain/models/notification_type.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../controllers/profile_controller.dart';

// Bank Settlement & Weekly Payout Overview Screen
class BankPayoutScreen extends StatefulWidget {
  const BankPayoutScreen({super.key});

  @override
  State<BankPayoutScreen> createState() => _BankPayoutScreenState();
}

class _BankPayoutScreenState extends State<BankPayoutScreen> {
  void _openEditBankModal() {
    final profileController = context.read<ProfileController>();
    final account = profileController.bankAccount;

    final bankNameController = TextEditingController(text: account?.bankName ?? 'Chase Bank N.A.');
    final accountNumController = TextEditingController(text: account?.accountNumber ?? '');
    final holderController = TextEditingController(text: account?.accountHolderName ?? 'Arif Food Enterprises LLC');
    final routingController = TextEditingController(text: account?.routingNumber ?? '121000358');

    AppBottomSheet.show(
      context: context,
      title: 'Update Bank Account',
      subtitle: 'Settlements are automatically wired to this verified checking account',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppTextField(
            label: 'Bank Institution Name',
            controller: bankNameController,
          ),
          AppSpacing.vGap12,
          AppTextField(
            label: 'Account Holder Name',
            controller: holderController,
          ),
          AppSpacing.vGap12,
          AppTextField(
            label: 'Account Number',
            controller: accountNumController,
            keyboardType: TextInputType.number,
          ),
          AppSpacing.vGap12,
          AppTextField(
            label: 'Routing / Transit Number',
            controller: routingController,
            keyboardType: TextInputType.number,
          ),
          AppSpacing.vGap24,
          AppButton(
            text: 'Save & Verify Bank Account',
            onPressed: () async {
              Navigator.of(context).pop();
              final authController = context.read<AuthController>();
              final vendorId = authController.vendor?.id ?? 'vendor_001';

              final result = await profileController.updateBankDetails(
                vendorId: vendorId,
                bankName: bankNameController.text.trim(),
                accountNumber: accountNumController.text.trim(),
                accountHolderName: holderController.text.trim(),
                routingNumber: routingController.text.trim(),
              );

              if (mounted) {
                result.when(
                  success: (_) {
                    context.read<NotificationController>().dispatchNotification(
                      context,
                      title: 'Bank Account Updated',
                      message: 'Weekly payout deposits verified for ${bankNameController.text.trim()}.',
                      type: NotificationType.payout,
                      toastVariant: AppToastVariant.success,
                    );
                  },
                  failure: (msg, _) {
                    AppToast.showError(context, title: 'Bank Verification Failed', message: msg);
                  },
                );
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final profileController = context.watch<ProfileController>();
    final account = profileController.bankAccount;

    final mockPayouts = [
      {'date': 'Monday, Aug 25', 'amount': 8420.50, 'status': 'Deposited', 'ref': 'PAY-948102'},
      {'date': 'Monday, Aug 18', 'amount': 7890.00, 'status': 'Deposited', 'ref': 'PAY-948011'},
      {'date': 'Monday, Aug 11', 'amount': 9120.25, 'status': 'Deposited', 'ref': 'PAY-947932'},
    ];

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: colors.surface,
        elevation: 0,
        scrolledUnderElevation: 0,
        leadingWidth: 56,
        leading: const AppCircularBackButton(),
        title: Text(
          'Bank & Payouts',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w900,
            letterSpacing: -0.2,
            color: colors.textPrimary,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: colors.borderSubtle,
            height: 1.0,
          ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Next Scheduled Payout Card
            AppCard(
              gradient: LinearGradient(
                colors: [
                  colors.primary,
                  colors.primary.withValues(alpha: 0.85),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              padding: const EdgeInsets.all(22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'NEXT ESTIMATED PAYOUT',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.0,
                          color: Colors.white70,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: AppRadius.full,
                        ),
                        child: const Text(
                          'Processing',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  AppSpacing.vGap8,
                  Text(
                    Formatters.formatCurrency(8940.00),
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                  AppSpacing.vGap6,
                  const Text(
                    'Scheduled for Monday, Sep 01 • Weekly Cycle',
                    style: TextStyle(fontSize: 12, color: Colors.white70),
                  ),
                ],
              ),
            ),

            AppSpacing.vGap20,

            // Linked Bank Account Card
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'LINKED CHECKING ACCOUNT',
                  style: AppTypography.labelSmall.copyWith(
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.0,
                    color: colors.textMuted,
                  ),
                ),
                GestureDetector(
                  onTap: _openEditBankModal,
                  child: Text(
                    'Edit Details',
                    style: TextStyle(
                      color: colors.primary,
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),

            AppSpacing.vGap8,

            AppCard(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: colors.successBg,
                          borderRadius: AppRadius.md,
                        ),
                        child: Icon(
                          Icons.account_balance_rounded,
                          color: colors.success,
                          size: 22,
                        ),
                      ),
                      AppSpacing.hGap14,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              account?.bankName ?? 'Chase Bank N.A.',
                              style: AppTypography.titleSmall.copyWith(
                                fontWeight: FontWeight.w800,
                                color: colors.textPrimary,
                              ),
                            ),
                            Text(
                              account?.maskedAccountNumber ?? '•••• •••• 4829',
                              style: AppTypography.bodySmall.copyWith(
                                color: colors.textMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: colors.successBg,
                          borderRadius: AppRadius.full,
                        ),
                        child: Text(
                          'Verified',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: colors.success,
                          ),
                        ),
                      ),
                    ],
                  ),
                  AppSpacing.vGap12,
                  Divider(height: 1, color: colors.divider),
                  AppSpacing.vGap12,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Account Holder',
                        style: AppTypography.bodySmall.copyWith(
                          color: colors.textMuted,
                        ),
                      ),
                      Text(
                        account?.accountHolderName ?? 'Arif Food Enterprises LLC',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                          color: colors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            AppSpacing.vGap20,

            // Recent Settlements History
            Text(
              'RECENT SETTLEMENTS',
              style: AppTypography.labelSmall.copyWith(
                fontWeight: FontWeight.w800,
                letterSpacing: 1.0,
                color: colors.textMuted,
              ),
            ),

            AppSpacing.vGap8,

            ...mockPayouts.map((p) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: AppCard(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: colors.surfaceSubtle,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(Icons.arrow_downward_rounded, size: 18, color: colors.success),
                      ),
                      AppSpacing.hGap12,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              p['date'] as String,
                              style: AppTypography.titleSmall.copyWith(
                                fontWeight: FontWeight.w700,
                                color: colors.textPrimary,
                              ),
                            ),
                            Text(
                              'Ref: ${p['ref']}',
                              style: AppTypography.bodySmall.copyWith(
                                color: colors.textMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        Formatters.formatCurrency(p['amount'] as double),
                        style: AppTypography.titleSmall.copyWith(
                          fontWeight: FontWeight.w800,
                          color: colors.textPrimary,
                        ),
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
