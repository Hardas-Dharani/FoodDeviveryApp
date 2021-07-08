
class HomePickup {
  int id;
  var restaurantId;
  String name;
  String arabicName;
  String email;
  String password;
  String latitude;
  String longitude;
  String address;
  int status;
  String createdAt;
  String updatedAt;
  int coverage;
  var rememberToken;
  var ownerId;
  var branchType;
  var city;
  var districtArea;
  var phoneNumber;
  var branchManagerEmailId;
  var openTime;
  var closeTime;
  int hasHomeDelivery;
  int hasTakeAway;
  int hasDineInn;
  int hasRegular;
  int hasBreakFast;
  var deliveryCharges;
  var minimumOrderAmount;
  var restId;
  var vatRegNumber;

  HomePickup(
      {this.id,
      this.restaurantId,
      this.name,
      this.arabicName,
      this.email,
      this.password,
      this.latitude,
      this.longitude,
      this.address,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.coverage,
      this.rememberToken,
      this.ownerId,
      this.branchType,
      this.city,
      this.districtArea,
      this.phoneNumber,
      this.branchManagerEmailId,
      this.openTime,
      this.closeTime,
      this.hasHomeDelivery,
      this.hasTakeAway,
      this.hasDineInn,
      this.hasRegular,
      this.hasBreakFast,
      this.deliveryCharges,
      this.minimumOrderAmount,
      this.restId,
      this.vatRegNumber});

  HomePickup.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    restaurantId = json['restaurant_id'];
    name = json['name'];
    arabicName = json['arabic_name'];
    email = json['email'];
    password = json['password'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    address = json['address'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    coverage = json['coverage'];
    rememberToken = json['remember_token'];
    ownerId = json['owner_id'];
    branchType = json['branch_type'];
    city = json['city'];
    districtArea = json['district_area'];
    phoneNumber = json['phone_number'];
    branchManagerEmailId = json['branch_manager_email_id'];
    openTime = json['open_time'];
    closeTime = json['close_time'];
    hasHomeDelivery = json['has_home_delivery'];
    hasTakeAway = json['has_take_away'];
    hasDineInn = json['has_dine_inn'];
    hasRegular = json['has_regular'];
    hasBreakFast = json['has_breakFast'];
    deliveryCharges = json['delivery_charges'];
    minimumOrderAmount = json['minimum_order_amount'];
    restId = json['rest_id'];
    vatRegNumber = json['vat_reg_number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['restaurant_id'] = this.restaurantId;
    data['name'] = this.name;
    data['arabic_name'] = this.arabicName;
    data['email'] = this.email;
    data['password'] = this.password;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['address'] = this.address;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['coverage'] = this.coverage;
    data['remember_token'] = this.rememberToken;
    data['owner_id'] = this.ownerId;
    data['branch_type'] = this.branchType;
    data['city'] = this.city;
    data['district_area'] = this.districtArea;
    data['phone_number'] = this.phoneNumber;
    data['branch_manager_email_id'] = this.branchManagerEmailId;
    data['open_time'] = this.openTime;
    data['close_time'] = this.closeTime;
    data['has_home_delivery'] = this.hasHomeDelivery;
    data['has_take_away'] = this.hasTakeAway;
    data['has_dine_inn'] = this.hasDineInn;
    data['has_regular'] = this.hasRegular;
    data['has_breakFast'] = this.hasBreakFast;
    data['delivery_charges'] = this.deliveryCharges;
    data['minimum_order_amount'] = this.minimumOrderAmount;
    data['rest_id'] = this.restId;
    data['vat_reg_number'] = this.vatRegNumber;
    return data;
  }
}
