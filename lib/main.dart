import 'package:flutter/cupertino.dart';
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
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Counter Value: ${counter.toString()}',
            style: CupertinoTheme.of(context).textTheme.navLargeTitleTextStyle,
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
