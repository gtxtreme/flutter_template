<img align="left" src="flutter_template_github.svg" width="480" height="440" />

<div>
  <a href="https://www.wednesday.is?utm_source=gthb&utm_medium=repo&utm_campaign=serverless" align="left"><img src="https://uploads-ssl.webflow.com/5ee36ce1473112550f1e1739/5f5879492fafecdb3e5b0e75_wednesday_logo.svg"></a>
  <p>
    <h1 align="left">Flutter Template</h1>
  </p>
  <p>
  A Flutter template application showcasing - Clean architecture, Responsive design, State management, Dependency Injection, Widget and Unit testing, Navigation, Localization, Continuous Integration and Continuous Deployment.
  </p>

  ___


  <p>
    <h4>
      Expert teams of digital product strategists, developers, and designers.
    </h4>
  </p>

  <div>
    <a href="https://www.wednesday.is/contact-us?utm_source=gthb&utm_medium=repo&utm_campaign=serverless" target="_blank">
      <img src="https://uploads-ssl.webflow.com/5ee36ce1473112550f1e1739/5f6ae88b9005f9ed382fb2a5_button_get_in_touch.svg" width="121" height="34">
    </a>
    <a href="https://github.com/wednesday-solutions/" target="_blank">
      <img src="https://uploads-ssl.webflow.com/5ee36ce1473112550f1e1739/5f6ae88bb1958c3253756c39_button_follow_on_github.svg" width="168" height="34">
    </a>
  </div>

  ___

<span>We’re always looking for people who value their work, so come and join us. <a href="https://www.wednesday.is/hiring">We are hiring!</a></span>
</div>

## Getting Started
Clone the repo and run the following commands to setup the project.

#### Get Dependencies
```shell
flutter pub get
```
#### Run Code Generation
```shell
scripts/generate-all.sh
```

Read the [scripts documentation](scripts/README.md) to learn about all the scrips used in the project.

## Architecture
The architecture of the template facilitates seperation of concerns and avoids tight coupling between it's various layers. The goal is to have the ability to make changes to individual layers without affecting the entire app. This architecture is an adaptation of concepts from [`The Clean Architecture`](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html).

### Layers
The architecture is separeted into the following layers
- [`lib/presentation`](lib/presentation): All UI and state management elements like widgets, pages and view models.
- [`lib/navigation`](lib/navigation): navigators to navigate between destinations.
- [`lib/interactor`](lib/interactor): provides feature specific functionality.
- [`lib/domain`](lib/domain): use cases for individual pieces of work.
- [`lib/repository`](lib/repository): repositories to manage various data sources.
- [`lib/services`](lib/services): services provide access to external elements such as databases, apis, etc.

Each layer has a `di` directory to manage Dependency Injection for that layer.

### Entities
The layers `presentation`, `domain` and `services` each have an `entity` directory.
- [`lib/presentation/entity`](lib/presentation/entity): Classes that model the visual elements used by the widgets.
- [`lib/domain/entity`](lib/domain/entity): Model classes for performing business logic manipulations. They act as a abstraction to hide the local and remote data models.
- [`lib/services/entity`](lib/services/entity): Contains local models (data classes for the database) and remote models (data classes for the api).

#### Entity Naming Convention
- Presentation entities are prefixed with `UI` (eg: UICity).
- Domain entites do not have any prefix. (eg: City).
- Service entities are of 2 types:
  - Local / Database entites are prefixed with `Local` (eg: LocalCity).
  - Remote / API entitiess are prefixed with `Remote` (eg: RemoteCity).

### Other Directories
Apart from the main layers, the template has
- [`lib/foundation`](lib/foundation): Extentions on primitive data types, loggers, global type alias etc.
- [`lib/flavors`](lib/flavors): Flavor i.e. Environment reledated classes.
- [`lib/entrypoints`](lib/entrypoints): Target files for flutter to run for each flavor.
- [`lib/app.dart`](lib/app.dart): App initialization code.

## Understanding the Presentation Layer
The presentation layer houses all the visual components and state management logic.

The [`base`](lib/presentation/base) directory has all the resuable and common elements used as building blocks for the UI like common widgets, app theme data, exceptions, base view models etc.

