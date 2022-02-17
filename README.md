## Overview

This is the way I used to parse generic response object with `dio` package.

## Concept

- **APIRoute:** Manage all information about your API (url, method, headers,...)
- **APIResponse:** Response objects used to wrap your API response structure.
- **APIClient:** Construct to wrap http request with APIRoute, APIResponse.
- **Decodable:** Interface with `decodable` func. Every object must be **implements** it to use with APIRoute.

Problem with Generic in Flutter is with `T` , we can not call any functions belong to this generic object. So, we can not convert it from json to object. Example:

Let's we have class User, APIClient (http request base class)

```dart
class User {
  User.fromJson(Map<String, dynamic> json) {
    // map json object with user props
  }
}

class APIClient {
   static Future<T> request<T>() {
     // make http request
     // get response
     // use response to parse from json to object T

     // problem: we can not call T.fromJson in here. Because Dart don't know what exactly is T object.
   }
}
```

To resolve this problem, I created a typedef function. And pass it as property to a class where we need to use generic object

```dart
typedef Create<T> = T Function();
```

```dart
abstract class Decodable<T> {
  T decode(dynamic data);
}

abstract class GenericObject<T> {

  // define a typedef with Decodable object
  Create<Decodable> create;

  // init object with create param
  GenericObject({ this.create });

  T genericObject(dynamic data) {
    // get create object
    final item = create();
    // now, we can call decode func from Decodable class
    return item.decode(data);
  }

}
```

## Usage

Example: We have json:

```json
{
  "status": true,
  "data": {
    "name": "Phong Cao"
  }
}
```

1. Define a APIReponse to wrap this json structure

```dart
class APIResponse<T> extends GenericObject<T>
  implements Decodable<APIResponse<T>> {

  String status;
  T data;

  APIResponse({ Create<Decodable> create }) : super(create: create);

  @override
  APIResponse<T> decode(dynamic json) {
    status = json['status'];
    data = genericObject(json['data']);
    return this;
  }

}
```

**GenericObject:** Abstract wrapper class, it will wrap `Decodable` object, parse json response to object `T`, and return `T`.

I implements `Decodable` to override `decode` function. So that, we can parse `APIResponse` in `ResponseWrapper` class (ResponseWrapper is a class used to detect Success/Error response, logic in this class is same as APIResponse)

2. Define user class

```dart
class User implements Decodable<User> {

  String name;

  @override
  User decode(dynamic json) {
    name = json['name'];
    return this;
  }
}
```

3. Make a request with APIClient

```dart
Future<User> fetchUser() async {

    final client = APIClient();

    final result = await client.request(
      manager: APIRoute(APIType.getUser),
      create: () => APIResponse<User>(create: () => User())
    );

    final user = result.response.data; // reponse.data will map with User

    if (user != null) {
      return user;
    }

    throw ErrorResponse(message: 'User not found');

}
```

That's it! You can download my project and try `Employee` example to understand it clearly.

Thanks!
