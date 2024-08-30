import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';

class DeviceInfoScreen extends StatefulWidget {
  const DeviceInfoScreen({super.key});

  @override
  State<DeviceInfoScreen> createState() => _DeviceInfoScreenState();
}

class _DeviceInfoScreenState extends State<DeviceInfoScreen> {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  AndroidDeviceInfo? androidInfo;
  IosDeviceInfo? iosInfo;

  @override
  void initState() {
    super.initState();

    _initDeviceInfo();
  }

  Future<void> _initDeviceInfo() async {
    try {
      if (Platform.isAndroid) {
        androidInfo = await deviceInfo.androidInfo;
        print(androidInfo!.display);
        // final a = androidInfo!.fingerprint;
      } else if (Platform.isIOS) {
        iosInfo = await deviceInfo.iosInfo;
      }
      setState(() {});
    } catch (e) {
      print('Failed to get device info: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
          appBar: AppBar(
            title: const Text('Device Info'),
            bottom: const TabBar(
              tabs: [
                Tab(
                  text: "General",
                ),
                Tab(icon: Icon(Icons.settings)),
                Tab(icon: Icon(Icons.info)),
              ],
            ),
          ),
          body: TabBarView(children: [
            // Tab 1
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ListView(
                children: androidInfo != null
                    ? [
                        Row(
                          children: [
                            const Expanded(flex: 1, child: Text("Device")),
                            Expanded(flex: 1, child: Text(androidInfo!.model)),
                          ],
                        ),
                        Row(
                          children: [
                            const Expanded(flex: 1, child: Text("Manufacturer")),
                            Expanded(flex: 1, child: Text(androidInfo!.manufacturer)),
                          ],
                        ),
                        Row(
                          children: [
                            const Expanded(flex: 1, child: Text("Board")),
                            Expanded(flex: 1, child: Text(androidInfo!.board)),
                          ],
                        ),
                        Row(
                          children: [
                            const Expanded(flex: 1, child: Text("Bootloader")),
                            Expanded(flex: 1, child: Text(androidInfo!.bootloader)),
                          ],
                        ),
                        Row(
                          children: [
                            const Expanded(flex: 1, child: Text("Brand")),
                            Expanded(flex: 1, child: Text(androidInfo!.brand)),
                          ],
                        ),
                        Row(
                          children: [
                            const Expanded(flex: 1, child: Text("Display")),
                            Expanded(flex: 1, child: Text(androidInfo!.display)),
                          ],
                        ),
                        Row(
                          children: [
                            const Expanded(flex: 1, child: Text("Fingerprint")),
                            Expanded(flex: 1, child: Text(androidInfo!.fingerprint)),
                          ],
                        ),
                        Row(
                          children: [
                            const Expanded(flex: 1, child: Text("Hardware")),
                            Expanded(flex: 1, child: Text(androidInfo!.hardware)),
                          ],
                        ),
                        Row(
                          children: [
                            const Expanded(flex: 1, child: Text("Host")),
                            Expanded(flex: 1, child: Text(androidInfo!.host)),
                          ],
                        ),
                        Row(
                          children: [
                            const Expanded(flex: 1, child: Text("Id")),
                            Expanded(flex: 1, child: Text(androidInfo!.id)),
                          ],
                        ),
                        Row(
                          children: [
                            const Expanded(flex: 1, child: Text("Product")),
                            Expanded(flex: 1, child: Text(androidInfo!.product)),
                          ],
                        ),
                        Row(
                          children: [
                            const Expanded(flex: 1, child: Text("Serial Number")),
                            Expanded(flex: 1, child: Text(androidInfo!.serialNumber)),
                          ],
                        ),
                        Row(
                          children: [
                            const Expanded(flex: 1, child: Text("Supported 32Bit Abis")),
                            Expanded(flex: 1, child: Text(androidInfo!.supported32BitAbis.toString())),
                          ],
                        ),
                        Row(
                          children: [
                            const Expanded(flex: 1, child: Text("Supported 64Bit Abis")),
                            Expanded(flex: 1, child: Text(androidInfo!.supported64BitAbis.toString())),
                          ],
                        ),
                        Row(
                          children: [
                            const Expanded(flex: 1, child: Text("Tags")),
                            Expanded(flex: 1, child: Text(androidInfo!.tags)),
                          ],
                        ),
                        Row(
                          children: [
                            const Expanded(flex: 1, child: Text("Type")),
                            Expanded(flex: 1, child: Text(androidInfo!.type)),
                          ],
                        ),
                        // Row(
                        //   children: [
                        //     const Expanded(flex: 1, child: Text("Version")),
                        //     Expanded(flex: 1, child: Text(androidInfo!.version.toString())),
                        //   ],
                        // ),
                        // Row(
                        //   children: [
                        //     const Expanded(flex: 1, child: Text("Data")),
                        //     Expanded(flex: 1, child: Text(androidInfo!.data.toString())),
                        //   ],
                        // ),
                      ]
                    : [
                        const Center(child: Text('Loading device info...')),
                      ],
              ),
            ),
            // Tab 2: Settings
            const Center(child: Text('Settings Tab')),
            // Tab 3: About
            const Center(child: Text('About Tab')),
          ])),
    );
  }
}
