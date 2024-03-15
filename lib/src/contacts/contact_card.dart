import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:google_fonts/google_fonts.dart';

class ContactCard extends StatelessWidget {
  const ContactCard(
    this.contact, {
    super.key,
    this.leading,
    this.onEdit,
  });

  final Contact contact;
  final Widget? leading;
  final VoidCallback? onEdit;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      width: 300,
      padding: const EdgeInsets.all(8),
      child: Card(
        child: DefaultTextStyle.merge(
          style: TextStyle(fontFamily: GoogleFonts.merriweather().fontFamily),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    if (contact.thumbnail != null)
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Image.memory(contact.thumbnail!),
                      ),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            contact.displayName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.phone,
                                color: Colors.grey,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(contact.phones.firstOrNull?.number ??
                                  "Phone not provided"),
                            ],
                          ),
                          if (contact.emails.isNotEmpty)
                            Row(
                              children: [
                                const Icon(
                                  Icons.email,
                                  color: Colors.grey,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  contact.emails.first.address,
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                          if (contact.socialMedias.isNotEmpty)
                            Text(contact.socialMedias.first.userName),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Align(
                      alignment: Alignment.topRight,
                      child: GestureDetector(
                        onTap: onEdit,
                        child: const Icon(Icons.edit),
                      ),
                    )
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Divider(),
                ),
                if (contact.notes.isNotEmpty)
                  Expanded(
                    child: ListView.builder(
                      controller: null,
                      itemCount: min(3, contact.notes.length),
                      itemBuilder: (context, index) => Row(
                        children: [
                          const Icon(
                            Icons.draw,
                            color: Colors.lightBlue,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Flexible(
                            child: Text(
                              contact.notes[index].note,
                              maxLines: 3,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
