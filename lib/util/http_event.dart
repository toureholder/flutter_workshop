class HttpEvent<T> {
  HttpEvent({this.state = EventState.done, this.data, this.statusCode});

  HttpEvent.loading()
      : state = EventState.loading,
        data = null,
        statusCode = null;

  final EventState state;
  final T data;
  final int statusCode;

  bool get isLoading => state == EventState.loading;
}

enum EventState { loading, done }
