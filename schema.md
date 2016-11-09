#### Firebase Schema

```
protocol Shareable {
  uniqueID: String!
  authorID: String!
  comments: [Comment]?
  userIDs: [String]!
  modifiedDate: Date!
  lastReadDate: [User.uniqueID: Date]?
}
```
```
type Comment {
  uniqueID: String!
  body: String!
  authorId: String!
  createdAt: Date!
}
```
```
type Link implements Shareable  {
  url: String!
  title: String?
}
```
```
enum FriendshipStatus {
  case friends
  case pending
  case none
}
```
```
type Friend {
   fromUserID: String!
   toUserID: String!
   Status: FriendshipStatus!
}
```
```
type Bookmarkable {
   shareableID: String!
   userID: String!
}
```
```
type User {
  uniqueID: String!
  email: String!
  password: String!
  name: String?
  imageURL: String?
}
```

#### Application-specific schema

```
type ShareNotification {
  shareableID: String!
}
```
```
type CommentNotification {
  shareableID: String!
  commentID: String!
}
```

#### Optional territory
Things we’re thinking about if everything else is finished

```
type Image {
  imageData: _?
  title: String?
}
```

Archived items?
