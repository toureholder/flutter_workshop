import 'dart:isolate';

Future<T> computeInIsolate<T>(Function callBack, arg) async {
  final receivePort = ReceivePort();
  final isolate = await Isolate.spawn(callBack, receivePort.sendPort);
  final sendPort = await receivePort.first;
  final T result = await sendRespondableMessage(sendPort, arg);
  killIsolate(isolate);
  return result;
}

void killIsolate(Isolate isolate) {
  if (isolate != null) {
    isolate.kill(priority: Isolate.immediate);
    isolate = null;
  }
}

Future sendRespondableMessage(SendPort port, message) {
  ReceivePort response = ReceivePort();
  port.send(RespondableMessage(message, response.sendPort));
  return response.first;
}

class RespondableMessage<T> {
  final T data;
  final SendPort sendPort;

  RespondableMessage(this.data, this.sendPort);
}
