import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_firebase_instagram/main.dart' as app;
import 'package:flutter_firebase_instagram/src/presentation/widgets/snackbar.dart';

void test() => group('RESET PASSWORD', () {
  testWidgets('all cases', (tester) async {
    app.main();
    await tester.pumpAndSettle();

    Finder loginResetButton = find.byKey(const Key('login_reset_button'));
    expect(loginResetButton, findsOneWidget);
    await tester.tap(loginResetButton);
    await tester.pumpAndSettle();

    Finder resetPasswordEmailTextField = find.byKey(const Key('reset_password_email_textfield'));
    Finder resetPasswordButton = find.byKey(const Key('reset_password_button'));
    expect(resetPasswordEmailTextField, findsOneWidget);
    expect(resetPasswordButton, findsOneWidget);

    await tester.enterText(resetPasswordEmailTextField, 'nonexistent@gmail.com');
    await tester.pumpAndSettle();
    await tester.tap(resetPasswordButton);
    await tester.pumpAndSettle();
    expect(find.byKey(SnackbarType.error.key), findsOneWidget);
    expect(find.textContaining('user-not-found'), findsOneWidget);
    await tester.pumpAndSettle();

    await tester.enterText(resetPasswordEmailTextField, 'mark.demo@gmail.com');
    await tester.pumpAndSettle();
    await tester.tap(resetPasswordButton);
    await tester.pumpAndSettle();
    expect(find.byKey(SnackbarType.success.key), findsOneWidget);
  });
});