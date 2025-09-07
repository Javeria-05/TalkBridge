library dataconnect_generated;

import 'package:firebase_data_connect/firebase_data_connect.dart';

class ExampleConnector {
  static final ConnectorConfig connectorConfig = ConnectorConfig(
    'us-central1', // region
    'example',     // connector name
    'talkbridge',  // project ID
  );

  final FirebaseDataConnect dataConnect;

  ExampleConnector({required this.dataConnect});

  static ExampleConnector get instance {
    return ExampleConnector(
      dataConnect: FirebaseDataConnect.instanceFor(
        connectorConfig: connectorConfig,
        sdkType: CallerSDKType.generated,
      ),
    );
  }
}
