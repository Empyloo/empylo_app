import 'package:empylo_app/state_management/access_box_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<String> getAccessToken(WidgetRef ref) async {
  final accessBox = await ref.watch(accessBoxProvider.future);
  return accessBox.get('session')['access_token'];
}
