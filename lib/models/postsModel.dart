class Post {
  String id;
  String username;
  String title;
  String content;
  DateTime date;

  Post({
    required this.id,
    required this.username,
    required this.title,
    required this.content,
    required this.date,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['_id'],
      username: json['username'],
      title: json['title'],
      content: json['content'],
      date: DateTime.parse(json['date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'title': title,
      'content': content,
      'date': date.toIso8601String(),
    };
  }
}
