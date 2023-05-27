import 'package:p2u_wallet/v2/core/models/base_view_model.dart';

import '../../../../locator.dart';
import '../../../core/services/auth_services.dart';

class WalletRequestProvider extends BaseViewModal {
  final locateUser = locator<AuthServices>();
}
