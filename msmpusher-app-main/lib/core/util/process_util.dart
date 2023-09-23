// import 'package:flutter/material.dart';
// import 'package:pdf_edit/domain/entities/entities.dart';
// import 'package:syncfusion_flutter_pdf/pdf.dart';

// class ProcessUtil {
//   static int getContentStartPagenumber(
//       {required Document document, required List<Document> documents}) {
//     // get document-context index in documents
//     final _index = documents.indexWhere((element) => element.id == document.id);

//     // indicates start-page of document-body
//     final _startMarging = 3;

//     if (_index == 0) {
//       // start document index (after tilte and contents page)
//       return _startMarging;
//     }

//     int _previousPageCount = 0;

//     // get all documents before current document-context
//     for (var i = 0; i < _index; i++) {
//       final _singleDocument = documents[i];

//       // get previous documents-page count
//       final _pdfDocument = PdfDocument(inputBytes: _singleDocument.bytes);
//       final _pageCount = _pdfDocument.pages.count;

//       _previousPageCount += _pageCount;
//     }

//     // next page count
//     return _previousPageCount + _startMarging;
//   }

//   static PdfPageTemplateElement createFooterWithPageNumber(PdfPage page) {
//     //Create a footer template and draw a text.
//     final PdfPageTemplateElement footerElement =
//         PdfPageTemplateElement(const Rect.fromLTWH(0, 0, 515, 50), page);

//     footerElement.graphics.setTransparency(0.6);
//     PdfCompositeField(text: 'Page {0} of {1}', fields: <PdfAutomaticField>[
//       PdfPageNumberField(brush: PdfBrushes.black),
//       PdfPageCountField(brush: PdfBrushes.black)
//     ]).draw(footerElement.graphics, const Offset(450, 35));

//     return footerElement;
//   }

//   static PdfLayoutResult addParagraph(
//       PdfPage page, String text, Rect bounds, bool isTitle,
//       {bool mainTitle = false}) {
//     return PdfTextElement(
//             text: text,
//             font: PdfStandardFont(
//                 PdfFontFamily.helvetica,
//                 isTitle
//                     ? mainTitle
//                         ? 24
//                         : 18
//                     : 13,
//                 style: (isTitle && !mainTitle)
//                     ? PdfFontStyle.bold
//                     : PdfFontStyle.regular),
//             format: mainTitle
//                 ? PdfStringFormat(alignment: PdfTextAlignment.center)
//                 : PdfStringFormat(alignment: PdfTextAlignment.justify))
//         .draw(
//             page: page,
//             bounds: Rect.fromLTWH(
//                 bounds.left, bounds.top, bounds.width, bounds.height))!;
//   }

//   static PdfBookmark addBookmark(PdfPage page, String text, Offset point,
//       {PdfDocument? doc, PdfBookmark? bookmark, PdfColor? color}) {
//     PdfBookmark book;
//     if (doc != null) {
//       book = doc.bookmarks.add(text);
//       book.destination = PdfDestination(page, point);
//     } else {
//       book = bookmark!.add(text);
//       book.destination = PdfDestination(page, point);
//     }
//     book.color = color ?? PdfColor(0, 0, 0);
//     return book;
//   }

//   static PdfLayoutResult addTableOfContents({
//     required PdfPage page,
//     required String text,
//     required Rect bounds,
//     required bool isTitle,
//     required int pageNo,
//     required double x,
//     required double y,
//     required PdfPage destPage,
//   }) {
//     final PdfFont font = PdfStandardFont(PdfFontFamily.helvetica, 13,
//         style: isTitle ? PdfFontStyle.bold : PdfFontStyle.regular);

//     if (isTitle) {
//       page.graphics.drawString(pageNo.toString(), font,
//           bounds:
//               Rect.fromLTWH(480, bounds.top + 5, bounds.width, bounds.height));
//     }

//     final PdfDocumentLinkAnnotation annotation = PdfDocumentLinkAnnotation(
//       Rect.fromLTWH(isTitle ? bounds.left : bounds.left + 20, bounds.top - 45,
//           isTitle ? bounds.width : bounds.width - 20, font.height),
//       PdfDestination(destPage, Offset(x, y)),
//     );

//     annotation.border.width = 0;

//     page.annotations.add(annotation);

//     String str = text + ' ';
//     final num value = isTitle
//         ? font.measureString(text).width.round() + 20
//         : font.measureString(text).width.round() + 40;
//     for (num i = value; i < 470;) {
//       str = str + '.';
//       i = i + 3.6140000000000003;
//     }
//     return PdfTextElement(text: str, font: font).draw(
//         page: page,
//         bounds: Rect.fromLTWH(isTitle ? bounds.left : bounds.left + 20,
//             bounds.top + 5, bounds.width, bounds.height))!;
//   }
// }
