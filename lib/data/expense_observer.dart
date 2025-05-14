// Abstract class that defines the Observer interface
abstract class ExpenseObserver {
  // This method will be called whenever expenses change
  void onExpenseListChanged();
}

// This mixin can be used by any class that wants to be observable
mixin Observable<T> {
  final List<T> _observers = [];

  void addObserver(T observer) {
    if (!_observers.contains(observer)) {
      _observers.add(observer);
    }
  }

  void removeObserver(T observer) {
    _observers.remove(observer);
  }

  List<T> get observers => List.unmodifiable(_observers);
}
