import 'package:freezed_annotation/freezed_annotation.dart';

part 'trend_model.freezed.dart';
part 'trend_model.g.dart';

@freezed
class TrendModel with _$TrendModel {
  const factory TrendModel({
    required String id,
    required String location,
    @JsonKey(name: 'search_count') required int searchCount,
    @JsonKey(name: 'upload_count') required int uploadCount,
    @JsonKey(name: 'like_count') required int likeCount,
    @JsonKey(name: 'trend_score') required double trendScore,
    required DateTime date,
  }) = _TrendModel;

  factory TrendModel.fromJson(Map<String, dynamic> json) =>
      _$TrendModelFromJson(json);
}
