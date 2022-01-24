const String viewOrders = r"""
query Query {
  viewOrders {
    _id
    dateCreated
    items {
      _id
      itemState
      trackCode
      itemImg
      totalPrice
      updateAt
      receiver {
        _id
        name
        pNumber
      }
      itemInstruction
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
    dateAccepted
    dateFinish
    rider {
      _id
      name
      email
      pNumber
      profileImg
      vehicle {
        _id
        plateNum
        type
        vehicleModel
      }
    }
  }
}
""";
