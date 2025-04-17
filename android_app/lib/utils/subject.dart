class Subject<T> {
  final List<void Function(T)> _listeners = [];

  void subscribe(final void Function(T) function) {
    _listeners.add(function);
  }

  void unsubscribe(final void Function(T) function) {
    _listeners.remove(function);
  }

  void signal(T value) {
    for (var listener in _listeners) {
      listener.call(value);
    }
  }
}