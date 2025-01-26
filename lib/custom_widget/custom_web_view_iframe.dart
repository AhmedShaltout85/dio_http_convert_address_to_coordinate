
// ignore_for_file: use_key_in_widget_constructors

import 'dart:html';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class IframeScreen extends StatefulWidget {
    final String url;

  const IframeScreen({super.key, required this.url});

  @override
  State<IframeScreen> createState() {
    return _IframeScreenState();
  }
}

class _IframeScreenState extends State<IframeScreen> {
  final IFrameElement _iFrameElement = IFrameElement();

  @override
  void initState() {
    // _iFrameElement.style.height = '80%';
    // _iFrameElement.style.width = '80%';
    // _iFrameElement.src = 'https://flutter.dev/';
    // _iFrameElement.src = 'http://196.219.231.3:8000/lab-api/lab-marker/24';
    _iFrameElement.style.height = '100%';
    _iFrameElement.style.width = '100%';
    _iFrameElement.src = widget.url;
    _iFrameElement.style.border = 'none';

// ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(
      'iframeElement',
      (int viewId) => _iFrameElement,
    );

    super.initState();
  }

  final Widget _iframeWidget = HtmlElementView(
    viewType: 'iframeElement',
    key: UniqueKey(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: _iframeWidget,
            )
          ],
        ),
      ),
    );
  }
}
