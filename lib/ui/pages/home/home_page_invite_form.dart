// lib/ui/pages/home/home_page_invite_form.dart
import 'package:empylo_app/models/company.dart';
import 'package:empylo_app/state_management/auth_state_notifier.dart';
import 'package:empylo_app/state_management/selected_company_state.dart';
import 'package:empylo_app/tokens/border_radius.dart';
import 'package:empylo_app/tokens/colors.dart';
import 'package:empylo_app/tokens/decorations.dart';
import 'package:empylo_app/tokens/edge_inserts.dart';
import 'package:empylo_app/tokens/sizes.dart';
import 'package:empylo_app/tokens/spacing.dart';
import 'package:empylo_app/tokens/typography.dart';
import 'package:empylo_app/ui/molecules/widgets/companies_drop_down.dart';
import 'package:empylo_app/state_management/access_box_provider.dart';
import 'package:empylo_app/state_management/user_invite_service_provider.dart';
import 'package:empylo_app/utils/request_processing_state.dart';
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

    void onCompanySelected(Company? company, WidgetRef ref) {
      if (company != null) {
        ref.read(selectedCompanyIdProvider.notifier).state = company.id;
        ref.read(selectedCompanyNameProvider.notifier).state = company.name;
        organizationIdController.text = company.id ?? '';
        organizationNameController.text = company.name;
      }
    }

    return SizedBox(
      width: Sizes.gigantic,
      child: Column(
        children: [
          Text(
            "Invite Users",
            style:
                EmpyloTypography.caption.copyWith(color: ColorTokens.textLight),
          ),
          VerticalSpacing.m,
          Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: emailsController,
                  decoration: InputDecoration(
                    labelText: 'Emails (comma separated)',
                    border: const OutlineInputBorder(
                      borderRadius: EmpyloBorderRadius.s,
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 10.0),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter email(s)';
                    }
                    return null;
                  },
                ),
                VerticalSpacing.s,
                DropdownButtonFormField(
                  value: ref.read(selectedRoleProvider),
                  items: [
                    const DropdownMenuItem(value: 'user', child: Text('User')),
                    const DropdownMenuItem(
                        value: 'admin', child: Text('Admin')),
                    DropdownMenuItem(
                        value: 'super_admin',
                        enabled: authState.role == UserRole.superAdmin,
                        child: const Text('Super Admin')),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      ref.read(selectedRoleProvider.notifier).state = value;
                    } else {
                      ref.read(selectedRoleProvider.notifier).state = 'user';
                    }
                  },
                  decoration: InputDecoration(
                    labelText: 'Role',
                    border: const OutlineInputBorder(
                      borderRadius: EmpyloBorderRadius.s,
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 10.0),
                  ),
                ),
                VerticalSpacing.s,
                // show the company dropdown only if the user is a super admin
                if (authState.role == UserRole.superAdmin)
                  CompaniesDropDown(
                    onCompanySelected: (Company? company) {
                      if (company != null) {
                        onCompanySelected(company, ref);
                        // change the value of the organizationIdController
                        organizationIdController.text = company.id ?? '';
                      }
                    },
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
                        final userInviteService =
                            ref.read(userInviteServiceProvider);
                        final accessToken = ref
                            .read(accessBoxProvider)
                            .asData!
                            .value
                            .get('session')['access_token'];
                        final emails = emailsController.text.split(',');
                        final organizationId = organizationIdController.text;
                        final organizationName =
                            organizationNameController.text;
                        final role = ref.read(selectedRoleProvider);


                        try {
                          ref.read(requestProcessingProvider.notifier).start();

                          await userInviteService.invites(
                            emails: emails,
                            organizationId: organizationId.isNotEmpty
                                ? organizationId
                                : null, // check if the id is not null and not empty
                            organizationName: organizationName.isNotEmpty
                                ? organizationName
                                : null,
                            accessToken: accessToken,
                            role: role,
                          );
                          showSnackBar('Invites sent successfully');
                        } catch (e) {
                          showSnackBar('Error sending invites');
                        } finally {
                          ref.read(requestProcessingProvider.notifier).end();
                        }

                        // clear the form
                        emailsController.clear();
                        organizationIdController.clear();
                        organizationNameController.clear();
                      }
                    },
                    child: ref.watch(requestProcessingProvider)
                        ? const CircularProgressIndicator()
                        : const Text('Send Invites'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
