# Technical documentation

### The application is written in [Dart](https://dart.dev/) and uses the [Flutter framework](https://flutter.dev/), which is used for building cross-platform applications.

---

### Development and building the app

1. Set up your preferred development environment for Dart and Flutter (e.g. using [flutter docs](https://docs.flutter.dev/get-started/install)).
2. To develop the app, open the [`media_literacy_app`](/media_literacy_app/) folder in your IDE and either:
   - use the IDE to run the app, or
   - run `flutter run` in the termnial
3. To build the app run the following command in the [`media_literacy_app`](/media_literacy_app/) folder:
   - Android: `flutter build apk` or `flutter build appbundle`
   - iOS: `flutter build ipa`

---

### App entry point

**Related files:**
- [`lib/main.dart`](/media_literacy_app/lib/main.dart)


### App loads modules data from a JSON api and uses the response to build the interactive chat-like modules.

When the app is launched the splash screen is displayed the app makes a JSON api request to download the required assets via the `AppStorage` class in file [`app_storage.dart`](/media_literacy_app/lib/state/app_storage.dart)

**Related files:**
- [`lib/state/app_state.dart`](/media_literacy_app/lib/state/app_state.dart)
- [`lib/state/app_storage.dart`](/media_literacy_app/lib/state/app_storage.dart)

---

`_loadStoryIds` response example:

```json
{
  "data": [
    {
      "_id": "99ee094be6814ff0bbad97a7",
      "name": "Mislimetar modules",
      "description": "",
      "poster": {
        "url": "https://example.com/thumbnail1.png"
      }
    },
    {
      "_id": "02c908e5013a4b38a532f525",
      "name": "Secondary modules",
      "description": "",
      "poster": {
        "url": "https://example.com/thumbnail2.png"
      }
    }
  ]
}
```

For each `_id` in the `data` array recieved the app then downloads the required bundle info.

---

`_loadStoryBundleInfo` response example:

```json
{
  "data": {
    "name": "Mislimetar modules",
    "bundle": {
      "timeCreated": "2023-09-05T09:20:01.785Z",
      "_id": "fad94b7055b845d499d6aff1",
      "storyId": "99ee094be6814ff0bbad97a7",
      "remote": "bundle1.zip",
      "url": "https://example.com/bundle1.zip",
      "size": 23600128
    }
  }
}
```

The bundle zip file is then downloaded and extracted.

The contents of the bundle file include the `story.json` and all related image assets:
- `story-<story_id>.json` (e.g. `story-99ee094be6814ff0bbad97a7.json`)
- image files and thumbnails for each image:
  - `<image_uuid>.png` (e.g. `9518bdfa-efb5-481b-9dca-3a693bfe39a5.png`)
  - optionally `thumb-<image_uuid>.png`
  - optionally `mini-thumb-<image_uuid>.png`


---

### Loading the module data

When all the assets have been downloaded and extracted the app loads the data from the `story.json` file via the [`models/story.dart`](/media_literacy_app/lib/models/story.dart) file to display the modules on screen.

**Related files:**
- [`lib/models/story.dart`](/media_literacy_app/lib/models/story.dart)

---

`story.json` content example:

```json
{
  "timeCreated": "2022-03-09T12:08:50.378Z",
  "_id": "61c31d6dfb3f79442dd89099",
  "name": "Branch testing",
  "description": "",
  "poster": {
    "_id": "61c31ebcfb3f79442dd89ef0",
    "width": 1152,
    "height": 788,
    "url": "https://example.com/image1.jpg",
    "miniThumbUrl": "https://example.com/mini-thumb-image1.jpg",
    "remote": "image1.jpg"
  },
  "chats": [
    <list of chats>
  ],
  "actors": [
    <list of actors>
  ]
}
```

`Actor` json object example:

```json
{
  "_id": "633c51dec2437c3f1ff96828",
  "name": "Hana",
  "avatar": {
    "_id": "635b9984c2437c3f1fece9c1",
    "width": 285,
    "height": 285,
    "url": "https://example.com/image2.jpg",
    "miniThumbUrl": "https://example.com/mini-thumb-image2.jpg",
    "remote": "image2.jpg"
  }
}
```

`Chat` json object example:

```json
{
  "_id": "61c31d6dfb3f79442dd8909d",
  "title": "Prologue quest",
  "description": "",
  "isMainChat": true,
  "isLocked": false,
  "threads": [
    <list of threads>
  ],
  "poster": {
    "_id": "61c31d92fb3f79442dd8930e",
    "width": 1152,
    "height": 788,
    "url": "https://example.com/image3.jpg",
    "miniThumbUrl": "https://example.com/mini-thumb-image3.jpg",
    "remote": "image3.jpg"
  }
}
```

`Thread` json object example:

```json
{
  "_id": "61c31d6dfb3f79442dd8909f",
  "name": "Main thread",
  "messages": [
    <list of messages>
  ]
}
```

`Message` json object example:

```json
{
  "_id": "61c31df2fb3f79442dd8931b",
  "type": "TEXT",
  "text": "Let's start here.",
  "actor": "NARRATOR",
  "file": {
    "_id": "62d80a79c2437c3f1f004c8f",
    "width": 1024,
    "height": 1366,
    "url": "https://example.com/image4.jpg",
    "miniThumbUrl": "https://example.com/mini-thumb-image4.jpg",
    "remote": "image4.jpg"
  },
  "youtubeId": "",
  "youtubeThumbUrl": "",
  "youtubeTitle": "",
  "actionOptions": {},
  "response": {
    "_id": "61c31df2fb3f79442dd8931c",
    "type": "NO_RESPONSE",
    "confirmText": "Continue",
    "options": [],
    "photoOptions": []
  }
}
```

For more `Chat`, `Thread`, and `Message` examples see here:

**[More `story.json` examples](/media_literacy_app/assets/stories/)**
