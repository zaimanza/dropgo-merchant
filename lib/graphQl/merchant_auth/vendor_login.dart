const String vendorLogIn = r"""
mutation VendorLogIn($email: String!, $password: String!, $fcmToken: String!) {
  vendorLogIn(email: $email, password: $password, fcmToken: $fcmToken) {
    _id
    name
    email
    pNumber
    createAt
    updateAt
    orders {
      _id
    }
    accessToken
  }
}
""";
