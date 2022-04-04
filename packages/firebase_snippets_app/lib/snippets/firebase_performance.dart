// ignore_for_file: non_constant_identifier_names

import 'package:firebase_performance/firebase_performance.dart';
import 'package:firebase_snippets_app/snippets/snippet_base.dart';
import 'package:http/http.dart' as http;

class FirebasePerformanceMonitoringSnippets implements DocSnippet {
  @override
  void runAll() {
    performanceMonitoring_usage();
    performanceMonitoring_httpTracking();
    performanceMonitoring_stopAutoCollecting();
  }

  void performanceMonitoring_usage() async {
    // [START performance_monitoring_usage]
    FirebasePerformance performance = FirebasePerformance.instance;

    Trace trace = performance.newTrace('custom-trace');
    // [END performance_monitoring_usage]

    // [START performance_monitoring_start_trace]
    await trace.start();

    // Set metrics you wish to track
    trace.setMetric('sum', 200);
    trace.setMetric('time', 342340435);
    // [END performance_monitoring_start_trace]

    // [START performance_monitoring_increment_values]
    trace.setMetric('sum', 200);

    // `sum` will be incremented to 201
    trace.incrementMetric('sum', 1);
    // [END performance_monitoring_increment_values]

    // [START performance_monitoring_set_non_metric_data]
    trace.putAttribute('userId', '1234');
    // [END performance_monitoring_set_non_metric_data]

    // [START performance_monitoring_stop_trace]
    await trace.stop();
    // [END performance_monitoring_stop_trace]
  }

  void performanceMonitoring_httpTracking() async {
    // [START performance_monitoring_http_tracking]
    FirebasePerformance performance = FirebasePerformance.instance;

    // Create a `HttpMetric` instance using the URL you're requesting as well as the type of request
    String url = 'https://firebase.flutter.dev';
    HttpMetric metric = performance.newHttpMetric(url, HttpMethod.Get);

    // You may also assign up to 5 attributes for each trace
    metric.putAttribute('foo', 'bar');

    // Start the trace
    await metric.start();

    // Make the request
    Uri uri = Uri.parse(url);
    var response = await http.get(uri);

    // Set specific headers to be collated
    metric.responseContentType = response.headers['Content-Type'];
    metric.httpResponseCode = response.statusCode;
    metric.responsePayloadSize = response.contentLength;

    // Stops the trace. This is when the data is sent to the Firebase server and it will appear in your Firebase console
    await metric.stop();
    // [END performance_monitoring_http_tracking]
  }

  void performanceMonitoring_stopAutoCollecting() async {
    // [START performance_monitoring_stop_auto_collecting]
    FirebasePerformance performance = FirebasePerformance.instance;
    // Custom data collection is, by default, enabled
    bool isEnabled = await performance.isPerformanceCollectionEnabled();
    // Set data collection to `false`
    await performance.setPerformanceCollectionEnabled(false);
    // [END performance_monitoring_stop_auto_collecting]
  }
}
