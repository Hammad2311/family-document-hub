import 'package:family_document_hub/features/admin/presentation/admin_dashboard_preview.dart';
import 'package:family_document_hub/features/admin/presentation/member_management_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void setLargeTestViewport(WidgetTester tester) {
  tester.view.physicalSize = const Size(1280, 1000);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

void main() {
  testWidgets('sidebar switches between mock dashboard screens', (
    tester,
  ) async {
    setLargeTestViewport(tester);

    await tester.pumpWidget(const MaterialApp(home: AdminDashboardPreview()));

    expect(find.text('Family overview'), findsOneWidget);
    expect(find.text('MOCK DATA ONLY'), findsOneWidget);

    await tester.tap(find.text('Members').first);
    await tester.pumpAndSettle();
    expect(find.text('Aarav Sample'), findsOneWidget);
    expect(find.byKey(const ValueKey('add-member-button')), findsOneWidget);

    await tester.tap(find.text('Documents').first);
    await tester.pumpAndSettle();
    expect(find.text('Aadhaar_Sample_Member.pdf'), findsOneWidget);

    await tester.tap(find.text('Categories').first);
    await tester.pumpAndSettle();
    expect(find.text('Driving Licence'), findsOneWidget);

    await tester.tap(find.text('Storage').first);
    await tester.pumpAndSettle();
    expect(find.text('Quota overview'), findsOneWidget);

    await tester.tap(find.text('Audit activity').first);
    await tester.pumpAndSettle();
    expect(find.text('PDF uploaded'), findsOneWidget);

    await tester.tap(find.text('Overview').first);
    await tester.pumpAndSettle();
    expect(find.text('Family overview'), findsOneWidget);
  });

  testWidgets('member preview supports add, disable, and remove', (
    tester,
  ) async {
    setLargeTestViewport(tester);

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(child: MemberManagementPreview()),
        ),
      ),
    );

    expect(find.text('8 of 10 members'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('add-member-button')));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const ValueKey('new-member-name')),
      'Test Member',
    );
    await tester.tap(find.text('Add'));
    await tester.pumpAndSettle();

    expect(find.text('9 of 10 members'), findsOneWidget);
    expect(find.text('Test Member'), findsOneWidget);

    final statusKey = const ValueKey('member-status-Test Member');
    var status = tester.widget<Text>(find.byKey(statusKey));
    expect(status.data, 'Member · Active');

    await tester.tap(find.byKey(const ValueKey('member-actions-Test Member')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Disable member'));
    await tester.pumpAndSettle();

    status = tester.widget<Text>(find.byKey(statusKey));
    expect(status.data, 'Member · Disabled');

    await tester.tap(find.byKey(const ValueKey('member-actions-Test Member')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Remove member'));
    await tester.pumpAndSettle();

    expect(find.text('Remove sample member?'), findsOneWidget);
    await tester.tap(find.widgetWithText(FilledButton, 'Remove'));
    await tester.pumpAndSettle();

    expect(find.text('Test Member'), findsNothing);
    expect(find.text('8 of 10 members'), findsOneWidget);
  });
}
