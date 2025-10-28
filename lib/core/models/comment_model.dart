class CommentModel {
  final String id;
  final String text;
  final DateTime createdAt;
  final String postId;
  final String uid;
  final String username;
  final String profile;
  CommentModel({
    required this.id,
    required this.text,
    required this.createdAt,
    required this.postId,
    required this.uid,
    required this.username,
    required this.profile,
  });

  CommentModel copyWith({
    String? id,
    String? text,
    DateTime? createdAt,
    String? postId,
    String? uid,
    String? username,
    String? profile,
  }) {
    return CommentModel(
      id: id ?? this.id,
      text: text ?? this.text,
      createdAt: createdAt ?? this.createdAt,
      postId: postId ?? this.postId,
      uid: uid ?? this.uid,
      username: username ?? this.username,
      profile: profile ?? this.profile,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'postId': postId,
      'uid': uid,
      'username': username,
      'profile': profile,
    };
  }

  factory CommentModel.fromMap(Map<String, dynamic> map) {
    return CommentModel(
      id: map['id'] ?? '',
      text: map['text'] ?? '',
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      postId: map['postId'] ?? '',
      uid: map['uid'] ?? '',
      username: map['username'] ?? '',
      profile: map['profile'] ?? '',
    );
  }

  @override
  String toString() {
    return 'Comment(id: $id, text: $text, createdAt: $createdAt, postId: $postId, uid: $uid, username: $username, profile: $profile)';
  }
}
