// Path: lib/ui/pages/company_management/super_admin_company_list.dart
import 'package:empylo_app/models/company.dart';
import 'package:empylo_app/state_management/auth_state_notifier.dart';
import 'package:empylo_app/state_management/company_list_provider.dart';
import 'package:empylo_app/tokens/colors.dart';
import 'package:empylo_app/tokens/sizes.dart';
import 'package:empylo_app/tokens/spacing.dart';
import 'package:empylo_app/tokens/typography.dart';
import 'package:empylo_app/ui/pages/company_management/layouts/desktop.dart';
import 'package:empylo_app/ui/pages/company_management/layouts/mobile.dart';
import 'package:empylo_app/ui/pages/company_management/layouts/tablet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SuperAdminCompanyList extends ConsumerWidget {
  const SuperAdminCompanyList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final companyList = ref.watch(companyListNotifierProvider);

    if (companyList.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await ref
            .read(companyListNotifierProvider.notifier)
            .fetchCompanies(ref);
      });
      return const Center(child: CircularProgressIndicator());
    }

    if (authState.role != UserRole.superAdmin) {
      return const Text('You do not have permission to view this page.');
    }

    return Column(
      children: [
        Text(
          "Company List",
          style:
              EmpyloTypography.caption.copyWith(color: ColorTokens.textLight),
        ),
        VerticalSpacing.m,
        LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final bool isTabletLayout =
                constraints.maxWidth >= Breakpoints.tablet;
            final bool isDesktopLayout =
                constraints.maxWidth >= Breakpoints.desktop;

            return Column(
              children: List.generate(
                companyList.length,
                (index) {
                  Company company = companyList[index];

                  return Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: index % 2 == 0
                          ? Colors.grey.shade100
                          : Colors.blue.shade50,
                    ),
                    child: ListTile(
                      title: Text(company.name),
                      subtitle: isDesktopLayout
                          ? DesktopLayout(
                              id: company.id!,
                              email: company.email,
                              ref: ref,
                            )
                          : isTabletLayout
                              ? TabletLayout(
                                  id: company.id!,
                                  email: company.email,
                                  ref: ref,
                                )
                              : MobileLayout(
                                  id: company.id!,
                                  email: company.email,
                                  ref: ref,
                                ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }
}
