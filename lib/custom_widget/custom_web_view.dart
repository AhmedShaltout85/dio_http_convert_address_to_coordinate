import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CustomWebView extends StatefulWidget {
  final String url;
  final String? title;

  const CustomWebView({
    super.key,
    required this.url,
    this.title,
  });

  @override
  State<CustomWebView> createState() => _CustomWebViewState();
}

class _CustomWebViewState extends State<CustomWebView> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            setState(() {
              _isLoading = true;
            });
          },
          onPageFinished: (url) {
            setState(() {
              _isLoading = false;
            });
          },
          onNavigationRequest: (request) {
            // Handle navigation decisions if needed
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? 'Web View'),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}


// 3. Use the Custom WebView Class
// You can navigate to the CustomWebView screen wherever needed. Here's an example:

// import 'package:flutter/material.dart';
// import 'custom_web_view.dart';

// class MainScreen extends StatelessWidget {
//   const MainScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Main Screen'),
//       ),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => const CustomWebView(
//                   url: 'https://example.com',
//                   title: 'Example Website',
//                 ),
//               ),
//             );
//           },
//           child: const Text('Open WebView'),
//         ),
//       ),
//     );
//   }
// }


// Usage 
// You can now display a WebView by:

// Instantiating a WebViewController.
// controller = WebViewController()
//   ..setJavaScriptMode(JavaScriptMode.unrestricted)
//   ..setNavigationDelegate(
//     NavigationDelegate(
//       onProgress: (int progress) {
//         // Update loading bar.
//       },
//       onPageStarted: (String url) {},
//       onPageFinished: (String url) {},
//       onHttpError: (HttpResponseError error) {},
//       onWebResourceError: (WebResourceError error) {},
//       onNavigationRequest: (NavigationRequest request) {
//         if (request.url.startsWith('https://www.youtube.com/')) {
//           return NavigationDecision.prevent;
//         }
//         return NavigationDecision.navigate;
//       },
//     ),
//   )
//   ..loadRequest(Uri.parse('https://flutter.dev'));
// Passing the controller to a WebViewWidget.
// @override
// Widget build(BuildContext context) {
//   return Scaffold(
//     appBar: AppBar(title: const Text('Flutter Simple Example')),
//     body: WebViewWidget(controller: controller),
//   );
// }
// See the Dartdocs for WebViewController and WebViewWidget for more details.

// Android Platform Views 
// This plugin uses Platform Views to embed the Android's WebView within the Flutter app.

// You should however make sure to set the correct minSdkVersion in android/app/build.gradle if it was previously lower than 19:

// android {
//     defaultConfig {
//         minSdkVersion 19
//     }
// }