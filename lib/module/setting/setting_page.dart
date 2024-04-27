import 'package:ChatBot/base.dart';
import 'package:ChatBot/base/providers.dart';
import 'package:ChatBot/base/theme.dart';
import 'package:ChatBot/module/setting/gemini/gemini_list_page.dart';
import 'package:ChatBot/module/setting/gemini/gemini_viewmodel.dart';
import 'package:ChatBot/module/setting/openai/openai_list_page.dart';
import 'package:ChatBot/module/setting/openai/openai_viewmodel.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';


class SettingPage extends ConsumerStatefulWidget {
  const SettingPage({super.key});

  @override
  ConsumerState createState() => _SettingPageState();
}

class _SettingPageState extends ConsumerState<SettingPage> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 1), () async {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String version = packageInfo.version;
      String buildNumber = packageInfo.buildNumber;
      ref.watch(versionProvider.notifier).state = "$version($buildNumber)";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.current.home_setting),
      ),
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.paddingOf(context).bottom + kBottomNavigationBarHeight,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 15,
              ),
              Consumer(builder: (context, ref, _) {
                return SettingWithTitle(
                  label: S.current.openai_setting,
                  widget: SettingItem(
                    iconUrl: 'assets/images/openai.png',
                    title: S.current.openai_setting,
                    count: ref.watch(openAICountProvider),
                    subTitle: S.current.openai_setting_desc,
                  ).click(() {
                    F.push(const OpenAIListPage());
                  }),
                );
              }),
              const SizedBox(
                height: 15,
              ),
              Consumer(builder: (context, ref, _) {
                return SettingWithTitle(
                  label: S.current.gemini_setting,
                  widget: SettingItem(
                    iconUrl: 'assets/images/gemini.png',
                    title: S.current.gemini_setting,
                    count: ref.watch(geminiCountProvider),
                    subTitle: S.current.gemini_setting_desc,
                  ).click(() {
                    F.push(const GeminiListPage());
                  }),
                );
              }),
              const SizedBox(
                height: 25,
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 16,
                  right: 16,
                ),
                child: Text(
                  "其他设置",
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(
                  left: 16,
                  right: 16,
                  top: 8,
                  bottom: 8,
                ),
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 16),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            "自动生成标题",
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                        Consumer(builder: (context, ref, _) {
                          return CupertinoSwitch(
                              value: ref.watch(autoGenerateTitleProvider),
                              onChanged: (v) {
                                ref.read(autoGenerateTitleProvider.notifier).change(v);
                              });
                        }),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 16,
                  right: 16,
                  bottom: 4,
                ),
                child: Text(
                  "开启后会有部分损耗",
                  style: TextStyle(
                    color: ref.watch(themeProvider).timeColor(),
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 16,
                  right: 16,
                ),
                child: Text(
                  "主题设置",
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(
                  left: 16,
                  right: 16,
                  top: 8,
                  bottom: 8,
                ),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 16),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            "主题",
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                        Consumer(builder: (context, ref, _) {
                          var theme = ref.watch(themeProvider);
                          return DropdownButtonHideUnderline(
                            child: DropdownButton2<int>(
                              isDense: true,
                              iconStyleData: IconStyleData(
                                icon: Icon(
                                  CupertinoIcons.chevron_down,
                                  color: Theme.of(context).textTheme.titleSmall?.color,
                                  size: 16,
                                ),
                              ),
                              hint: Text(
                                '请选择',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Theme.of(context).hintColor,
                                ),
                              ),
                              items: [0, 1, 2]
                                  .map((item) => DropdownMenuItem<int>(
                                        alignment: Alignment.center,
                                        value: item,
                                        child: Text(
                                          getNameByThemeType(item),
                                          style: TextStyle(
                                            color: Theme.of(context).textTheme.titleSmall?.color,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ))
                                  .toList(),
                              value: ref.watch(themeProvider.notifier).type.index,
                              onChanged: (int? e) {
                                ref.watch(themeProvider.notifier).change(e ?? 2);
                              },
                              dropdownStyleData: DropdownStyleData(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              buttonStyleData: ButtonStyleData(
                                height: 40,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.transparent,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 16,
                  right: 16,
                  top: 15,
                ),
                child: Text(
                  "反馈",
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(
                  left: 16,
                  right: 16,
                  top: 8,
                  bottom: 8,
                ),
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Card(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                "问题反馈",
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ),
                            Icon(
                              CupertinoIcons.right_chevron,
                              color: Theme.of(context).textTheme.titleSmall?.color,
                              size: 14,
                            ),
                          ],
                        ),
                      ).click(() {
                        launchUrl(Uri.parse("https://github.com/ChatBot-All/chatbot-app"));
                      }),
                      const Divider(
                        indent: 0,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                "Telegram",
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ),
                            Icon(
                              CupertinoIcons.right_chevron,
                              color: Theme.of(context).textTheme.titleSmall?.color,
                              size: 14,
                            ),
                          ],
                        ),
                      ).click(() {
                        launchUrl(Uri.parse("https://t.me/chatbot_all"));
                      }),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 16,
                  right: 16,
                  top: 15,
                ),
                child: Center(
                  child: Consumer(builder: (context, ref, _) {
                    return Text(
                      "版本: ${ref.watch(versionProvider)}",
                      style: Theme.of(context).textTheme.bodySmall,
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String getNameByThemeType(int item) {
    switch (item) {
      case 0:
        return '普通模式';
      case 1:
        return '深色模式';
      case 2:
        return '跟随系统';
      default:
        return '';
    }
  }
}

class SettingWithTitle extends StatelessWidget {
  final String label;
  final Widget widget;

  const SettingWithTitle({super.key, required this.label, required this.widget});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 10),
          widget,
        ],
      ),
    );
  }
}

class SettingItem extends StatelessWidget {
  final String iconUrl;
  final String title;
  final String subTitle;
  final int count;

  const SettingItem({super.key, required this.iconUrl, required this.title, required this.subTitle, this.count = 0});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).cardColor,
      child: Padding(
        padding: const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 50,
              height: 50,
              child: Image.asset(
                iconUrl,
                width: 40,
                height: 40,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Flexible(
                        child: Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                      if (count > 0)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 2),
                          child: Text(
                            " ($count)",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(
                    subTitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 13),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Icon(
              CupertinoIcons.right_chevron,
              color: Theme.of(context).textTheme.titleSmall?.color,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}

final versionProvider = StateProvider<String>((ref) {
  return "";
});