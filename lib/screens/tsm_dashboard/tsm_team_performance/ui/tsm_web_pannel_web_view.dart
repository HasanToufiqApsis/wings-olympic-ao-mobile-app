import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:wings_olympic_sr/constants/dashboard_btn_names.dart';

import '../../../../api/links.dart';
import '../../../../reusable_widgets/language_textbox.dart';

class TsmWebPannelWebView extends StatefulWidget {
  static const routeName = "TsmWebPannelWebView";

  const TsmWebPannelWebView({super.key});

  @override
  State<TsmWebPannelWebView> createState() => _TsmWebPannelWebViewState();
}

class _TsmWebPannelWebViewState extends State<TsmWebPannelWebView> {
  final _appBarTitle = DashboardBtnNames.webPanel;
  final controller = WebViewController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Hero(
          tag: _appBarTitle,
          child: LangText(
            _appBarTitle,
          ),
        ),
        centerTitle: true,
      ),
      body: WebViewWidget(
        controller: controller
          ..clearCache()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setBackgroundColor(const Color(0x00000000))
          ..setNavigationDelegate(
            NavigationDelegate(
              onProgress: (int progress) {
                // Update loading bar.
              },
              onPageStarted: (String url) {},
              onPageFinished: (String url) {},
              onWebResourceError: (WebResourceError error) {},
              onNavigationRequest: (NavigationRequest request) {
                return NavigationDecision.navigate;
              },
            ),
          )
          ..loadRequest(Uri.parse(Links.baseUrl)),
      ),
    );
  }
}
