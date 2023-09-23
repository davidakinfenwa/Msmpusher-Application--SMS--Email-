import 'package:dartz/dartz.dart';
import 'package:msmpusher/core/exceptions/exceptions.dart';
import 'package:msmpusher/core/util/unit_impl.dart';
import 'package:msmpusher/domain/model/models.dart';

abstract class ContactRepository {
  Future<Either<Failure<ExceptionMessage>, ContactModelList>>
      getContactsFromDevice();

  Future<Either<Failure<ExceptionMessage>, ContactModelList>>
      getContactsFromFile();

  Future<Either<Failure<ExceptionMessage>, ContactGroupList>> getGroups();

  Future<Either<Failure<ExceptionMessage>, UnitImpl>> createGroup(
      {required ContactGroup contactGroup});

  Future<Either<Failure<ExceptionMessage>, UnitImpl>> deleteGroup(
      {required UniqueId uniqueId});

  Future<Either<Failure<ExceptionMessage>, ContactGroup>> deleteGroupContact(
      {required UniqueId groupUniqueId, required UniqueId contactUniqueId});
}
