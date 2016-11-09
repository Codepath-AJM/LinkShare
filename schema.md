---
title: LinkShare Schema
---


### Firebase Schema

```graphql
protocol Shareable {
  uniqueID: String!
  authorID: String!
  comments: [Comment]?
  userIDs: [String]!
  # These dates may need to be stored as Strings or Ints and converted back and forth
  modifiedDate: Date!
  lastReadDate: [User.uniqueID: Date]?
}
```
```graphql
type Comment {
  uniqueID: String!
  body: String!
  authorId: String!
  # Date may need to be a more primitive data type
  createdAt: Date!
}
```
```graphql
type Link implements Shareable  {
  url: String!
  title: String?
}
```
```graphql
enum FriendshipStatus {
  case friends
  case pending
  case none
}
```
```graphql
type Friend {
   fromUserID: String!
   toUserID: String!
   Status: FriendshipStatus!
}
```
```graphql
type Bookmarkable {
   shareableID: String!
   userID: String!
}
```
```graphql
type User {
  uniqueID: String!
  email: String!
  password: String!
  name: String?
  imageURL: String?
}
```

### Application-specific schema

```graphql
type ShareNotification {
  shareableID: String!
}
```
```graphql
type CommentNotification {
  shareableID: String!
  commentID: String!
}
```

### Optional territory
Things we’re thinking about if everything else is finished

```
type Image {
  imageData: _?
  title: String?
}
```

Archived items?
