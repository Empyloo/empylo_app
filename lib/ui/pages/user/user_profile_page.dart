// Path: lib/ui/pages/user/user_profile_page.dartimport 'package:empylo_app/models/user_profile.dart';
import 'package:empylo_app/state_management/user_profile_provider.dart';
import 'package:empylo_app/ui/molecules/inputs/text_form_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfile = ref.watch(userProfileNotifierProvider);
    final userProfileNotifier = ref.read(userProfileNotifierProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormFieldInput(
              controller: TextEditingController(text: userProfile?.firstName),
              keyboardType: TextInputType.text,
              edgeInsetsGeo: const EdgeInsets.symmetric(vertical: 8.0),
              decoration: const InputDecoration(labelText: 'First Name'),
              onSubmitted: (value) =>
                  userProfileNotifier.updateField('first_name', value),
            ),
            TextFormFieldInput(
              controller: TextEditingController(text: userProfile?.lastName),
              keyboardType: TextInputType.text,
              edgeInsetsGeo: const EdgeInsets.symmetric(vertical: 8.0),
              decoration: const InputDecoration(labelText: 'Last Name'),
              onSubmitted: (value) =>
                  userProfileNotifier.updateField('last_name', value),
            ),
            TextFormFieldInput(
              controller: TextEditingController(text: userProfile?.email),
              keyboardType: TextInputType.emailAddress,
              edgeInsetsGeo: const EdgeInsets.symmetric(vertical: 8.0),
              decoration: const InputDecoration(labelText: 'Email'),
              onSubmitted: (value) =>
                  userProfileNotifier.updateField('email', value),
            ),
            TextFormFieldInput(
              controller: TextEditingController(text: userProfile?.phone),
              keyboardType: TextInputType.phone,
              edgeInsetsGeo: const EdgeInsets.symmetric(vertical: 8.0),
              decoration: const InputDecoration(labelText: 'Phone'),
              onSubmitted: (value) =>
                  userProfileNotifier.updateField('phone', value),
            ),
            TextFormFieldInput(
              controller: TextEditingController(text: userProfile?.jobTitle),
              keyboardType: TextInputType.text,
              edgeInsetsGeo: const EdgeInsets.symmetric(vertical: 8.0),
              decoration: const InputDecoration(labelText: 'Job Title'),
              onSubmitted: (value) =>
                  userProfileNotifier.updateField('job_title', value),
            ),
            DropdownButtonFormField<String>(
              value: userProfile?.ageRange,
              decoration: const InputDecoration(labelText: 'Age Range'),
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
                userProfileNotifier.updateField('date_of_birth', newValue);
              },
            ),
            DropdownButtonFormField<String>(
              value: userProfile?.ethnicity,
              decoration: const InputDecoration(labelText: 'Ethnicity'),
              items: <String>['Ethnicity 1', 'Ethnicity 2', 'Ethnicity 3']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                userProfileNotifier.updateField('ethnicity', newValue);
              },
            ),
            DropdownButtonFormField<String>(
              value: userProfile?.sexuality,
              decoration: const InputDecoration(labelText: 'Sexuality'),
              items: <String>['Sexuality 1', 'Sexuality 2', 'Sexuality 3']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                userProfileNotifier.updateField('sexuality', newValue);
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Disability'),
                RadioListTile<bool>(
                  value: true,
                  groupValue: userProfile?.disability,
                  title: const Text('Yes'),
                  onChanged: (bool? newValue) {
                    userProfileNotifier.updateField('disability', newValue);
                  },
                ),
                RadioListTile<bool>(
                  value: false,
                  groupValue: userProfile?.disability,
                  title: const Text('No'),
                  onChanged: (bool? newValue) {
                    userProfileNotifier.updateField('disability', newValue);
                  },
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Married'),
                RadioListTile<bool>(
                  value: true,
                  groupValue: userProfile?.married,
                  title: const Text('Yes'),
                  onChanged: (bool? newValue) {
                    userProfileNotifier.updateField('married', newValue);
                  },
                ),
                RadioListTile<bool>(
                  value: false,
                  groupValue: userProfile?.married,
                  title: const Text('No'),
                  onChanged: (bool? newValue) {
                    userProfileNotifier.updateField('married', newValue);
                  },
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Is Parent'),
                RadioListTile<bool>(
                  value: true,
                  groupValue: userProfile?.isParent,
                  title: const Text('Yes'),
                  onChanged: (bool? newValue) {
                    userProfileNotifier.updateField('is_parent', newValue);
                  },
                ),
                RadioListTile<bool>(
                  value: false,
                  groupValue: userProfile?.isParent,
                  title: const Text('No'),
                  onChanged: (bool? newValue) {
                    userProfileNotifier.updateField('is_parent', newValue);
                  },
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Team Selected'),
                RadioListTile<bool>(
                  value: true,
                  groupValue: userProfile?.teamSelected,
                  title: const Text('Yes'),
                  onChanged: (bool? newValue) {
                    userProfileNotifier.updateField('team_selected', newValue);
                  },
                ),
                RadioListTile<bool>(
                  value: false,
                  groupValue: userProfile?.teamSelected,
                  title: const Text('No'),
                  onChanged: (bool? newValue) {
                    userProfileNotifier.updateField('team_selected', newValue);
                  },
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Accepted Terms'),
                RadioListTile<bool>(
                  value: true,
                  groupValue: userProfile?.acceptedTerms,
                  title: const Text('Yes'),
                  onChanged: (bool? newValue) {
                    userProfileNotifier.updateField('accepted_terms', newValue);
                  },
                ),
                RadioListTile<bool>(
                  value: false,
                  groupValue: userProfile?.acceptedTerms,
                  title: const Text('No'),
                  onChanged: (bool? newValue) {
                    userProfileNotifier.updateField('accepted_terms', newValue);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
