const String addingVendor = r"""
mutation addingVendor($name: String!, $email: String!, $password: String!, $pNumber: String!) {
  addVendor(
    name: $name, 
    email: $email, 
    password: $password, 
    pNumber: $pNumber
  )
}
""";
