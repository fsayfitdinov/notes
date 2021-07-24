import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../application/auth/sign_in_form/sign_in_form_bloc.dart';
import '../../core/widgets/default_text_button.dart';
import 'custom_prefix_icon.dart';

class SignInForm extends StatelessWidget {
  const SignInForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignInFormBloc, SignInFormState>(
      listener: (context, state) {
        state.authFailureOrSuccessOption.fold(
          () {},
          (either) => either.fold(
            (f) => context.showErrorBar(
              content: Text(
                f.map(
                  cancelledByUser: (_) => "Cancelled",
                  serverError: (_) => "Server Error",
                  emailAlreadyInUse: (_) => "Email is already in use",
                  invalidEmailAndPassword: (_) => "Invalid email and password",
                ),
              ),
            ),
            (r) {
              // TODO navigation
            },
          ),
        );
      },
      builder: (context, state) {
        return Form(
          autovalidateMode: state.showErrorMessages ? AutovalidateMode.always : AutovalidateMode.disabled,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: <Widget>[
              const SizedBox(height: 20),
              SizedBox(
                height: 200,
                width: 200,
                child: Image.asset(
                  'assets/images/Paper-notes.svg.png',
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 40),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: CustomPrefixIcon(icon: Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
                onChanged: (val) {
                  context.read<SignInFormBloc>().add(SignInFormEvent.emailChanged(val));
                },
                validator: (_) => context.read<SignInFormBloc>().state.emailAddress.value.fold(
                      (f) => f.maybeMap(
                        invalidEmail: (_) => 'Invalid Email',
                        orElse: () => null,
                      ),
                      (r) => null,
                    ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Password',
                  prefixIcon: CustomPrefixIcon(icon: Icons.lock),
                ),
                obscureText: true,
                autocorrect: false,
                onChanged: (val) {
                  context.read<SignInFormBloc>().add(SignInFormEvent.passwordChanged(val));
                },
                validator: (_) => context.read<SignInFormBloc>().state.password.value.fold(
                      (f) => f.maybeMap(
                        shortPassword: (_) => 'Weak password',
                        orElse: () => null,
                      ),
                      (r) => null,
                    ),
              ),
              const SizedBox(height: 20),
              Row(
                children: <Widget>[
                  Expanded(
                    child: DefaultTextButton(
                      color: Colors.blue,
                      press: () {
                        context.read<SignInFormBloc>().add(const SignInFormEvent.signInEmailPasswordPressed());
                      },
                      title: 'Login',
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: DefaultTextButton(
                      color: Colors.white,
                      press: () {
                        context.read<SignInFormBloc>().add(const SignInFormEvent.registerEmailPasswordPressed());
                      },
                      title: 'Sign Up',
                      textColor: Colors.black,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Text(
                'or',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 10),
              DefaultTextButton(
                color: Colors.green,
                press: () {
                  context.read<SignInFormBloc>().add(const SignInFormEvent.signInGooglePressed());
                },
                title: 'Login with Google',
              ),
            ],
          ),
        );
      },
    );
  }
}
