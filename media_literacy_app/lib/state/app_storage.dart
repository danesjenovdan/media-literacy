import 'dart:convert';
import 'dart:io';
import 'package:archive/archive_io.dart';
import 'package:http/http.dart' as http;
import 'package:media_literacy_app/models/story.dart';
import 'package:path_provider/path_provider.dart';

class AppStorage {
  Map<String, Story> stories = {};

  Future<Directory> get _storiesStorageFolder async {
    final Directory folder = await getApplicationDocumentsDirectory();
    final Directory storageFolder = Directory('${folder.path}/stories_storage');
    await storageFolder.create(recursive: true);
    return storageFolder;
  }

  Future<File> get _storiesFile async {
    final Directory folder = await _storiesStorageFolder;
    return File('${folder.path}/stories.json');
  }

  Future<Directory> _storyFolder(String storyId) async {
    final Directory folder = await _storiesStorageFolder;
    final Directory storyFolder = Directory('${folder.path}/$storyId');
    await storyFolder.create(recursive: true);
    return storyFolder;
  }

  Future<File> _bundleInfoFile(String storyId) async {
    final Directory folder = await _storyFolder(storyId);
    return File('${folder.path}/bundleInfo.json');
  }

  Future<File> _bundleZipFile(String storyId, String zipName) async {
    final Directory folder = await _storyFolder(storyId);
    return File('${folder.path}/$zipName');
  }

  Future<Directory> _bundleExtractedFolder(String storyId, String zipName) async {
    final Directory folder = await _storyFolder(storyId);
    final String zipFolderName = zipName.replaceAll(RegExp(r"\.zip$"), "");
    final Directory extractedFolder = Directory('${folder.path}/$zipFolderName');
    await extractedFolder.create(recursive: true);
    return extractedFolder;
  }

  Future<File> _bundleExtractedFile(String storyId, String zipName, String fileName) async {
    final Directory folder = await _bundleExtractedFolder(storyId, zipName);
    return File('${folder.path}/$fileName');
  }

  Future<File> _bundleStoryJsonFile(String storyId, Directory folder) async {
    return File('${folder.path}/story-$storyId.json');
  }

  Future<void> clear() async {
    final Directory folder = await _storiesStorageFolder;
    await folder.delete(recursive: true);
  }

  Future<void> init() async {
    stories = await _loadStories();
  }

  Future<Map<String, Story>> _loadStories() async {
    Map<String, Story> stories = {};
    List<String> storyIds = await _loadStoryIds();
    for (String storyId in storyIds) {
      stories[storyId] = await _loadStory(storyId);
    }
    return stories;
  }

  Future<List<String>> _loadStoryIds() async {
    File file = await _storiesFile;

    if (await file.exists()) {
      var jsonData = jsonDecode(await file.readAsString());
      if (jsonData is List) {
        return jsonData.cast<String>();
      }
    }

    String url = "https://api.locogames.live/v1/team/643599b047eb967304f10aff/locale/sr/stories/translations";
    var response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      List<dynamic> stories = jsonData["data"] ?? [];
      List<String> storyIds = stories.map((story) => story["_id"] as String).toList();
      await file.writeAsString(jsonEncode(storyIds));
      return storyIds;
    }

    throw Exception("Failed to load team stories");
  }

  Future<Story> _loadStory(String storyId) async {
    Directory bundleFolder = await _loadStoryBundle(storyId);
    File jsonFile = await _bundleStoryJsonFile(storyId, bundleFolder);

    if (await jsonFile.exists()) {
      return Story.fromJson(jsonDecode(await jsonFile.readAsString()), bundleFolder);
    }

    throw Exception("Failed to load story json");
  }

  Future<Directory> _loadStoryBundle(String storyId) async {
    var bundleInfo = await _loadStoryBundleInfo(storyId);

    String zipName = bundleInfo["data"]["bundle"]["remote"];
    int zipSize = bundleInfo["data"]["bundle"]["size"];
    File zipFile = await _bundleZipFile(storyId, zipName);
    Directory zipFolder = await _bundleExtractedFolder(storyId, zipName);

    if (await zipFile.exists() && await zipFile.length() == zipSize) {
      if (await zipFolder.exists() && !await zipFolder.list().isEmpty) {
        return zipFolder;
      }
    }

    String url = bundleInfo["data"]["bundle"]["url"];
    var response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      Archive archive = ZipDecoder().decodeBytes(response.bodyBytes);
      for (ArchiveFile file in archive) {
        if (file.isFile) {
          File extractedFile = await _bundleExtractedFile(storyId, zipName, file.name);
          await extractedFile.writeAsBytes(file.content);
        }
      }
      await zipFile.writeAsBytes(response.bodyBytes);
      return zipFolder;
    }

    throw Exception("Failed to load story bundle zip");
  }

  Future<dynamic> _loadStoryBundleInfo(String storyId) async {
    File file = await _bundleInfoFile(storyId);

    if (await file.exists()) {
      var jsonData = jsonDecode(await file.readAsString());
      return jsonData;
    }

    String url = "https://api.locogames.live/v1/story/$storyId/bundleInfo";
    var response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      await file.writeAsString(response.body);
      return jsonData;
    }

    throw Exception("Failed to load story bundle info");
  }
}

// Future<List<String>> _loadLocalStoryIds() async {
//   Map<String, dynamic> assets = jsonDecode(await rootBundle.loadString('AssetManifest.json'));
//   var storyIdRegex = RegExp(r'stories/story-([0-9a-f]+)\.json$');
//   return assets.keys.map((key) => storyIdRegex.firstMatch(key)?.group(1) ?? '').where((key) => key.isNotEmpty).toList();
// }

// Future<Story> _loadLocalStory(String storyId) async {
//   String data = await rootBundle.loadString("assets/stories/story-$storyId.json");
//   return Story.fromJson(jsonDecode(data));
// // }

// Future _loadLocalStories() async {
//   stories = {};
//   var storyIds = await _loadLocalStoryIds();
//   for (var storyId in storyIds) {
//     stories[storyId] = await _loadLocalStory(storyId);
//   }
// }
