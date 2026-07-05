import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/salon_button.dart';
import '../../../../core/widgets/salon_text_field.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../auth/domain/entities/user.dart';
import '../cubit/profile_cubit.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key, required this.user});

  final User user;

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.name);
    _emailController = TextEditingController(text: widget.user.email);
    _phoneController = TextEditingController(text: widget.user.phone ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    context.read<ProfileCubit>().update(
          name: _nameController.text.trim(),
          phone: _phoneController.text.trim().isEmpty
              ? null
              : _phoneController.text.trim(),
        );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = ShadTheme.of(context);

    return BlocProvider.value(
      value: sl<ProfileCubit>(),
      child: BlocConsumer<ProfileCubit, ProfileState>(
        listenWhen: (prev, curr) =>
            curr is ProfileLoaded && prev is ProfileUpdating,
        listener: (context, state) {
          if (state is ProfileLoaded) {
            context.pop(true);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(l10n.profileUpdated)),
            );
          }
        },
        builder: (context, state) {
          final isUpdating = state is ProfileUpdating;

          return Scaffold(
            backgroundColor: theme.colorScheme.background,
            appBar: AppBar(
              backgroundColor: theme.colorScheme.background,
              foregroundColor: theme.colorScheme.foreground,
              title: Text(l10n.editProfile),
              leading: IconButton(
                icon: const Icon(LucideIcons.x),
                onPressed: isUpdating ? null : () => context.pop(),
              ),
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SalonTextField(
                      controller: _nameController,
                      label: l10n.name,
                      enabled: !isUpdating,
                      leading: const Icon(LucideIcons.user, size: 18),
                      validator: (v) => Validators.required(v),
                    ),
                    SalonTextField(
                      controller: _emailController,
                      label: l10n.email,
                      readOnly: true,
                      leading: const Icon(LucideIcons.mail, size: 18),
                    ),
                    SalonTextField(
                      controller: _phoneController,
                      label: l10n.phoneOptional,
                      enabled: !isUpdating,
                      keyboardType: TextInputType.phone,
                      leading: const Icon(LucideIcons.phone, size: 18),
                      validator: (v) => Validators.phone(v),
                    ),
                    const SizedBox(height: 16),
                    SalonButton(
                      fullWidth: true,
                      onPressed: isUpdating ? null : _save,
                      isLoading: isUpdating,
                      child: Text(l10n.saveChanges),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
