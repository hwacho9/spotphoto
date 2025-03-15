import 'package:freezed_annotation/freezed_annotation.dart';

part 'upload_state.freezed.dart';

@freezed
class UploadState with _$UploadState {
  const factory UploadState({
    @Default(false) bool isLoading,
    @Default(false) bool isSuccess,
    String? error,
  }) = _UploadState;

  const UploadState._();

  bool get hasError => error != null;
}
