class Campaign {
  final String? id;
  final String name;
  final int count;
  final int threshold;
  final String status;
  final String companyId;
  final String createdBy;
  final DateTime nextRunTime;
  final String type;
  final String? duration;
  final DateTime? endDate;
  final String? frequency;
  final String? timeOfDay;
  final String? description;
  final List<String>? audienceIds;
  final List<String>? questionnaireIds;
  final String? cloudTaskId;

  Campaign({
    required this.name,
    required this.count,
    required this.threshold,
    required this.status,
    required this.companyId,
    required this.createdBy,
    required this.nextRunTime,
    required this.type,
    this.id,
    this.duration,
    this.endDate,
    this.frequency,
    this.timeOfDay,
    this.description,
    this.audienceIds,
    this.questionnaireIds,
    this.cloudTaskId,
  });

  factory Campaign.fromJson(Map<String, dynamic> json) {
    try {
      return Campaign(
        id: json['id'] ?? (throw ArgumentError('id cannot be null')),
        name: json['name'] ?? (throw ArgumentError('name cannot be null')),
        count: json['count'] ?? (throw ArgumentError('count cannot be null')),
        threshold: json['threshold'] ??
            (throw ArgumentError('threshold cannot be null')),
        status:
            json['status'] ?? (throw ArgumentError('status cannot be null')),
        companyId: json['company_id'] ??
            (throw ArgumentError('company_id cannot be null')),
        createdBy: json['created_by'] ??
            (throw ArgumentError('created_by cannot be null')),
        nextRunTime: DateTime.parse(json['next_run_time'] ??
            (throw ArgumentError('next_run_time cannot be null'))),
        type: json['type'] ?? (throw ArgumentError('type cannot be null')),
        duration: json['duration'],
        endDate:
            json['end_date'] != null ? DateTime.parse(json['end_date']) : null,
        frequency: json['frequency'],
        timeOfDay: json['time_of_day'],
        description: json['description'],
        audienceIds: json['audience_ids'] != null
            ? List<String>.from(json['audience_ids'])
            : null,
        questionnaireIds: json['questionnaire_ids'] != null
            ? List<String>.from(json['questionnaire_ids'])
            : null,
        cloudTaskId: json['cloud_task_id'],
      );
    } catch (e) {
      throw FormatException('Error parsing Campaign: $e');
    }
  }

  Map<String, dynamic> toJson() {
    try {
      return {
        if (id != null) 'id': id,
        'name': name,
        'count': count,
        'threshold': threshold,
        'status': status,
        'company_id': companyId,
        'created_by': createdBy,
        'next_run_time': nextRunTime.toIso8601String(),
        'type': type,
        'duration': duration,
        'end_date': endDate?.toIso8601String(),
        'frequency': frequency?.toLowerCase(),
        'time_of_day': timeOfDay,
        'description': description,
        'audience_ids': audienceIds,
        'questionnaire_ids': questionnaireIds,
        'cloud_task_id': cloudTaskId,
      };
    } catch (e) {
      throw Exception('Error in toJson: $e');
    }
  }
  
  // This method converts a Campaign object to a Map, without audience_ids
  // and questionnaire_ids
  Map<String, dynamic> toJsonForUpdate() {
    try {
      return {
        if (id != null) 'id': id,
        'name': name,
        'count': count,
        'threshold': threshold,
        'status': status,
        'company_id': companyId,
        'created_by': createdBy,
        'next_run_time': nextRunTime.toIso8601String(),
        'type': type,
        'duration': duration,
        'end_date': endDate?.toIso8601String(),
        'frequency': frequency?.toLowerCase(),
        'time_of_day': timeOfDay,
        'description': description,
        'cloud_task_id': cloudTaskId,
      };
    } catch (e) {
      throw Exception('Error in toJson: $e');
    }
  }
}
