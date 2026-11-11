// import 'package:BabyCentric/features/common/data/models/from_json_contract.dart';
// import 'package:BabyCentric/features/common/data/models/pagination_model.dart';
//
// class PaginationCommonResponseModel<T extends FromJsonInterface>{
//   int? code;
//   String? status;
//   String? msg;
//   PaginationModel? data;
//
//   PaginationCommonResponseModel({this.code, this.status, this.msg, this.data});
//
//   factory PaginationCommonResponseModel.fromJson(Map<String, dynamic> json) {
//     code = json['code'];
//     status = json['status'];
//     msg = json['msg'];
//     data = json['data'] != null ? PaginationModel.fromJson(json['data'], T.fromJson()) : null;
//   }
// }
//
//
//
//
