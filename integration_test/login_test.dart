import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_firebase_instagram/main.dart' as app;
import 'package:flutter_firebase_instagram/src/presentation/widgets/snackbar.dart';

void test() => group('LOGIN', () {
  testWidgets('all cases', (tester) async {
    app.main();
    await tester.pumpAndSettle();

    Finder loginEmailTextField = find.byKey(const Key('login_email_textfield'));
    Finder loginPasswordTextField = find.byKey(const Key('login_password_textfield'));
    Finder loginButton = find.byKey(const Key('login_button'));
    Finder errorSnackbar = find.byKey(SnackbarType.error.key);
    expect(loginEmailTextField, findsOneWidget);
    expect(loginPasswordTextField, findsOneWidget);
    expect(loginButton, findsOneWidget);

    await tester.enterText(loginEmailTextField, 'nonexistent@gmail.com');
    await tester.enterText(loginPasswordTextField, 'nonexistent');
    await tester.pumpAndSettle();
    await tester.tap(loginButton);
    await tester.pumpAndSettle();
    expect(errorSnackbar, findsOneWidget);
    expect(find.textContaining('user-not-found'), findsOneWidget);
    await tester.pumpAndSettle();

    await tester.enterText(loginEmailTextField, 'mark.demo@gmail.com');
    await tester.enterText(loginPasswordTextField, 'wrongpassword');
    await tester.pumpAndSettle();
    await tester.tap(loginButton);
    await tester.pumpAndSettle();
    expect(errorSnackbar, findsOneWidget);
    expect(find.textContaining('wrong-password'), findsOneWidget);
    await tester.pumpAndSettle();

    await tester.enterText(loginEmailTextField, 'mark.demo@gmail.com');
    await tester.enterText(loginPasswordTextField, 'demodemo');
    await tester.pumpAndSettle();
    await tester.tap(loginButton);
    await tester.pumpAndSettle();
    expect(errorSnackbar, findsNothing);
    expect(loginEmailTextField, findsNothing);
  });
});