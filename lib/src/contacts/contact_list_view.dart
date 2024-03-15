import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:infinite_carousel/infinite_carousel.dart';
import 'package:pullodex/src/contacts/contact_card.dart';
import 'package:pullodex/src/contacts/search_criteria.dart';

import '../settings/settings_view.dart';

/// Displays a list of SampleItems.
class ContactListView extends StatefulWidget {
  const ContactListView({
    super.key,
  });

  static const routeName = '/';

  @override
  State<ContactListView> createState() => _ContactListViewState();
}

class _ContactListViewState extends State<ContactListView> {
  final double _itemExtent = 300;
  final TextEditingController _searchController = TextEditingController();
  late InfiniteScrollController _controller;

  List<Contact>? _contacts;
  bool _permissionDenied = false;
  SearchCriteria _criteria = SearchCriteria.firstName;

  @override
  void initState() {
    super.initState();
    _controller = InfiniteScrollController();
    _fetchContacts();
  }

  Future _fetchContacts() async {
    if (!await FlutterContacts.requestPermission(readonly: true)) {
      setState(() => _permissionDenied = true);
    } else {
      final contacts = await FlutterContacts.getContacts(
        sorted: true,
        withProperties: true,
        withThumbnail: true,
        withGroups: true,
      );
      //contacts.sort(((a, b) => a.displayName.compareTo(b.displayName)));
      setState(() => _contacts = contacts);
    }
  }

  void _jumpToContact(String text) {
    if (_contacts == null) return;
    if (text.isNotEmpty && _contacts!.isNotEmpty) {
      final query = text.toLowerCase();
      final index = _contacts!.indexWhere((contact) => switch (_criteria) {
            (SearchCriteria.firstName) =>
              contact.displayName.toLowerCase().startsWith(query),
            (SearchCriteria.lastName) =>
              contact.name.last.toLowerCase().startsWith(query),
          });
      if (index != -1) {
        _controller.animateToItem(index);
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final int itemCount = _contacts?.length ?? 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pullodex'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.restorablePushNamed(context, SettingsView.routeName);
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 70,
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 8.0,
                  bottom: 16.0,
                  right: 8.0,
                  left: 8.0,
                ),
                child: SearchBar(
                  controller: _searchController,
                  padding: const MaterialStatePropertyAll<EdgeInsets>(
                      EdgeInsets.symmetric(horizontal: 16.0)),
                  onChanged: _jumpToContact,
                  leading: const Icon(Icons.search),
                  trailing: [
                    DropdownButtonHideUnderline(
                      child: ButtonTheme(
                        alignedDropdown: true,
                        child: DropdownButton(
                          value: _criteria,
                          onChanged: (SearchCriteria? value) => value != null
                              ? setState(() {
                                  _criteria = value;
                                })
                              : null,
                          items: SearchCriteria.values
                              .map<DropdownMenuItem<SearchCriteria>>(
                                  (SearchCriteria criteria) {
                            return DropdownMenuItem<SearchCriteria>(
                              value: criteria,
                              child: Text(criteria.name),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: _contacts == null
                  ? const Center(child: CircularProgressIndicator())
                  : _contacts!.isNotEmpty && !_permissionDenied
                      ? Scrollbar(
                          controller: _controller,
                          trackVisibility: true,
                          thickness: 8,
                          interactive: true,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 32.0),
                            child: InfiniteCarousel.builder(
                              controller: _controller,
                              itemCount: itemCount,
                              itemExtent: _itemExtent,
                              velocityFactor: 0.6,
                              anchor: 0.0,
                              loop: false,
                              axisDirection: Axis.vertical,
                              itemBuilder: (context, index, listIndex) {
                                final item = _contacts![index];
                                final currentOffset = _itemExtent * listIndex;

                                return AnimatedBuilder(
                                  animation: _controller,
                                  builder: (context, child) {
                                    final diff =
                                        (_controller.offset - currentOffset);
                                    const maxPadding = 10.0;
                                    final carouselRatio =
                                        _itemExtent / maxPadding;

                                    return Padding(
                                      padding: EdgeInsets.only(
                                        left: (diff / carouselRatio).abs(),
                                        right: (diff / carouselRatio).abs(),
                                      ),
                                      child: child,
                                    );
                                  },
                                  child: ContactCard(
                                    item,
                                    onEdit: () => showDialog(
                                      context: context,
                                      builder: (context) => const SimpleDialog(
                                        title: Text("Hi"),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        )
                      : const Center(
                          child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("You have no contacts to show."),
                          ],
                        )),
            ),
          ],
        ),
      ),
    );
  }
}
