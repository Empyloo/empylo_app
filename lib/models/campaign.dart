class Campaign {
  final String? id;
  final String name;
  final int count;
  final int threshold;
  final String status;
  final String companyId;
  final String createdBy;
  final DateTime nextRunTime;
  final String? type;
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
    this.id,
    this.type,
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
    return Campaign(
      id: json['id'],
      name: json['name'],
      count: json['count'],
      threshold: json['threshold'],
      status: json['status'],
      companyId: json['company_id'],
      createdBy: json['created_by'],
      nextRunTime: DateTime.parse(json['next_run_time']),
      type: json['type'],
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
  }

  Map<String, dynamic> toJson() {
    return {
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
      'frequency': frequency,
      'time_of_day': timeOfDay,
      'description': description,
      'audience_ids': audienceIds,
      'questionnaire_ids': questionnaireIds,
      'cloud_task_id': cloudTaskId,
    };
  }
}
