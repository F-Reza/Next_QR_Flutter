import 'dart:io';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ServiceProvider extends ChangeNotifier {

//provider.mailContact(model.email!);

  Future<void> callContact(String number) async {
    final uri = Uri.parse('tel:$number');

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Cannot launch call app';
    }
  }

  Future<void> messageContact(String number) async {
    final uri = Uri.parse('sms:$number');

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Cannot launch message app';
    }
  }

  Future<void> mailContact(String mail) async {
    final uri = Uri.parse('mailto:$mail');

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Cannot launch mail app';
    }
  }

  Future<void> webContact(String web) async {
    final uri = Uri.parse('https:$web');

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Cannot launch browser';
    }
  }

  Future<void> locateContact(String address) async {
    String urlString = '';
    if (Platform.isAndroid) {
      urlString = 'geo:00?q=$address';
    } else if (Platform.isIOS) {
      urlString = 'https://maps.apple.com/q=$address';
    }

    final uri = Uri.parse(urlString);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Cannot launch map';
    }
  }



}