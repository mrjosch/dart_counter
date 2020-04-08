class User {

  String uid;
  String name;
  String email;
  String photoUrl;


  User(this.uid, this.name, this.email, this.photoUrl);

  @override
  String toString() {
    return 'User{uid: $uid, name: $name, email: $email, photoUrl: $photoUrl}';
  }

}