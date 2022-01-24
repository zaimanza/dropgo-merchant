const String addOrder = r"""
mutation AddOrder($address: address_input, $items: [item_input!]) {
  addOrder(address: $address, items: $items) {
    _id
    dateCreated
    items {
      _id
      itemState
      trackCode
      itemImg
      totalPrice
      itemInstruction
      updateAt
      receiver {
        _id
        name
        pNumber
      }
      address {
        _id
        latLng
        state
        city
        country
        fullAddr
        postcode
        unitFloor
      }
    }
  }
}
""";
