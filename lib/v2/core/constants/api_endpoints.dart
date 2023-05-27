class EndPoints {
// dev-p2u-api.msq.market
// stg-p2u-api.msq.market
// p2u-api.msq.market
  static const productionBaseUrl = "https://p2u-api.msq.market";
  static const sandboxBaseUrl = 'https://dev-p2u-api.msq.market';
  static const stgBaseUrl = 'https://stg-p2u-api.msq.market';
  static const baseUrl = productionBaseUrl;
  // static const baseUrl = sandboxBaseUrl;
  // static const baseUrl = stgBaseUrl;
  static const signUp = '$baseUrl/signup';
  static const fetchOrdersData = '$baseUrl/orders/getAllOrders';
  static const fetchUser = '$baseUrl/get_user';
  static const fetchUserToken = '$baseUrl/get_user_token';
  static const userCredential = '$baseUrl/user_creds';
  static const deleteUser = "$baseUrl/delete_user";
  static const updatePassword = "$baseUrl/update_password";

  //Orders Test API Endpoints
  static const getAllOrders = '$baseUrl/p2p-orders/getAllOrders';
  static const getMyOrders = '$baseUrl/p2p-orders/getMyOrders';
  static const buySellOrders = '$baseUrl/p2p-or ders/buySellOrders';
  static const ordersCompleted = '$baseUrl/p2p-orders/orderCompleted';
  static const deleteOrder = '$baseUrl/p2p-orders/deleteOrder';
  static const validateUser = '$baseUrl/validate_user_creds';

  // Wallet API Endpoint
  static const getTransaction = "$baseUrl/wallet/get_request";
  static const sendTransaction = "$baseUrl/wallet/complete_request";
  static const getConnectionRequest = "$baseUrl/wallet/getConnectionRequest";
  static const completeConnection = "$baseUrl/wallet/completeConnection";

  ///Transaction API Endpoint
  static const msqpToMsq = "$baseUrl/transaction/msqpToMsq";
  static const msqToMsqp = "$baseUrl/transaction/msqToMsqp";
  static const msqxToMsqxp = "$baseUrl/transaction/msqxToMsqxp";
  static const msqxpToMsqx = "$baseUrl/transaction/msqxpToMsqx";
  static const getHistory = "$baseUrl/transaction/getTransactions";
  static const tokenTransfer =
      "$baseUrl/transaction/transfer_tokens_usertouser";

  ///Added .................
  static const getPrices = "$baseUrl/get_prices";
  static const refreshBalanceRPA = "$baseUrl/refresh_balance_rpa";
  static const getAffiliates = "$baseUrl/get_affiliates";

  /// API Endpoints related to User Cards

  static const getCards = "$baseUrl/get_cards";
  static const addCard = "$baseUrl/register_card";
  static const getCardCompanies = "$baseUrl/get_companies";
}
