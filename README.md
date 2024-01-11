# drift_background_isolate_starter

## Overview

This code employs Dart's Isolate to handle resource-intensive tasks such as network requests and database operations in the background, ensuring the app's UI responsiveness. This approach is particularly valuable in situations where maintaining a seamless UI experience is critical during time-consuming operations. 😊

## Details of this approach

This repository utilizes isolates to execute resource-intensive tasks in the background. It retrieves user data from an API, performs a computational task, and inserts the data into a database, all within an isolate. Meanwhile, the UI remains responsive by actively listening for messages from the isolate. Upon receiving a 'done' message, it displays a snackbar and loads the user data. This methodology ensures a smooth UI performance even during time-consuming operations. To assess the UI's smoothness, a CircularProgressIndicator has been added, allowing observation of the loading indicator's smooth operation.

## Flow of the app

<img width="1652" alt="image" src="https://github.com/Meshkat-Shadik/DriftBackgroundIsolateStarter/assets/31488481/daa53717-abb0-4d0f-8e30-f2dc86dc0f63">

## Video Representation

[background_isolate.webm](https://github.com/Meshkat-Shadik/DriftBackgroundIsolateStarter/assets/31488481/a0694798-2e4d-4ea5-b58e-b1ca9614e0e1)

### Points to be noted

- In the first button click, all computations are carried out on the Main Isolate. As a result, a noticeable lag effect is observed on the CircularProgressIndicator when the computation runs on the Main Isolate.
- However, in the second button, all tasks are executed in the Background Isolate, eliminating any lag effects on the CircularProgressIndicator.
