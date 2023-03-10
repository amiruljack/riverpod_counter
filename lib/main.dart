import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(
      title: 'Riverpod Counter',
      home: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text('Riverpod Counter'),
        ),
        child: CounterPage(),
      ),
    );
  }
}

final counterProvider = StateNotifierProvider<CounterNotifier, Counter>((ref) => CounterNotifier());

final fetchCounterFutureProvider = FutureProvider((ref) {
  final counter = ref.watch(counterProvider.select((value) => value.aCounter));
  return Future.delayed(const Duration(seconds: 5), () => counter + 100);
});

class Counter {
  int aCounter;
  int bCounter;

  Counter({required this.aCounter, required this.bCounter});

  Counter copyWith({int? aCounter, int? bCounter}) {
    return Counter(
      aCounter: aCounter ?? this.aCounter,
      bCounter: bCounter ?? this.bCounter,
    );
  }

  @override
  String toString() {
    return 'Counter(aCounter: $aCounter, bCounter: $bCounter)';
  }
}

class CounterNotifier extends StateNotifier<Counter> {
  CounterNotifier() : super(Counter(aCounter: 0, bCounter: 0));

  void addA() {
    state = state.copyWith(aCounter: state.aCounter + 1);
  }

  void addB() {
    state = state.copyWith(bCounter: state.bCounter + 1);
  }
}

class CounterPage extends ConsumerWidget {
  const CounterPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print("rebuilt");
    final counter = ref.watch(counterProvider.select((value) => value.aCounter));
    final futureProvider = ref.watch(fetchCounterFutureProvider);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Counter Value: ${counter.toString()}',
            style: CupertinoTheme.of(context).textTheme.navLargeTitleTextStyle,
          ),
          futureProvider.when(
            data: (data) => Text('Future Value: ${data.toString()}'),
            error: (error, stack) => Text('Future Value: Error ${error.toString()}'),
            loading: () => Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text('Future Value: '),
                SizedBox(
                  height: 18,
                  width: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CupertinoButton(
                child: const Text('Add A'),
                onPressed: () => ref.read(counterProvider.notifier).addA(),
              ),
              const SizedBox(width: 20),
              CupertinoButton(
                child: const Text('Add B'),
                onPressed: () => ref.read(counterProvider.notifier).addB(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
