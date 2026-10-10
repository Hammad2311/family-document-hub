import 'package:family_document_hub/features/admin/presentation/document_management_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Future<void> pumpDocumentPreview(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1000, 1000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(child: DocumentManagementPreview()),
        ),
      ),
    );
  }

  testWidgets('valid mock PDF upload adds a preview record', (tester) async {
    await pumpDocumentPreview(tester);

    expect(find.text('3 sample documents'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('upload-document-button')));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const ValueKey('upload-file-name')),
      'Passport_Test_Member.pdf',
    );
    await tester.enterText(
      find.byKey(const ValueKey('upload-size-mib')),
      '2.5',
    );
    await tester.tap(find.byKey(const ValueKey('confirm-mock-upload')));
    await tester.pumpAndSettle();

    expect(find.text('4 sample documents'), findsOneWidget);
    expect(find.text('Passport_Test_Member.pdf'), findsOneWidget);
    expect(find.text('Aarav Sample · Aadhaar'), findsOneWidget);
    expect(find.text('2.5 MiB'), findsOneWidget);
    expect(find.textContaining('No file was uploaded.'), findsOneWidget);
  });

  testWidgets('mock upload rejects non-PDF files and sizes above 10 MiB', (
    tester,
  ) async {
    await pumpDocumentPreview(tester);

    await tester.tap(find.byKey(const ValueKey('upload-document-button')));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const ValueKey('upload-file-name')),
      'not-a-pdf.txt',
    );
    await tester.tap(find.byKey(const ValueKey('confirm-mock-upload')));
    await tester.pumpAndSettle();
    expect(find.text('Filename must end in .pdf.'), findsOneWidget);

    await tester.enterText(
      find.byKey(const ValueKey('upload-file-name')),
      'Too_Big.pdf',
    );
    await tester.enterText(
      find.byKey(const ValueKey('upload-size-mib')),
      '10.1',
    );
    await tester.tap(find.byKey(const ValueKey('confirm-mock-upload')));
    await tester.pumpAndSettle();

    expect(find.text('Maximum PDF size is 10 MiB.'), findsOneWidget);
    expect(find.text('3 sample documents'), findsOneWidget);
  });
}
