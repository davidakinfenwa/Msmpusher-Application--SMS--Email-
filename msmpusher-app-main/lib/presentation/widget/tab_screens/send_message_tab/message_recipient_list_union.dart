import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:msmpusher/domain/model/models.dart';

part 'message_recipient_list_union.freezed.dart';

@freezed
class MessageRecipientListUnion with _$MessageRecipientListUnion {
  const factory MessageRecipientListUnion.contactModel(
      {required ContactModelList contactModelList}) = _ContactModel;
  const factory MessageRecipientListUnion.groupModel(
      {required ContactGroupList contactGroupList}) = _GroupModel;
}
