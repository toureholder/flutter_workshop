class HttpEvent<T> {
  final EventState state;
  final T data;
  final int statusCode;

  HttpEvent({this.state = EventState.done, this.data, this.statusCode});

  HttpEvent.loading()
      : state = EventState.loading,
        data = null,
        statusCode = null;

  bool get isLoading => state == EventState.loading;
}

enum EventState { loading, done }
