# Contributing to Monopoly Ant

First off, thank you for considering contributing to Monopoly Ant! It's people like you that make the open source community such an amazing place to learn, inspire, and create.

## How Can I Contribute?

### Reporting Bugs
- Check the [Issues](https://github.com/[your-username]/monopoly_flutter/issues) to see if the bug has already been reported.
- If not, open a new issue. Include a clear title, a description of the problem, and steps to reproduce the issue.

### Suggesting Enhancements
- Open a new issue with the tag "enhancement".
- Describe the feature you'd like to see and why it would be useful.

### Pull Requests
1. Fork the repository.
2. Create a new branch (`git checkout -b feature/amazing-feature`).
3. Make your changes and ensure they follow the project's code style.
4. Write tests for your changes if applicable.
5. Commit your changes (`git commit -m 'feat: add some amazing feature'`).
6. Push to the branch (`git push origin feature/amazing-feature`).
7. Open a Pull Request.

## Code Style
- Follow the official [Dart style guide](https://dart.dev/guides/language/evolutionary-design).
- Use `flutter format .` before committing.
- Ensure `flutter analyze` passes without errors or warnings.

## Local Setup
1. Clone your fork.
2. Run `flutter pub get`.
3. Run `flutter pub run build_runner build --delete-conflicting-outputs` to generate Hive adapters.
4. Run the app with `flutter run`.

## License
By contributing, you agree that your contributions will be licensed under its MIT License.
