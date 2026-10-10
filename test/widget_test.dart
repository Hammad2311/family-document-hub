import 'package:flutter_test/flutter_test.dart';
import 'package:family_document_hub/main.dart';

void main() {
  testWidgets(
    'shows the Supabase connection screen',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const FamilyDocumentHubApp(
          isSupabaseConfigured: false,
        ),
      );

      expect(
        find.text('Family Document Hub'),
        findsOneWidget,
      );

      expect(
        find.text('Supabase Connection Check'),
        findsOneWidget,
      );

      expect(
        find.text('Configuration is missing.'),
        findsOneWidget,
      );
    },
  );
}