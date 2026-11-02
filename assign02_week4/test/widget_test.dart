import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:assign02_week4/main.dart';

void main() {
  testWidgets('LibraryApp smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const LibraryApp());

    expect(find.byType(BottomNavigationBar), findsOneWidget);
    expect(find.text('Quản lý'), findsWidgets);
    expect(find.text('DS Sách'), findsOneWidget);
  });
}
