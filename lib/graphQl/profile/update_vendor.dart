const String updateVendor = r"""
mutation UpdateVendor($name: String, $email: String, $password: String, $pNumber: String) {
updateVendor(name: $name, email: $email, password: $password, pNumber: $pNumber)
}
""";
