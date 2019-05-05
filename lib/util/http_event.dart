class HttpEvent<T> {
  final EventState state;
  final T data;

  HttpEvent({this.state, this.data});

  bool get isLoading => state == EventState.loading;
  bool get isDone => state == EventState.done;
}

enum EventState { loading, done, error }
