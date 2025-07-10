# Bloc package favorite_package

## Getting started

Import package in project.

```yaml
favorite_package_bloc: any
```

## Usage

Import bloc in provider

```dart
import 'package:favorite_package_bloc/favorite_package_bloc.dart';


BlocProvider<FavoritePackageBloc>(
    create: (BuildContext context) => FavoritePackageBloc(),
),

```
