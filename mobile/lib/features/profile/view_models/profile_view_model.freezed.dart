// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'profile_view_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ProfileState {
  bool get isLoading => throw _privateConstructorUsedError;
  List<PhotoModel> get userPhotos => throw _privateConstructorUsedError;
  List<PhotoModel> get bookmarkedPhotos => throw _privateConstructorUsedError;
  int get selectedTabIndex => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;

  /// Create a copy of ProfileState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProfileStateCopyWith<ProfileState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProfileStateCopyWith<$Res> {
  factory $ProfileStateCopyWith(
          ProfileState value, $Res Function(ProfileState) then) =
      _$ProfileStateCopyWithImpl<$Res, ProfileState>;
  @useResult
  $Res call(
      {bool isLoading,
      List<PhotoModel> userPhotos,
      List<PhotoModel> bookmarkedPhotos,
      int selectedTabIndex,
      String? error});
}

/// @nodoc
class _$ProfileStateCopyWithImpl<$Res, $Val extends ProfileState>
    implements $ProfileStateCopyWith<$Res> {
  _$ProfileStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProfileState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? userPhotos = null,
    Object? bookmarkedPhotos = null,
    Object? selectedTabIndex = null,
    Object? error = freezed,
  }) {
    return _then(_value.copyWith(
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      userPhotos: null == userPhotos
          ? _value.userPhotos
          : userPhotos // ignore: cast_nullable_to_non_nullable
              as List<PhotoModel>,
      bookmarkedPhotos: null == bookmarkedPhotos
          ? _value.bookmarkedPhotos
          : bookmarkedPhotos // ignore: cast_nullable_to_non_nullable
              as List<PhotoModel>,
      selectedTabIndex: null == selectedTabIndex
          ? _value.selectedTabIndex
          : selectedTabIndex // ignore: cast_nullable_to_non_nullable
              as int,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ProfileStateImplCopyWith<$Res>
    implements $ProfileStateCopyWith<$Res> {
  factory _$$ProfileStateImplCopyWith(
          _$ProfileStateImpl value, $Res Function(_$ProfileStateImpl) then) =
      __$$ProfileStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool isLoading,
      List<PhotoModel> userPhotos,
      List<PhotoModel> bookmarkedPhotos,
      int selectedTabIndex,
      String? error});
}

/// @nodoc
class __$$ProfileStateImplCopyWithImpl<$Res>
    extends _$ProfileStateCopyWithImpl<$Res, _$ProfileStateImpl>
    implements _$$ProfileStateImplCopyWith<$Res> {
  __$$ProfileStateImplCopyWithImpl(
      _$ProfileStateImpl _value, $Res Function(_$ProfileStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of ProfileState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? userPhotos = null,
    Object? bookmarkedPhotos = null,
    Object? selectedTabIndex = null,
    Object? error = freezed,
  }) {
    return _then(_$ProfileStateImpl(
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      userPhotos: null == userPhotos
          ? _value._userPhotos
          : userPhotos // ignore: cast_nullable_to_non_nullable
              as List<PhotoModel>,
      bookmarkedPhotos: null == bookmarkedPhotos
          ? _value._bookmarkedPhotos
          : bookmarkedPhotos // ignore: cast_nullable_to_non_nullable
              as List<PhotoModel>,
      selectedTabIndex: null == selectedTabIndex
          ? _value.selectedTabIndex
          : selectedTabIndex // ignore: cast_nullable_to_non_nullable
              as int,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$ProfileStateImpl implements _ProfileState {
  const _$ProfileStateImpl(
      {this.isLoading = false,
      final List<PhotoModel> userPhotos = const [],
      final List<PhotoModel> bookmarkedPhotos = const [],
      this.selectedTabIndex = 0,
      this.error})
      : _userPhotos = userPhotos,
        _bookmarkedPhotos = bookmarkedPhotos;

  @override
  @JsonKey()
  final bool isLoading;
  final List<PhotoModel> _userPhotos;
  @override
  @JsonKey()
  List<PhotoModel> get userPhotos {
    if (_userPhotos is EqualUnmodifiableListView) return _userPhotos;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_userPhotos);
  }

  final List<PhotoModel> _bookmarkedPhotos;
  @override
  @JsonKey()
  List<PhotoModel> get bookmarkedPhotos {
    if (_bookmarkedPhotos is EqualUnmodifiableListView)
      return _bookmarkedPhotos;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_bookmarkedPhotos);
  }

  @override
  @JsonKey()
  final int selectedTabIndex;
  @override
  final String? error;

  @override
  String toString() {
    return 'ProfileState(isLoading: $isLoading, userPhotos: $userPhotos, bookmarkedPhotos: $bookmarkedPhotos, selectedTabIndex: $selectedTabIndex, error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProfileStateImpl &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            const DeepCollectionEquality()
                .equals(other._userPhotos, _userPhotos) &&
            const DeepCollectionEquality()
                .equals(other._bookmarkedPhotos, _bookmarkedPhotos) &&
            (identical(other.selectedTabIndex, selectedTabIndex) ||
                other.selectedTabIndex == selectedTabIndex) &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      isLoading,
      const DeepCollectionEquality().hash(_userPhotos),
      const DeepCollectionEquality().hash(_bookmarkedPhotos),
      selectedTabIndex,
      error);

  /// Create a copy of ProfileState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProfileStateImplCopyWith<_$ProfileStateImpl> get copyWith =>
      __$$ProfileStateImplCopyWithImpl<_$ProfileStateImpl>(this, _$identity);
}

abstract class _ProfileState implements ProfileState {
  const factory _ProfileState(
      {final bool isLoading,
      final List<PhotoModel> userPhotos,
      final List<PhotoModel> bookmarkedPhotos,
      final int selectedTabIndex,
      final String? error}) = _$ProfileStateImpl;

  @override
  bool get isLoading;
  @override
  List<PhotoModel> get userPhotos;
  @override
  List<PhotoModel> get bookmarkedPhotos;
  @override
  int get selectedTabIndex;
  @override
  String? get error;

  /// Create a copy of ProfileState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProfileStateImplCopyWith<_$ProfileStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
