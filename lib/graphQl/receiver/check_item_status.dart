const String checkItemStatus = r"""
query CheckItemStatus($trackCode: String!) {
  checkItemStatus(trackCode: $trackCode) {
    _id
    dateCreated
  
    dateAccepted
    item {
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
    }
    dateFinish
    rider {
      updateAt
      wallet {
        _id
      }
      _id
      name
      email
      pNumber
      liveLatLng
      profileImg
      vehicle {
        _id
        plateNum
        type
        vehicleModel
      }
      createAt
      isWork
    }
    vendor {
      _id
      name
      email
      pNumber
      createAt
      updateAt
    }
  }
}
""";
