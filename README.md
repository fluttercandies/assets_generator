# assets_generator

auto generate assets configs in yaml.

- [assets_generator](#assetsgenerator)
  - [Usage](#usage)
    - [Import](#import)
    - [Prepare the Environment](#prepare-the-environment)
    - [Execute Command](#execute-command)

## Usage

### Import

```dart

dev_dependencies:
  assets_generator: ^1.0.2 

```

###  Prepare the Environment

you need to add pub bin path into your system path.
	
| Platform       |     Cache  location     |
| -------------- | :---------------------: |
| macOS or Linux |  $HOME/.pub-cache/bin   |
| Windows*       | %APPDATA%\Pub\Cache\bin |

[pub global](https://dart.dev/tools/pub/cmd/pub-global)

### Execute Command

- `pub global activate assets_generator`

- `assets_generator path=xxxx type=0`

| Parameter |       Description        |      Default      |
| --------- | :----------------------: | :---------------: |
| path      |    your project path     | current directory |
| Windows*  | 0 = directory ; 1 = file |         0         |