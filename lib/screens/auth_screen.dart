import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class AuthScreen extends StatefulWidget {
  final void Function(String email) onAuthed;
  const AuthScreen({super.key, required this.onAuthed});
  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _form = GlobalKey<FormState>();
  final _name = TextEditingController(), _email = TextEditingController(), _pass = TextEditingController();
  bool signUp = false, hide = true, agree = false, busy = false;
  String? error;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _pass.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_form.currentState!.validate()) return;
    if (signUp && !agree) {
      setState(() => error = 'Please accept the terms and risk notice.');
      return;
    }
    setState(() {
      busy = true;
      error = null;
    });
    // TODO: replace with the real sign-in / sign-up API call.
    await Future<void>.delayed(const Duration(milliseconds: 400));
    if (!mounted) return;
    setState(() => busy = false);
    widget.onAuthed(_email.text.trim());
  }

  void _social(String name) => widget.onAuthed('$name user');

  Widget _brand() => Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: const [
        Icon(Icons.candlestick_chart, size: 40, color: AppColors.accent),
        SizedBox(height: 12),
        Text('Replay Trader', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800)),
        SizedBox(height: 8),
        Text('Practice on past markets. No look-ahead, honest fills, a journal that keeps you accountable.',
            style: TextStyle(color: Colors.white60, height: 1.4)),
      ]);

  Widget _formCard() => Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _form,
            child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              SegmentedButton<bool>(
                showSelectedIcon: false,
                segments: const [ButtonSegment(value: false, label: Text('Sign in')), ButtonSegment(value: true, label: Text('Sign up'))],
                selected: {signUp},
                onSelectionChanged: (v) => setState(() {
                  signUp = v.first;
                  error = null;
                }),
              ),
              const SizedBox(height: 16),
              if (signUp) ...[
                TextFormField(
                  controller: _name,
                  textInputAction: TextInputAction.next,
                  autofillHints: const [AutofillHints.name],
                  decoration: const InputDecoration(labelText: 'Full name'),
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Enter your name' : null,
                ),
                const SizedBox(height: 12),
              ],
              TextFormField(
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.email],
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (v) => RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(v?.trim() ?? '') ? null : 'Enter a valid email',
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _pass,
                obscureText: hide,
                textInputAction: TextInputAction.done,
                autofillHints: [signUp ? AutofillHints.newPassword : AutofillHints.password],
                onFieldSubmitted: (_) => _submit(),
                decoration: InputDecoration(
                  labelText: 'Password',
                  suffixIcon: IconButton(icon: Icon(hide ? Icons.visibility_off : Icons.visibility, size: 20), onPressed: () => setState(() => hide = !hide)),
                ),
                validator: (v) => (v ?? '').length < 8 ? 'At least 8 characters' : null,
              ),
              if (!signUp)
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Password reset link will be emailed.'))),
                    child: const Text('Forgot password?', style: TextStyle(fontSize: 12)),
                  ),
                )
              else
                CheckboxListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  controlAffinity: ListTileControlAffinity.leading,
                  value: agree,
                  onChanged: (v) => setState(() => agree = v ?? false),
                  title: const Text('I accept the terms. Results are simulated, not investment advice.', style: TextStyle(fontSize: 12)),
                ),
              if (error != null) Padding(padding: const EdgeInsets.only(bottom: 8), child: Text(error!, style: const TextStyle(color: AppColors.down, fontSize: 12))),
              const SizedBox(height: 4),
              ElevatedButton(
                style: ElevatedButton.styleFrom(minimumSize: const Size(0, 46), backgroundColor: AppColors.accent, foregroundColor: Colors.black),
                onPressed: busy ? null : _submit,
                child: busy ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2)) : Text(signUp ? 'Create account' : 'Sign in'),
              ),
              const SizedBox(height: 14),
              Row(children: const [
                Expanded(child: Divider()),
                Padding(padding: EdgeInsets.symmetric(horizontal: 10), child: Text('or', style: TextStyle(color: Colors.white38, fontSize: 12))),
                Expanded(child: Divider()),
              ]),
              const SizedBox(height: 14),
              OutlinedButton.icon(onPressed: () => _social('Google'), icon: const Icon(Icons.g_mobiledata, size: 26), label: const Text('Continue with Google')),
              const SizedBox(height: 8),
              OutlinedButton.icon(onPressed: () => _social('Apple'), icon: const Icon(Icons.apple, size: 20), label: const Text('Continue with Apple')),
            ]),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: LayoutBuilder(builder: (context, c) {
            final wide = c.maxWidth >= wideBreakpoint;
            final form = ConstrainedBox(constraints: const BoxConstraints(maxWidth: 420), child: _formCard());
            return Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: wide
                    ? Row(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.center, children: [
                        ConstrainedBox(constraints: const BoxConstraints(maxWidth: 380), child: _brand()),
                        const SizedBox(width: 64),
                        form,
                      ])
                    : Column(mainAxisSize: MainAxisSize.min, children: [
                        Align(alignment: Alignment.centerLeft, child: _brand()),
                        const SizedBox(height: 20),
                        form,
                      ]),
              ),
            );
          }),
        ),
      );
}
