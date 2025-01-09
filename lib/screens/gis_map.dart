import 'package:flutter/material.dart';

import '../custom_widget/custom_browser_redirect.dart';
import '../custom_widget/custom_web_view.dart';

class GisMap extends StatelessWidget {
  const GisMap({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GIS Map'),
      ),
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          ElevatedButton(
            child: const Text('Open GIS Map IN Browser'),
            onPressed: () {
              const url = 'http://196.219.231.3:8000/lab-api/lab-marker/24';
              // const url = 'https://www.google.com/';
              CustomBrowserRedirect.openInBrowser(url); // Open in browser
            },
          ),
          ElevatedButton(
            child: const Text('Open GIS Map IN WebView'),
            onPressed: () {
              const url = 'http://196.219.231.3:8000/lab-api/lab-marker/24';
              // const url = 'https://www.google.com/';
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CustomWebView(
                          title: 'GIS Map webview', url: url)));
            },
          ),
        ]),
      ),
    );
  }
}