### View Model
State Management is done using the [`riverpod`](https://riverpod.dev/) along with [`state_notifier`](https://pub.dev/packages/state_notifier). The class that manages state is called the `View Model`. 

Each `View Model` is a sub class of the `BaseViewModel`. The [`BaseViewModel`](lib/presentation/base/view_model_provider/base_view_model.dart) is a `StateNotifier` of [`ScreenState`](#screen-state). Along with the ScreenState it also exposes a stream of [`Effect`](#effect). 

Implementations of the BaseViewModel can also choose to handle [`Intents`](#intent).

### Screen State
[`ScreenState`](lib/presentation/entity/screen/screen_state.dart) encapsulates all the state required by a [`Page`](#page). State is any data that represents the current situtation of a Page.

For example, the [`HomeScreenState`](lib/presentation/destinations/weather/home/home_screen_state.dart) holds the state required by the [`HomePage`](lib/presentation/destinations/weather/home/home_page.dart).

### Effect
[`Effects`](lib/presentation/entity/effect/effect.dart) are events that take place on a page that are not part of the state of the screen. These usually deal with UI elements that are not part of the widget tree.

Showing a snackbar or hiding the keyboard are examples of an effect.


### Intent
Intent is any action takes place on page. It may or may not be user initiated. 

[`SearchScreenIntent`](lib/presentation/destinations/weather/search/search_screen_intent.dart) has the actions that can happen on the [`SearchPage`](lib/presentation/destinations/weather/search/search_page.dart).

### Page
A page is a widget that the navigator can navigate to. It should return the [`BasePage`](lib/presentation/base/page/base_page.dart) widget. 

The `BasePage` creates the structure for the page, initialises the [`ViewModel`](#view-model) and provides the view model in the widget tree so that all the children have access to it. It also listens to the effects from the view model and notifies the page about it.

Each page accepts the [`Screen`](#screen) object as input.

### Screen
A [`Screen`](lib/presentation/entity/screen/screen.dart) is a class that represents a `Page` in the context of navigation. It holds the `path` used by the navigator to navigate to a `Page` and also holds any arguments required to navigate to that `Page`.

## Flavors
The template comes with built-in support for 3 flavors. Each flavor uses a diffrent `main.dart` file.
- Dev - [`main_dev.dart`](lib/entrypoints/main_dev.dart)
- QA - [`main_qa.dart`](lib/entrypoints/main_qa.dart)
- Prod - [`main_prod.dart`](lib/entrypoints/main_prod.dart)

You can setup any environment specific values in the respective `main.dart` files.

To run a specific falvor you need to specify the flavor and target file.
```shell
 flutter run --flavor qa -t lib/entrypoints/main_qa.dart
```

**To avoid specifying all the flags every time, use the [`run.sh`](scripts/README.md#run) script**

Read the [scripts documentation](scripts/README.md) to learn about all the scrips used in the project.
 
## Content
The Flutter Template contains:
- A [`Flutter`](https://flutter.dev/) application.
- Built-in support for 3 [`flavors`](https://docs.flutter.dev/deployment/flavors) - `dev`, `qa` and `prod`.
- A [`reactive base architectire`](#architecture) for your application.
- [`Riverpod`](https://riverpod.dev/) along with [`state_notifier`](https://pub.dev/packages/state_notifier) for state management.
- [`Drift`](https://drift.simonbinder.eu/) as local database for storage.
- [`Dio`](https://github.com/flutterchina/dio) for making API calls.
- [`Freezed`](https://pub.dev/packages/freezed) for data class functionality.
- [`Get It`](https://pub.dev/packages/get_it) for dependency injection.
- [`Flutter Lints`](https://pub.dev/packages/flutter_lints) for linting.

The template contains an example (displaying weather data) with responsive widgets, reactive state management, offline storage and api calls.

## Requirements
The template was build using dart null safety. Dart 2.12 or greater and Flutter 2 or greater is required. 

Dart 2.15 or greater and Flutter 2.10 or greater is recommended.

[Follow this guide to setup your flutter environment](https://docs.flutter.dev/get-started/install) based on your platform.

## Continuous Integration and Deployment
The Flutter template comes with built in support for CI/CD using Github Actions.

### CI
The [`CI`](.github/workflows/ci.yml) workflow performs the following checks on every pull request:
- Lints the code with `flutter analyze`.
- Runs tests using `flutter test`.
- Build the android app.
- Build the ios app.

### CD
The [`CD`](.github/workflows/cd.yml) workflow performs the following actions:
- Bump the build number by 1.
- Build a signed release apk.
- Upload apk to app center.
- Upload apk as artifact to release tag.
- Build a signed iOS app.
- Upload ipa to testflight.
- Upload ipa as artifact to release tag.
- Commit the updated version to git.

### Android CD setup
For the android CD workflow to run, we need to perform the following setup steps:
- Follow these instructions to [generate an upload keystore](https://developer.android.com/studio/publish/app-signing#generate-key). Note down the `store password`, `key alias` and `key password`. You will need these in later steps.
- Use `openssl` to convert the `jks` file to `Base64`.
```shell
openssl base64 < flutter_template_keystore.jks | tr -d '\n' | tee flutter_template_keystore_encoded.txt
```
- Store the `base64` output on [`Github Secrets`](https://docs.github.com/en/actions/security-guides/encrypted-secrets) with the key name `KEYSTORE`.
- Save the `store password` in github secrets with key name `RELEASE_STORE_PASSWORD`.
- Save the `key alias` in github secrets with key name `RELEASE_KEY_ALIAS`.
- Save the `key password` in github secrets with key name `RELEASE_KEY_PASSWORD`.
- [Create a distribution on app center](https://docs.microsoft.com/en-us/appcenter/distribution/) and get the upload key. You can get it from from appcenter.ms/settings.
- Save the app center upload key on github secrets with key name `APP_CENTER_TOKEN`.

### Pushing to protected branches
- If the branches that you will be running CD on are protected, you will need to use a [`Personal Access Token (PAT)`](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token) to commit the version changes.
- After creating the `PAT`, exclude the account that the token belongs to from the [`branch protection rules`](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/defining-the-mergeability-of-pull-requests/managing-a-branch-protection-rule#creating-a-branch-protection-rule).
- Save the token in github secrets and update the key name in the `cd.yml` file under each `checkout` action.
- Since our `CD` workflow is triggered on a push, and we create a new commit in the workflow itself, the commit message created by the `CD` workflow includes `[skip ci]` tag so that the workflow does not end up in an infinite loop.

**If you do not plan to use the CD workflow on protected branches, you can remove the token part from the checkout actions.**

## Gotchas
- Flutter apps might have issues on some android devices with variable refresh rate where the app is locked at 60fps instead of running at the highests refresh rate. This might make your app look like it is running slower than other apps on the device. To fix this the template uses the [`flutter_displaymode`](https://pub.dev/packages/flutter_displaymode) package. The template sets the highest refresh rate available. If you don't want this behaviour you can remove the lines 40 to 46 in [`app.dart`](lib/app.dart#L40). [`Link to frame rate issue on flutter`](https://github.com/flutter/flutter/issues/35162).

