import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
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
      width: 300,
      height: 250,
      padding: const EdgeInsets.all(8),
      child: GestureDetector(
        onDoubleTap: onEdit,
        child: Card(
          child: DefaultTextStyle.merge(
            style: TextStyle(fontFamily: GoogleFonts.merriweather().fontFamily),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: const Color.fromARGB(255, 121, 121, 121),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 85,
                          height: 85,
                          child: Center(
                            child: (contact.thumbnail != null)
                                ? Image.memory(contact.thumbnail!)
                                : Container(
                                    height: 85,
                                    width: 85,
                                    decoration: BoxDecoration(
                                        border:
                                            Border.all(color: Colors.white)),
                                    child: const Icon(
                                      Icons.person,
                                      size: 50,
                                      color: Colors.grey,
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Container(
                          width: 210,
                          height: 85,
                          color: const Color.fromARGB(255, 159, 237, 187),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Container(
                                decoration: const BoxDecoration(
                                    color: Color.fromARGB(255, 22, 56, 30),
                                    borderRadius: BorderRadius.vertical(
                                        bottom: Radius.circular(4))),
                                child: Center(
                                  child: FittedBox(
                                    child: Text(
                                      contact.displayName,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.phone,
                                    color: Colors.grey,
                                    size: 20,
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    contact.phones.firstOrNull?.number ??
                                        "Phone not provided",
                                    textAlign: TextAlign.left,
                                    style: const TextStyle(color: Colors.black),
                                  ),
                                ],
                              ),
                              if (contact.emails.isNotEmpty)
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.email,
                                      color: Colors.grey,
                                      size: 20,
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      contact.emails.first.address,
                                      textAlign: TextAlign.left,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              if (contact.socialMedias.isNotEmpty &&
                                  contact.socialMedias.any((account) =>
                                      account.label ==
                                      SocialMediaLabel.linkedIn))
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.link,
                                      color: Colors.grey,
                                      size: 20,
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      contact.socialMedias.first.userName,
                                      textAlign: TextAlign.left,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 4.0),
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
                            Expanded(
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
      ),
    );
  }
}
