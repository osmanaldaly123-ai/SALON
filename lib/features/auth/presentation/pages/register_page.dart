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

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    context.read<AuthBloc>().add(
          AuthRegisterRequested(
            name: _nameController.text,
            email: _emailController.text,
            password: _passwordController.text,
            phone: _phoneController.text.isEmpty
                ? null
                : _phoneController.text,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (previous, current) =>
          current is AuthAuthenticated || current is AuthFailure,
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          context.go(RouteNames.home);
        } else if (state is AuthFailure) {
          showAuthFeedback(context, state.message);
        }
      },
      child: AuthScaffold(
        title: l10n.createAccount,
        subtitle: l10n.createAccountSubtitle,
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
                    controller: _nameController,
                    label: l10n.name,
                    textInputAction: TextInputAction.next,
                    leading: const Icon(LucideIcons.user, size: 18),
                    validator: Validators.required,
                  ),
                  SalonTextField(
                    controller: _emailController,
                    label: l10n.email,
                    hint: 'example@email.com',
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    leading: const Icon(LucideIcons.mail, size: 18),
                    validator: Validators.email,
                  ),
                  SalonTextField(
                    controller: _phoneController,
                    label: l10n.phoneOptional,
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.next,
                    leading: const Icon(LucideIcons.phone, size: 18),
                    validator: Validators.phone,
                  ),
                  SalonTextField(
                    controller: _passwordController,
                    label: l10n.password,
                    textInputAction: TextInputAction.next,
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
                    validator: Validators.password,
                  ),
                  SalonTextField(
                    controller: _confirmPasswordController,
                    label: l10n.confirmPassword,
                    textInputAction: TextInputAction.done,
                    obscureText: _obscureConfirm,
                    leading: const Icon(LucideIcons.lock, size: 18),
                    trailing: ShadButton.ghost(
                      onPressed: () =>
                          setState(() => _obscureConfirm = !_obscureConfirm),
                      child: Icon(
                        _obscureConfirm ? LucideIcons.eyeOff : LucideIcons.eye,
                        size: 18,
                      ),
                    ),
                    onSubmitted: (_) => _submit(),
                    validator: (value) => Validators.confirmPassword(
                      value,
                      _passwordController.text,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SalonButton(
                    onPressed: isLoading ? null : _submit,
                    fullWidth: true,
                    isLoading: isLoading,
                    child: Text(l10n.register),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        l10n.alreadyHaveAccount,
                        style: theme.textTheme.muted,
                      ),
                      ShadButton.link(
                        onPressed: isLoading
                            ? null
                            : () => context.go(RouteNames.login),
                        child: Text(l10n.login),
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
