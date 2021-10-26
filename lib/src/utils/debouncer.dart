import 'dart:async';

class Debouncer<T> {
  T? _value;
  Timer? _timer;
  T get value => _value!;

  final Duration? duration;
  void Function(T value)? onValue;

  Debouncer({this.duration, this.onValue});

  set value(T val) {
    _value = val;
    _timer?.cancel();
    _timer = Timer(duration!, () => onValue?.call(value));
  }
}
