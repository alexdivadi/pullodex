import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pullodex/src/validators.dart';

class ContactForm extends StatefulWidget {
  const ContactForm({
    super.key,
    this.onSubmit,
    this.contact,
  });

  final Function(Contact)? onSubmit;
  final Contact? contact;

  @override
  State<ContactForm> createState() => _ContactFormState();
}

class _ContactFormState extends State<ContactForm> {
  final _contactFormKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _linkedInController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  Uint8List? _imageController;

  @override
  void initState() {
    final SocialMedia? linkedIn = widget.contact?.socialMedias.firstWhere(
        (element) => element.label == SocialMediaLabel.linkedIn,
        orElse: () => SocialMedia(""));

    _firstNameController.text = widget.contact?.name.first ?? "";
    _lastNameController.text = widget.contact?.name.last ?? "";
    _phoneController.text = widget.contact?.phones.firstOrNull?.number ?? "";
    _emailController.text = widget.contact?.emails.firstOrNull?.address ?? "";
    _linkedInController.text = linkedIn?.userName ?? "";
    _notesController.text = widget.contact?.notes.firstOrNull?.note ?? "";
    _imageController = widget.contact?.photoOrThumbnail;
    super.initState();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _linkedInController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (widget.onSubmit != null &&
        _contactFormKey.currentState != null &&
        _contactFormKey.currentState!.validate()) {
      widget.onSubmit!(
        Contact(
          id: widget.contact?.id ?? "",
          isStarred: widget.contact?.isStarred ?? false,
          displayName: widget.contact?.displayName ??
              ((_lastNameController.text.isEmpty)
                  ? _firstNameController.text
                  : "${_firstNameController.text} ${_lastNameController.text}"),
          name: Name(
            first: _firstNameController.text,
            last: _lastNameController.text,
          ),
          phones: [
            Phone(_phoneController.text),
            if (widget.contact != null) ...widget.contact!.phones
          ],
          emails: [
            Email(_emailController.text),
            if (widget.contact != null) ...widget.contact!.emails
          ],
          socialMedias: [
            SocialMedia(
              _linkedInController.text,
              label: SocialMediaLabel.linkedIn,
            ),
            if (widget.contact != null) ...widget.contact!.socialMedias
          ],
          notes: [
            Note(_notesController.text),
            if (widget.contact != null) ...widget.contact!.notes
          ],
          photo: _imageController,
          accounts: widget.contact?.accounts,
          events: widget.contact?.events,
          organizations: widget.contact?.organizations,
          groups: widget.contact?.groups,
          websites: widget.contact?.websites,
          addresses: widget.contact?.addresses,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _contactFormKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        children: [
          Card(
            child: Container(
              width: 600,
              height: 550,
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: const Color.fromARGB(255, 121, 121, 121),
                    ),
                    height: 315,
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 5.0),
                                child: Container(
                                  height: 80,
                                  width: 85,
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.white)),
                                  child: GestureDetector(
                                    onTap: () async {
                                      final XFile? image =
                                          await _picker.pickImage(
                                              source: ImageSource.gallery);
                                      if (image != null) {
                                        final bytes = await image.readAsBytes();
                                        setState(() {
                                          _imageController = bytes;
                                        });
                                      }
                                    },
                                    child: (_imageController == null)
                                        ? const Icon(
                                            Icons.person_add,
                                            size: 50,
                                            color: Colors.grey,
                                          )
                                        : Stack(
                                            fit: StackFit.expand,
                                            children: [
                                                Image.memory(_imageController!),
                                                IconButton(
                                                    alignment:
                                                        Alignment.topRight,
                                                    onPressed: () =>
                                                        setState(() {
                                                          _imageController =
                                                              null;
                                                        }),
                                                    icon: const Icon(
                                                      Icons.cancel,
                                                      color: Colors.red,
                                                    )),
                                              ]),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Container(
                              height: 85,
                              width: 250,
                              decoration: const BoxDecoration(
                                  color: Color.fromARGB(255, 22, 56, 30),
                                  borderRadius: BorderRadius.vertical(
                                      bottom: Radius.circular(4))),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5.0),
                              child: Row(
                                children: [
                                  Flexible(
                                    flex: 1,
                                    child: TextFormField(
                                      controller: _firstNameController,
                                      validator: requireValue,
                                      decoration: const InputDecoration(
                                        labelText: "First Name",
                                        labelStyle: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: Color.fromARGB(
                                              255, 225, 224, 224),
                                        ),
                                        errorStyle: TextStyle(
                                          color: Colors.redAccent,
                                        ),
                                      ),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                    flex: 1,
                                    child: TextFormField(
                                      controller: _lastNameController,
                                      decoration: const InputDecoration(
                                        labelText: "Last Name",
                                        labelStyle: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: Color.fromARGB(
                                              255, 225, 224, 224),
                                        ),
                                        errorStyle: TextStyle(
                                          color: Colors.redAccent,
                                        ),
                                      ),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Flexible(
                          child: Container(
                            width: 340,
                            decoration: const BoxDecoration(
                              color: Color.fromARGB(255, 159, 237, 187),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
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
                                    Expanded(
                                      child: TextFormField(
                                        controller: _phoneController,
                                        validator: phoneValidator,
                                        textAlign: TextAlign.left,
                                        style: const TextStyle(
                                          color: Colors.black,
                                        ),
                                        decoration: const InputDecoration(
                                          hintText: "Phone Number",
                                          hintStyle: TextStyle(
                                            color: Color.fromARGB(
                                                219, 129, 128, 128),
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
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
                                    Expanded(
                                      child: TextFormField(
                                        controller: _emailController,
                                        validator: emailValidator,
                                        textAlign: TextAlign.left,
                                        decoration: const InputDecoration(
                                          hintText: "Email",
                                          hintStyle: TextStyle(
                                            color: Color.fromARGB(
                                                219, 129, 128, 128),
                                            fontSize: 12,
                                          ),
                                        ),
                                        style: const TextStyle(
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
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
                                    Expanded(
                                      child: TextFormField(
                                        controller: _linkedInController,
                                        textAlign: TextAlign.left,
                                        decoration: const InputDecoration(
                                          hintText: "LinkedIn profile",
                                          hintStyle: TextStyle(
                                            color: Color.fromARGB(
                                                219, 129, 128, 128),
                                            fontSize: 12,
                                          ),
                                        ),
                                        style: const TextStyle(
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 4.0),
                    child: Divider(),
                  ),
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.draw,
                            color: Colors.lightBlue,
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 5.0),
                            child: TextFormField(
                              controller: _notesController,
                              expands: false,
                              minLines: 1,
                              maxLines: 5,
                              decoration: const InputDecoration(
                                hintText: "Notes...",
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: ElevatedButton.icon(
              label: const Text("Save Contact"),
              icon: const Icon(
                Icons.check_circle,
                color: Colors.green,
              ),
              onPressed: _submitForm,
            ),
          ),
        ],
      ),
    );
  }
}
