import 'package:p2u_wallet/v2/core/models/connections.dart';
import '../../../core/models/base_view_model.dart';
import '../../../../locator.dart';
import '../../../core/services/auth_services.dart';

class MyWalletProvider extends BaseViewModal {
  final auth = locator<AuthServices>();

  bool walletAddressFetched = false;

  late String currentUserEmail;

  MyWalletProvider() {
    currentUserEmail = auth.firebaseUser!.email!;

    getWalletId();
  }

  String? walletAddress;
  List<Connections> activeConnections = [];
  String? onChainAddress;
  String? nonChainAddress;
  getWalletId() async {
    walletAddress = auth.myAppUser.wallet!.onChainAddress!;
    // onChainAddress = auth.myAppUser.wallet!.onChainAddress!;
    nonChainAddress = auth.myAppUser.wallet!.offChainAddress!;
    notifyListeners();
  }
}
