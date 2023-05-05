// lib/ui/pages/home/home_page_invite_form.dart
import 'package:dio/dio.dart';
import 'package:empylo_app/state_management/auth_state_notifier.dart';
import 'package:empylo_app/state_management/company_list_provider.dart';
import 'package:empylo_app/state_management/selected_company_state.dart';
import 'package:empylo_app/tokens/decorations.dart';
import 'package:empylo_app/tokens/edge_inserts.dart';
import 'package:empylo_app/tokens/sizes.dart';
import 'package:empylo_app/tokens/spacing.dart';
import 'package:empylo_app/ui/molecules/widgets/companies_drop_down.dart';
import 'package:empylo_app/state_management/access_box_provider.dart';
import 'package:empylo_app/state_management/user_invite_service_provider.dart';
import 'package:empylo_app/ui/molecules/widgets/custom_containers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePageInviteForm extends ConsumerWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  HomePageInviteForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailsController = TextEditingController();
    final organizationIdController = TextEditingController();
    final organizationNameController = TextEditingController();
    final authState = ref.watch(authStateProvider);

    void showSnackBar(String message) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }

    void onCompanySelected(String companyId, WidgetRef ref) {
      final companyList = ref.watch(companyListNotifierProvider);

      companyList.when(
        data: (companyList) {
          final selectedCompany =
              companyList.firstWhere((company) => company.id == companyId);
          // Update the selected company's id and name using providers
          ref.read(selectedCompanyIdProvider.notifier).state =
              selectedCompany.id;
          ref.read(selectedCompanyNameProvider.notifier).state =
              selectedCompany.name;
        },
        loading: () => {
          // Handle loading state
          const CircularProgressIndicator(),
        },
        error: (error, stackTrace) {
          // Handle error state
          showSnackBar('Error fetching companies: $error');
        },
      );
    }

    return Form(
      key: _formKey,
      child: Column(
        children: [
          CustomContainer(
            decoration: EmpyloBoxDecorations.lightOutlined,
            margin: EmpyloEdgeInserts.s,
            child: TextFormField(
              controller: emailsController,
              decoration: const InputDecoration(
                labelText: 'Emails (comma separated)',
                border: InputBorder.none,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter email(s)';
                }
                return null;
              },
            ),
          ),
          CustomContainer(
            decoration: EmpyloBoxDecorations.lightOutlined,
            margin: EmpyloEdgeInserts.s,
            child: DropdownButtonFormField(
              value: ref.read(selectedRoleProvider),
              items: [
                const DropdownMenuItem(value: 'user', child: Text('User')),
                const DropdownMenuItem(value: 'admin', child: Text('Admin')),
                DropdownMenuItem(
                    value: 'super_admin',
                    enabled: authState.role == UserRole.admin ||
                        authState.role == UserRole.superAdmin,
                    child: const Text('Super Admin')),
              ],
              onChanged: (value) {
                if (value != null) {
                  ref.read(selectedRoleProvider.notifier).state = value;
                } else {
                  ref.read(selectedRoleProvider.notifier).state = 'user';
                }
              },
              decoration: const InputDecoration(
                labelText: 'Role',
                border: InputBorder.none, // to remove the underline
              ),
            ),
          ),
          CustomContainer(
            decoration: EmpyloBoxDecorations.lightOutlined,
            margin: EmpyloEdgeInserts.s,
            child: CompaniesDropDown(
              onCompanySelected: (String? companyId) {
                if (companyId != null) {
                  onCompanySelected(companyId, ref);
                  // change the value of the organizationIdController
                  organizationIdController.text = companyId;
                }
              },
            ),
          ),
          Container(
            decoration: EmpyloBoxDecorations.lightOutlined,
            margin: EmpyloEdgeInserts.s,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(Sizes.m),
                ),
                minimumSize: const Size.fromHeight(Sizes.mega),
              ),
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  final userInviteService = ref.read(userInviteServiceProvider);
                  final accessToken = ref
                      .read(accessBoxProvider)
                      .asData!
                      .value
                      .get('session')['access_token'];
                  final emails = emailsController.text.split(',');
                  final organizationId = organizationIdController.text;
                  final organizationName = organizationNameController.text;
                  final role = ref.read(selectedRoleProvider);

                  print('Sending invites...');
                  print("emails: $emails");
                  print("organizationId: $organizationId");
                  print("organizationName: $organizationName");
                  print("role: $role");

                  try {
                    await userInviteService.invites(
                      emails: emails,
                      organizationId: organizationId.isNotEmpty
                          ? organizationId
                          : null, // check if the id is not null and not empty
                      organizationName:
                          organizationName.isNotEmpty ? organizationName : null,
                      accessToken: accessToken,
                      role: role,
                    );
                    showSnackBar('Invtes sent successfully');
                  } catch (e) {
                    print('Error sending invites: $e');
                    showSnackBar('Error sending invites');
                  }
                }
              },
              child: const Text('Send Invites'),
            ),
          ),
        ],
      ),
    );
  }
}
