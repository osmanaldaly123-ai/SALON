import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/services/locale_service.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/salon_button.dart';
import '../../../../core/widgets/salon_text_field.dart';
import '../../../../l10n/app_localizations.dart';
import '../cubit/forgot_password_cubit.dart';
import '../widgets/auth_feedback.dart';
import '../widgets/auth_scaffold.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _submit(BuildContext context) {
    if (!_formKey.currentState!.validate()) return;
    context.read<ForgotPasswordCubit>().submit(_emailController.text);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocProvider(
      create: (_) => ForgotPasswordCubit(sl()),
      child: BlocConsumer<ForgotPasswordCubit, ForgotPasswordState>(
        listenWhen: (previous, current) =>
            current is ForgotPasswordSuccess || current is ForgotPasswordFailure,
        listener: (context, state) {
          if (state is ForgotPasswordSuccess) {
            ShadSonner.of(context).show(
              ShadToast(
                title: Text(l10n.passwordResetSent),
                description: Text(l10n.passwordResetSentSubtitle),
              ),
            );
            context.go(RouteNames.login);
          } else if (state is ForgotPasswordFailure) {
            showAuthFeedback(context, state.message);
          }
        },
        builder: (context, state) {
          final isLoading = state is ForgotPasswordLoading;
          final errorMessage =
              state is ForgotPasswordFailure ? state.message : null;

          return AuthScaffold(
            title: l10n.forgotPasswordTitle,
            subtitle: l10n.forgotPasswordSubtitle,
            topAction: ShadButton.ghost(
              onPressed: () => sl<LocaleService>().toggleLocale(),
              child: Text(l10n.language),
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (buildAuthErrorAlert(context, errorMessage) != null)
                    buildAuthErrorAlert(context, errorMessage)!,
                  SalonTextField(
                    controller: _emailController,
                    label: l10n.email,
                    hint: 'example@email.com',
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.done,
                    leading: const Icon(LucideIcons.mail, size: 18),
                    onSubmitted: (_) => _submit(context),
                    validator: Validators.email,
                  ),
                  const SizedBox(height: 16),
                  SalonButton(
                    onPressed: isLoading ? null : () => _submit(context),
                    fullWidth: true,
                    isLoading: isLoading,
                    child: Text(l10n.sendResetLink),
                  ),
                  const SizedBox(height: 16),
                  ShadButton.link(
                    onPressed: isLoading ? null : () => context.go(RouteNames.login),
                    child: Text(l10n.backToLogin),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
