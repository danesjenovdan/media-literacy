# Adding a new language


### Step 1: Create a new `story-<random-id>.json` file

`story-<your-random-id>.json` content example:

```json
{
  "timeCreated": "2022-03-09T12:08:50.378Z",
  "_id": "your-random-id",
  "name": "Your new story",
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

See [Technical documentation](technical.md) for a more in-depth explanation of JSON structures.


### Step 2: Add new `story.json` file to app assest

Add the new json file and add it to [/media_literacy_app/assets/stories/](/media_literacy_app/assets/stories/) folder

There are already some example and testing story json files in that folder that you can use as a reference and remove.


### Step 3: Change which stories are loaded

By default the stories are loaded remotely and saved on the device, but with minimal changes you can load local stories from app assets.

In [`app_storage.dart` on line 121](/media_literacy_app/lib/state/app_storage.dart#L121) file replace the code in `_loadStoryIds()` function that loads the current module ids with code that will load your new local story ids

Example code that will read all local `story.json` file ids in the [stories](/media_literacy_app/assets/stories/) folder:

```dart
Future<List<String>> _loadStoryIds() async {
  Map<String, dynamic> assets = jsonDecode(await rootBundle.loadString('AssetManifest.json'));
  var storyIdRegex = RegExp(r'stories/story-([0-9a-f]+)\.json$');
  return assets.keys.map((key) => storyIdRegex.firstMatch(key)?.group(1) ?? '').where((key) => key.isNotEmpty).toList();
}
```

In [`app_storage.dart` on line 145](/media_literacy_app/lib/state/app_storage.dart#L121) file replace the code in `_loadStory()` function that loads the current story module with code that will load your new local `story.json` file

Example code that will load a local `story.json` file:

```dart
Future<Story> _loadStory(String storyId) async {
  String data = await rootBundle.loadString("assets/stories/story-$storyId.json");
  return Story.fromJson(jsonDecode(data));
}
```


### Step 4: Rebuild the app

See the [Development and building the app](technical.md#development-and-building-the-app) chapter in technical documentation on how to build the app
