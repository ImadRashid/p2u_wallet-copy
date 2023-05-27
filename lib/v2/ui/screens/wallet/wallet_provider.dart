import '../../../../locator.dart';
import '../../../core/enums/view_state.dart';
import '../../../core/models/base_view_model.dart';
import '../../../core/models/user_model.dart';
import '../../../core/services/api_services.dart';
import '../../../core/services/auth_services.dart';

/// [ViewModel] that communicates between [Models], [Utilities] and [API]s and send the
/// required [data] to our [View] which here is [WalletScreen]
class WalletScreenProvider extends BaseViewModal {
  /// [AuthServices] locator that handles [User]'s data and authentications
  final locateUser = locator<AuthServices>();

  /// [ApiServices] that handles main [API] Services
  final _apiServices = ApiServices();

  /// [Variable] that stores total number of tokens a [User] has.
  var availableBalance = 0.00;

  /// [Variable] that stores total value of all tokens.
  var availableBalanceInKRW = 0.00;

  /// [Prices] that contains prices of all tokens
  TokenPrices tokenPrices = TokenPrices();

  /// [Constructor] that initializes some of the main components.
  WalletScreenProvider() {
    // calls init function
    init();
  }

  /// [Function] that fetches:
  /// - [Token] Balances
  /// - [Token] Prices
  ///
  /// and than calculates:
  /// - Total Number of tokens
  /// - Total value of all tokens
  init() async {
    setState(ViewState.busy);
    // fetch token balances
    await fetchNewBalances();
    // fetch token prices
    await fetchPrices();
    setState(ViewState.idle);
  }

  /// [Function] that fetches all tokens of a specific
  /// [User] and their number.
  fetchNewBalances() async {
    // fetch user details
    final result = await _apiServices.fetchUser();
    if (result == false) {
    } else {
      // store the fetched data of user
      locateUser.myAppUser = UserModel.fromJson(result);
    }
  }

  /// [Function] that fetches prices of all the
  /// implemented tokens (as currently only MSQ
  /// value change is setup).
  fetchPrices() async {
    // Fetch Token Prices
    final result = await _apiServices.getPricesAPi();
    if (result != false) {
      // save returned data into tokenPrices
      tokenPrices = TokenPrices.fromJson(result);
    }
  }
}
