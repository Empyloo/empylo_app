class Job {
  final String id;
  final int? number;
  final String? tag;
  final String? type;
  final String status;
  final String campaignId;

  Job({
    required this.id,
    this.number,
    this.tag,
    this.type,
    required this.status,
    required this.campaignId,
  });

  factory Job.fromJson(Map<String, dynamic> json) {
    return Job(
      id: json['id'] as String,
      number: json['number'] as int?,
      tag: json['tag'] as String?,
      type: json['type'] as String?,
      status: json['status'] as String,
      campaignId: json['campaignId'] as String,
    );
  }
}
