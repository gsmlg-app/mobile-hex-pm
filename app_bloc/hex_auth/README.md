# Bloc package hex_auth

## Getting started

Import package in project.

```yaml
hex_auth_bloc: any
```

## Usage

Import bloc in provider

```dart
import 'package:hex_auth_bloc/hex_auth_bloc.dart';


BlocProvider<HexAuthBloc>(
    create: (BuildContext context) => HexAuthBloc(),
),

```
