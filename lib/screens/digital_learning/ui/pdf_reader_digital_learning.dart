import 'package:flutter/material.dart';

import 'package:flutter_pdfview/flutter_pdfview.dart';


import '../../../models/digital_learning/digital_learning_item.dart';
import '../../../reusable_widgets/scaffold_widgets/appbar.dart';
import '../../../services/asset_download/asset_download_service.dart';

class PdfReaderDigitalLearningUI extends StatefulWidget {
  static const routeName = '/pdfDigitalLearning';
  final String file;
  final DigitalLearningItem item;
  final bool? skip;

  const PdfReaderDigitalLearningUI({Key? key, required this.item, required this.file, this.skip}) : super(key: key);

  @override
  _PdfReaderDigitalLearningUIState createState() => _PdfReaderDigitalLearningUIState();
}

class _PdfReaderDigitalLearningUIState extends State<PdfReaderDigitalLearningUI> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    DigitalLearningItem av = widget.item;

    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, true);
        return false;
      },
      child: Scaffold(
        appBar: CustomAppBar(
          title: "Digital Learning",
          titleImage: "digital_learning.png",
          onLeadingIconPressed: () {
            Navigator.pop(context, true);
          },
          actions: [
            IconButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              icon: Icon(
                Icons.close_rounded,
                color: Colors.white,
              ),
            )
          ],
        ),
        body: FutureBuilder(
            future: AssetDownloadService(context).getBasePath(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData && snapshot.data != null) {
                  return PDFView(
                    filePath: '${snapshot.data}/digital_learning/${widget.file}',
                    enableSwipe: true,
                    swipeHorizontal: true,
                    autoSpacing: false,
                    pageFling: false,
                  );
                } else {
                  return SizedBox();
                }
              }
              return SizedBox();
            }),
      ),
    );
  }
}
