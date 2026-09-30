import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecommerce_mobile_app/cubit/cubit.dart';

class CounterScreen extends StatelessWidget {
  const CounterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Counter Example'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<CounterCubit>().reset();
            },
          ),
        ],
      ),
      body: BlocBuilder<CounterCubit, CounterState>(
        builder: (context, state) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Counter Value:',
                  style: TextStyle(fontSize: 24),
                ),
                const SizedBox(height: 16),
                Text(
                  '${state.count}',
                  style: const TextStyle(
                    fontSize: 72,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 48),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FloatingActionButton(
                      onPressed: () {
                        context.read<CounterCubit>().decrement();
                      },
                      heroTag: 'decrement',
                      child: const Icon(Icons.remove),
                    ),
                    const SizedBox(width: 24),
                    FloatingActionButton(
                      onPressed: () {
                        context.read<CounterCubit>().increment();
                      },
                      heroTag: 'increment',
                      child: const Icon(Icons.add),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        context.read<CounterCubit>().decrementBy(5);
                      },
                      child: const Text('-5'),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<CounterCubit>().incrementBy(5);
                      },
                      child: const Text('+5'),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
