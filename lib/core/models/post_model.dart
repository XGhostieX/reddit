class PostModel {
  final String id;
  final String title;
  final String? description;
  final String? image;
  final String? link;
  final String communityName;
  final String communityAvatar;
  final List<String> upvotes;
  final List<String> downvotes;
  final int commentCount;
  final String username;
  final String uid;
  final DateTime createdAt;
  final List<String> awards;
  PostModel({
    required this.id,
    required this.title,
    this.description,
    this.image,
    this.link,
    required this.communityName,
    required this.communityAvatar,
    required this.upvotes,
    required this.downvotes,
    required this.commentCount,
    required this.username,
    required this.uid,
    required this.createdAt,
    required this.awards,
  });

  PostModel copyWith({
    String? id,
    String? title,
    String? description,
    String? image,
    String? link,
    String? communityName,
    String? communityAvatar,
    List<String>? upvotes,
    List<String>? downvotes,
    int? commentCount,
    String? username,
    String? uid,
    DateTime? createdAt,
    List<String>? awards,
  }) {
    return PostModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      image: image ?? this.image,
      link: link ?? this.link,
      communityName: communityName ?? this.communityName,
      communityAvatar: communityAvatar ?? this.communityAvatar,
      upvotes: upvotes ?? this.upvotes,
      downvotes: downvotes ?? this.downvotes,
      commentCount: commentCount ?? this.commentCount,
      username: username ?? this.username,
      uid: uid ?? this.uid,
      createdAt: createdAt ?? this.createdAt,
      awards: awards ?? this.awards,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'image': image,
      'link': link,
      'communityName': communityName,
      'communityAvatar': communityAvatar,
      'upvotes': upvotes,
      'downvotes': downvotes,
      'commentCount': commentCount,
      'username': username,
      'uid': uid,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'awards': awards,
    };
  }

  factory PostModel.fromMap(Map<String, dynamic> map) {
    return PostModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'],
      image: map['image'] ?? '',
      link: map['link'],
      communityName: map['communityName'] ?? '',
      communityAvatar: map['communityAvatar'] ?? '',
      upvotes: List<String>.from(map['upvotes']),
      downvotes: List<String>.from(map['downvotes']),
      commentCount: map['commentCount']?.toInt() ?? 0,
      username: map['username'] ?? '',
      uid: map['uid'] ?? '',
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      awards: List<String>.from(map['awards']),
    );
  }

  @override
  String toString() {
    return 'Post(id: $id, title: $title, link: $link, description: $description, communityName: $communityName, communityAvatar: $communityAvatar, upvotes: $upvotes, downvotes: $downvotes, commentCount: $commentCount, username: $username, uid: $uid, image: $image, createdAt: $createdAt, awards: $awards)';
  }
}
