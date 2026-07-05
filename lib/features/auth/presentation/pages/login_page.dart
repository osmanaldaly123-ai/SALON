import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/services/locale_service.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/api_not_configured_banner.dart';
import '../../../../core/widgets/salon_button.dart';
import '../../../../core/widgets/salon_text_field.dart';
import '../../../../l10n/app_localizations.dart';
import '../bloc/auth_bloc.dart';
import '../widgets/auth_feedback.dart';
import '../widgets/auth_scaffold.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    context.read<AuthBloc>().add(
          AuthLoginRequested(
            email: _emailController.text,
            password: _passwordController.text,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (previous, current) =>
          current is AuthAuthenticated ||
          current is AuthGuest ||
          current is AuthFailure,
      listener: (context, state) {
        if (state is AuthAuthenticated || state is AuthGuest) {
          context.go(RouteNames.home);
        } else if (state is AuthFailure) {
          showAuthFeedback(context, state.message);
        }
      },
      child: AuthScaffold(
        title: l10n.welcomeBack,
        subtitle: l10n.welcomeSubtitle,
        topAction: ShadButton.ghost(
          onPressed: () => sl<LocaleService>().toggleLocale(),
          child: Text(l10n.language),
        ),
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            final theme = ShadTheme.of(context);
            final isLoading = state is AuthLoading;
            final errorMessage = state is AuthFailure ? state.message : null;

            return Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const ApiNotConfiguredBanner(),
                  if (buildAuthErrorAlert(context, errorMessage) != null)
                    buildAuthErrorAlert(context, errorMessage)!,
                  SalonTextField(
                    controller: _emailController,
                    label: l10n.email,
                    hint: l10n.emailHint,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    leading: const Icon(LucideIcons.mail, size: 18),
                    validator: Validators.email,
                  ),
                  SalonTextField(
                    controller: _passwordController,
                    label: l10n.password,
                    hint: l10n.passwordHint,
                    textInputAction: TextInputAction.done,
                    obscureText: _obscurePassword,
                    leading: const Icon(LucideIcons.lock, size: 18),
                    trailing: ShadButton.ghost(
                      onPressed: () =>
                          setState(() => _obscurePassword = !_obscurePassword),
                      child: Icon(
                        _obscurePassword ? LucideIcons.eyeOff : LucideIcons.eye,
                        size: 18,
                      ),
                    ),
                    onSubmitted: (_) => _submit(),
                    validator: Validators.password,
                  ),
                  Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: ShadButton.link(
                      onPressed: isLoading
                          ? null
                          : () => context.push(RouteNames.forgotPassword),
                      child: Text(l10n.forgotPassword),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SalonButton(
                    onPressed: isLoading ? null : _submit,
                    fullWidth: true,
                    isLoading: isLoading,
                    child: Text(l10n.login),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Divider(color: theme.colorScheme.border),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          l10n.orDivider,
                          style: theme.textTheme.muted,
                        ),
                      ),
                      Expanded(
                        child: Divider(color: theme.colorScheme.border),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SalonButton(
                    variant: SalonButtonVariant.outline,
                    onPressed: isLoading
                        ? null
                        : () => context
                            .read<AuthBloc>()
                            .add(const AuthGuestRequested()),
                    fullWidth: true,
                    leading: const Icon(LucideIcons.userRound, size: 18),
                    child: Text(l10n.continueAsGuest),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        l10n.dontHaveAccount,
                        style: theme.textTheme.muted,
                      ),
                      ShadButton.link(
                        onPressed: isLoading
                            ? null
                            : () => context.go(RouteNames.register),
                        child: Text(l10n.createNewAccount),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
