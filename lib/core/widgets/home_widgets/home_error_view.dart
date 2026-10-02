import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../features/home/bloc/home_bloc.dart';
import 'error_retry_view.dart';

class HomeErrorView extends StatelessWidget {
  final String message;

  const HomeErrorView({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return ErrorRetryView(
      message: message,
      onRetry: () => context.read<HomeBloc>().add(const HomeStarted()),
    );
  }
}
