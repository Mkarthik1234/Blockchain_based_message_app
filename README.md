# block_talk_v2

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.







truffle configeration:
    truffle init
    truffle create contract <contract_name>
    truffle compile
    inside pubspec.yaml -> assets build/contracts
    inside truffle-config.js -> development: {
                                        host: "127.0.0.1",     // Localhost (default: none)
                                        port: 7545,            // Standard Ethereum port (default: none)
                                        network_id: "*",       // Any network (default: none)
                                        },
                              -> compilers { solc {  version: "0.5.1"
    truffle migrate
