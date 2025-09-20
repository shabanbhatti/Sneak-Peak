class AddressModal {
  final String? name;

  final String? phoneNumber;

  final String? region;

  final String? city;

  final String? id;

  final String? address;

  final String? addressCetaory;

  const AddressModal({
    this.address,
    this.addressCetaory,
    this.city,
    this.name,
    this.id,
    this.phoneNumber,
    this.region,
  });

  factory AddressModal.fromMap(Map<String, dynamic> map) {
    return AddressModal(
      address: map['address'] ?? '',
      addressCetaory: map['address_cetagory'] ?? '',
      city: map['city'] ?? '',
      name: map['name'] ?? '',
      id: map['id']??'',
      phoneNumber: map['phone_number'] ?? '',
      region: map['region'] ?? '',
    );
  }

Map<String, dynamic> toMap(String myId){
return {
'address': address,
'address_cetagory': addressCetaory,
'city': city,
'name':name,
'id': myId,
'phone_number': phoneNumber,
'region': region
};

}



}
