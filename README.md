# drift_background_isolate_starter

## Overview
This code uses Dart's `Isolate` to perform heavy tasks like network requests and database operations in the background, keeping the app's UI responsive. It's useful in scenarios where maintaining a smooth UI is crucial while performing time-consuming operations. 😊

## Details of this approach
This repo uses isolates to perform heavy tasks in the background. It fetches user data from an API, performs a computational task, and inserts the data into a database, all within an isolate. The UI remains responsive, listening for messages from the isolate. When a 'done' message is received, it shows a snackbar and loads the user data. This approach keeps the UI smooth while performing time-consuming operations. 
To check the UI is smooth or not, I've added a `CircularProgressIndicator` to check, it the loading indicator is running smoothly or not!

## Flow of the app
<img width="1652" alt="image" src="https://github.com/Meshkat-Shadik/DriftBackgroundIsolateStarter/assets/31488481/daa53717-abb0-4d0f-8e30-f2dc86dc0f63">

## Video Representation

[background_isolate.webm](https://github.com/Meshkat-Shadik/DriftBackgroundIsolateStarter/assets/31488481/a0694798-2e4d-4ea5-b58e-b1ca9614e0e1)

### Point to be noted
- In the first button clicked, I did all the computation on the Main Isolate, so we can see there is a bit `laggy-effect` on the `CircularProgressIndicator` when the computation is running on the MainIsolate.
- But in the second button, all things executed in the `BackgroundIsolate` so that there is `no laggy-effect` on the `CircularProgressIndicator`.
