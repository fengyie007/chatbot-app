import 'package:ChatBot/base.dart';
import 'package:ChatBot/base/components/common_dialog.dart';
import 'package:dio/dio.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class VersionCheck {
  factory VersionCheck() => _instance;

  VersionCheck._internal();

  static final VersionCheck _instance = VersionCheck._internal();

  void checkLastedVersion(BuildContext context) async {
    try {
      if (!Platform.isAndroid) return;
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      int currentVersion = int.parse(packageInfo.buildNumber);

      var result = await Dio().get("https://raw.githubusercontent.com/ChatBot-All/chatbot-app/main/version");
      if (result.statusCode == 200) {
        int lastedVersion = int.tryParse(result.data) ?? currentVersion;
        if (lastedVersion > currentVersion) {
          if (context.mounted) {
            showCommonDialog(
              context,
              title: "温馨提示",
              content: "发现新版本，请前往更新",
              confirmText: "去更新",
              confirmCallback: () {
                launchUrl(Uri.parse("https://github.com/ChatBot-All/chatbot-app/releases"));
              },
            );
          }
        }
      }
    } catch (e) {
      e.toString().e();
    }
  }
}