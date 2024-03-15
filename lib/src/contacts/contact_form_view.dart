import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:pullodex/src/contacts/contact_form.dart';

class ContactFormView extends StatelessWidget {
  const ContactFormView({super.key, this.contact});

  static const routeName = '/form/';
  final Contact? contact;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Contact'),
      ),
      body: Center(
        child: Column(
          children: [
            contact == null
                ? ContactForm(
                    onSubmit: (contact) async {
                      await contact.insert();
                      if (context.mounted) {
                        Navigator.pop(context);
                      }
                    },
                  )
                : ContactForm(
                    onSubmit: (newContact) async {
                      await newContact.update();
                      if (context.mounted) {
                        Navigator.pop(context);
                      }
                    },
                    contact: contact,
                  ),
          ],
        ),
      ),
    );
  }
}
