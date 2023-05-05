// Path: lib/ui/pages/user/user_profile_page.dartimport 'package:empylo_app/models/user_profile.dart';
import 'package:empylo_app/state_management/access_box_provider.dart';
import 'package:empylo_app/state_management/router_provider.dart';
import 'package:empylo_app/state_management/user_profile_provider.dart';
import 'package:empylo_app/tokens/sizes.dart';
import 'package:empylo_app/ui/molecules/inputs/text_form_fields.dart';
import 'package:empylo_app/ui/molecules/widgets/teams_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final hasChangesProvider = StateProvider<bool>((ref) => false);

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfile = ref.watch(userProfileNotifierProvider);
    final userProfileNotifier = ref.read(userProfileNotifierProvider.notifier);
    final hasChanges = ref.watch(hasChangesProvider);
    final box = ref.watch(accessBoxProvider);

    void _updateField(
        BuildContext context, WidgetRef ref, String field, dynamic value) {
      ref.read(userProfileNotifierProvider.notifier).updateField(field, value);
      ref.read(hasChangesProvider.notifier).state = true;
    }

    const borderRadius = BorderRadius.all(Radius.circular(16));

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SizedBox(
            width: 400,
            child: Container(
              padding: const EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: borderRadius,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade300,
                    blurRadius: 10,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Column(
                children: [
                  TextFormFieldInput(
                    controller: TextEditingController(text: userProfile?.email),
                    keyboardType: TextInputType.emailAddress,
                    edgeInsetsGeo: const EdgeInsets.symmetric(vertical: 1.0),
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: const OutlineInputBorder(
                        borderRadius: borderRadius,
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 10.0),
                    ),
                    onSubmitted: (value) =>
                        _updateField(context, ref, 'email', value),
                  ),
                  TextFormFieldInput(
                    controller:
                        TextEditingController(text: userProfile?.jobTitle),
                    keyboardType: TextInputType.text,
                    edgeInsetsGeo: const EdgeInsets.symmetric(vertical: 8.0),
                    decoration: InputDecoration(
                      labelText: 'Job Title',
                      border: const OutlineInputBorder(
                        borderRadius: borderRadius,
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 10.0),
                    ),
                    onSubmitted: (value) =>
                        _updateField(context, ref, 'job_title', value),
                  ),
                  SizedBox(
                    width: Sizes.massive,
                    height: Sizes.xxl,
                    child: DropdownButtonFormField<String>(
                      value: userProfile?.ageRange,
                      decoration: InputDecoration(
                        labelText: 'Age Range',
                        border: const OutlineInputBorder(
                          borderRadius: borderRadius,
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 10.0),
                      ),
                      items: <String>[
                        '16-25',
                        '26-35',
                        '36-45',
                        '46-55',
                        '56-65',
                        '66+'
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        _updateField(context, ref, 'age_range', newValue);
                      },
                    ),
                  ),
                  SizedBox(
                    width: Sizes.massive,
                    height: Sizes.xxl,
                    child: DropdownButtonFormField<String>(
                      value: userProfile?.ethnicity,
                      decoration: InputDecoration(
                        labelText: 'Ethnicity',
                        border: const OutlineInputBorder(
                          borderRadius: borderRadius,
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade100,
                      ),
                      items: <String>[
                        'Ethnicity 1',
                        'Ethnicity 2',
                        'Ethnicity 3'
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        _updateField(context, ref, 'ethnicity', newValue);
                      },
                    ),
                  ),
                  SizedBox(
                    width: Sizes.massive,
                    height: Sizes.xxl,
                    child: DropdownButtonFormField<String>(
                      value: userProfile?.sexuality,
                      decoration: InputDecoration(
                        labelText: 'Sexuality',
                        border: const OutlineInputBorder(
                          borderRadius: borderRadius,
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor:  Colors.grey.shade100,
                      ),
                      items: <String>[
                        'Sexuality 1',
                        'Sexuality 2',
                        'Sexuality 3'
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        _updateField(context, ref, 'sexuality', newValue);
                      },
                    ),
                  ),
                  SizedBox(
                    width: Sizes.massive,
                    height: Sizes.xxl,
                    child: CheckboxListTile(
                      title: const Text('Disability'),
                      value: userProfile?.disability ?? false,
                      onChanged: (bool? newValue) {
                        _updateField(context, ref, 'disability', newValue);
                      },
                    ),
                  ),
                  SizedBox(
                    width: Sizes.massive,
                    height: Sizes.xxl,
                    child: CheckboxListTile(
                      title: const Text('Married'),
                      value: userProfile?.married ?? false,
                      onChanged: (bool? newValue) {
                        _updateField(context, ref, 'married', newValue);
                      },
                    ),
                  ),
                  SizedBox(
                    width: Sizes.massive,
                    height: Sizes.xxl,
                    child: CheckboxListTile(
                      title: const Text('Is Parent'),
                      value: userProfile?.isParent ?? false,
                      onChanged: (bool? newValue) {
                        _updateField(context, ref, 'is_parent', newValue);
                      },
                    ),
                  ),
                  const TeamList(),
                  SizedBox(
                    width: Sizes.massive,
                    height: Sizes.xxl,
                    child: CheckboxListTile(
                      title: const Text('Accept Terms'),
                      value: userProfile?.acceptedTerms ?? false,
                      onChanged: (bool? newValue) {
                        _updateField(context, ref, 'accepted_terms', newValue);
                      },
                    ),
                  ),
                  SizedBox(
                    width: Sizes.massive,
                    height: Sizes.xxl,
                    child: TextButton(
                      onPressed: () {
                        ref.read(routerProvider).go('/home');
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.blue.withOpacity(0.7),
                      ),
                      child: const Text('Go to Home Page'),
                    ),
                  ),
                  SizedBox(
                    width: Sizes.massive,
                    height: Sizes.xxl,
                    child: ElevatedButton(
                      onPressed: () {
                        // remove session from Hive box
                        box.asData!.value.delete('session');
                        // navigate to login page
                        ref.read(routerProvider).go('/');
                      },
                      child: const Text('Logout'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: hasChanges
          ? FloatingActionButton(
              onPressed: () async {
                try {
                  final successSnackBar =
                      ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Profile updated successfully'),
                      duration: Duration(seconds: 3),
                    ),
                  );
                  // Assuming you have userProfile?.id and an accessToken variable
                  String id = userProfile?.id ?? '';
                  final accessBox = await ref.read(accessBoxProvider.future);
                  final session = accessBox.get('session');
                  print('session: $session');
                  String accessToken = session['access_token'];
                  print('access_token: $accessToken');
                  Map<String, dynamic> updates = userProfile?.toMap() ?? {};
                  print('updates: $updates');
                  ref
                      .read(userProfileNotifierProvider.notifier)
                      .updateUserProfile(id, updates, accessToken);
                  ref.read(hasChangesProvider.notifier).state = false;
                  // Show Snackbar when update is successful
                  successSnackBar;
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Failed to update profile'),
                      duration: Duration(seconds: 3),
                    ),
                  );
                }
              },
              child: Column(
                children: const [
                  Text('Save'),
                  Icon(Icons.save),
                ],
              ),
            )
          : null,
    );
  }
}
