import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:msmpusher/business/blocs/bloc_state.dart';
import 'package:msmpusher/business/blocs/contact_blocs/get_device_contacts_cubit/get_device_contacts_cubit.dart';
import 'package:msmpusher/business/snapshot_cache/snapshot_cache.dart';
import 'package:msmpusher/core/exceptions/exceptions.dart';
import 'package:msmpusher/core/theme/custom_typography.dart';
import 'package:msmpusher/domain/model/models.dart';
import 'package:msmpusher/presentation/widget/widgets.dart';
import 'package:provider/provider.dart';

class ContactList extends StatelessWidget {
  const ContactList({Key? key}) : super(key: key);

  Widget _buildLoadingIndicator() {
    return SliverFillRemaining(
      child: LoadingIndicator(
        type: LoadingIndicatorType.circularProgressIndicator(),
      ),
    );
  }

  Widget _buildContactItemLeading(ContactModel contactModel) {
    return CircleAvatar(
      backgroundColor: CustomTypography.kLightGreyColor,
      foregroundColor: CustomTypography.kMidGreyColor,
      child: Stack(
        children: [
          const Icon(Icons.person_outline_rounded),
          if (contactModel.isChecked) ...[
            Container(
              decoration: BoxDecoration(
                color: CustomTypography.kLightGreyColor,
              ),
              child: Icon(
                Icons.check,
                color: CustomTypography.kIndicationColor,
              ),
            ),
          ]
        ],
      ),
    );
  }

  Widget _buildContactItem(
      {required ContactModel contactModel, required int index}) {
    return Builder(builder: (context) {
      return CustomListTile(
        onTap: () {
          // select or unselect contact
          Provider.of<ContactSnapshotCache>(context, listen: false)
              .selectContact(contactModel, index: index);
        },
        leading: _buildContactItemLeading(contactModel),
        title: contactModel.contact.displayName,
        description: contactModel.primaryPhone.value,
      );
    });
  }

  Widget _buildContactList() {
    return Consumer<ContactSnapshotCache>(
      builder: (context, snapshot, child) {
        final _contacts = snapshot.isSearchingContactsMode
            ? snapshot.searchContactResults.contacts
            : snapshot.deviceContacts.contacts;

        if (_contacts.isEmpty) {
          return const SliverFillRemaining(
            child: Center(
              child: InfoIndicator(
                  label:
                      'No contacts found! Make sure you have saved contacts'),
            ),
          );
        }

        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return _buildContactItem(
                  contactModel: _contacts[index], index: index);
            },
            childCount: _contacts.length,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetDeviceContactsCubit,
        BlocState<Failure<ExceptionMessage>, ContactModelList>>(
      builder: (context, state) {
        return state.map(
          initial: (_) => _buildLoadingIndicator(),
          loading: (_) => _buildLoadingIndicator(),
          success: (_) => _buildContactList(),
          error: (error) {
            return SliverFillRemaining(
              child: Center(
                child: InfoIndicator(
                  label: error.failure.exception.message.toString(),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
