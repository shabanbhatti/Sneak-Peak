class CaraouselsBannersModel {
  
  final String? caraouselImages;
  final String? caraouselImagesPaths;
  final String? id;

const CaraouselsBannersModel({ this.id ,required this.caraouselImages, required this.caraouselImagesPaths});


  factory CaraouselsBannersModel.fromMap(Map<String, dynamic> map,) {
    return CaraouselsBannersModel(
       caraouselImages: map['bannerImages'],
      caraouselImagesPaths: map['bannerImagesPathsID'],
      id: map['id']
    );
  }


Map<String, dynamic> toMap(String myId) {
    return {
       'bannerImages': caraouselImages,
      'bannerImagesPathsID':caraouselImagesPaths,
      'id':myId
    };
  }




}