// Path: lib/ui/molecules/widgets/audience_create_edit_modal.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:empylo_app/models/audience.dart';

typedef AudienceCallback = Function(Audience audience);

final audienceNameProvider = StateProvider<String>((ref) => '');
final audienceDescriptionProvider = StateProvider<String>((ref) => '');
final audienceTypeProvider = StateProvider<String>((ref) => 'all');

