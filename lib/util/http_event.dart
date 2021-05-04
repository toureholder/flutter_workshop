class HttpEvent<T> {
  HttpEvent({
    this.state = EventState.done,
    this.data,
    this.statusCode,
  });

  final EventState state;
  final T data;
  final int statusCode;

  bool get isLoading => state == EventState.loading;
}

enum EventState {
  loading,
  done,
}
