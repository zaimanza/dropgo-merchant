const String checkItemStatus = r"""
query CheckItemStatus($trackCode: String!) {
  checkItemStatus(trackCode: $trackCode) {
    _id
    dateCreated
    dateAccepted
    dateFinish
    item {
      _id
      itemState
      trackCode
      totalPrice
      itemImg
      itemInstruction
      updateAt
      receiver {
        pNumber
        name
        _id
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
