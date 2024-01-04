// Path: lib/ui/molecules/widgets/companies/company_profile_page.dart
import 'package:empylo_app/models/company.dart';
import 'package:empylo_app/state_management/company_access_checker_provider.dart';
import 'package:empylo_app/state_management/company_list_provider.dart';
import 'package:empylo_app/tokens/border_radius.dart';
import 'package:empylo_app/tokens/sizes.dart';
import 'package:empylo_app/tokens/spacing.dart';
import 'package:empylo_app/ui/pages/company_management/utils/on_delete_company.dart';
import 'package:empylo_app/ui/pages/error/erro_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CompanyProfilePage extends ConsumerWidget {
  final String companyId;

  const CompanyProfilePage({super.key, required this.companyId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isUserAuthorized = ref.watch(companyAccessCheckerProvider(companyId));

    if (!isUserAuthorized) {
      return const ErrorPage('You do not have permission to access this page.');
    }

    final companies = ref.watch(companyListNotifierProvider);
    final company = companies.firstWhere((c) => c.id == companyId);

    final formHasChangesNotifier = ValueNotifier<bool>(false);

    final nameController = TextEditingController(text: company.name);
    final emailController = TextEditingController(text: company.email);
    final sizeController = TextEditingController(text: company.size.toString());
    final phoneController = TextEditingController(text: company.phone ?? '');
    final descriptionController =
        TextEditingController(text: company.description ?? '');
    bool subscribed = company.subscribed ?? false;

    return Scaffold(
      appBar: AppBar(
        title: Text('Company Profile: ${company.name}'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: SizedBox(
            width: Sizes.enormous,
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              shrinkWrap: true,
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Company Name',
                    border: const OutlineInputBorder(
                      borderRadius: EmpyloBorderRadius.s,
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 10.0),
                  ),
                  onChanged: (value) {
                    formHasChangesNotifier.value = true;
                  },
                ),
                VerticalSpacing.xs,
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'Company Email',
                    border: const OutlineInputBorder(
                      borderRadius: EmpyloBorderRadius.s,
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 10.0),
                  ),
                  onChanged: (value) {
                    formHasChangesNotifier.value = true;
                  },
                ),
                VerticalSpacing.xs,
                TextField(
                  controller: sizeController,
                  decoration: InputDecoration(
                    labelText: 'Company Size',
                    border: const OutlineInputBorder(
                      borderRadius: EmpyloBorderRadius.s,
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 10.0),
                  ),
                  onChanged: (value) {
                    formHasChangesNotifier.value = true;
                  },
                ),
                VerticalSpacing.xs,
                TextField(
                  controller: phoneController,
                  decoration: InputDecoration(
                    labelText: 'Company Phone',
                    border: const OutlineInputBorder(
                      borderRadius: EmpyloBorderRadius.s,
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 10.0),
                  ),
                  onChanged: (value) {
                    formHasChangesNotifier.value = true;
                  },
                ),
                VerticalSpacing.xs,
                TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(
                    labelText: 'Company Description',
                    border: const OutlineInputBorder(
                      borderRadius: EmpyloBorderRadius.s,
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 10.0),
                  ),
                  maxLines: 5,
                  onChanged: (value) {
                    formHasChangesNotifier.value = true;
                  },
                ),
                VerticalSpacing.xs,
                CheckboxListTile(
                  title: const Text('Subscribed'),
                  value: subscribed,
                  onChanged: (bool? value) {
                    subscribed = value ?? false;
                    formHasChangesNotifier.value = true;
                  },
                ),
                VerticalSpacing.xs,
                ValueListenableBuilder<bool>(
                  valueListenable: formHasChangesNotifier,
                  builder: (context, hasChanges, child) {
                    return Visibility(
                      visible: hasChanges,
                      child: ElevatedButton(
                        onPressed: () async {
                          final scaff = ScaffoldMessenger.of(context);
                          final company = Company(
                            id: companyId,
                            name: nameController.text,
                            email: emailController.text,
                            size: int.parse(sizeController.text),
                            phone: phoneController.text,
                            description: descriptionController.text,
                            subscribed: subscribed,
                          );
                          final result = await ref
                              .read(companyListNotifierProvider.notifier)
                              .updateCompany(companyId, company.toJson(), ref);
                          if (result) {
                            scaff.showSnackBar(
                              const SnackBar(
                                content: Text('Saved successfully.'),
                              ),
                            );
                          } else {
                            scaff.showSnackBar(
                              const SnackBar(
                                content: Text('Error saving edit.'),
                              ),
                            );
                          }
                          formHasChangesNotifier.value = false;
                        },
                        child: const Text('Save'),
                      ),
                    );
                  },
                ),
                VerticalSpacing.xs,
                ElevatedButton(
                  onPressed: () {
                    onDeleteCompany(context, companyId, ref);
                  },
                  child: const Text('Delete'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
