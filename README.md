# RecSesh

## Overview
This is a Flutter app for recording quick music ideas through a phone's mic. 

Bluetooth support could be added in the future.


> At the moment, iOS will not be tested (since my Mac died on me).
I will make a future update to support (at least) iOS.


### MVVM Architecture
This project uses ValueNotifiers with MVVM architecture instead of a state management package.

I've used BLoC, Provider and Riverpod, but switching between them (between different jobs) has been a pain and ValueNotifiers have proven to be a great solution when implemented correctly.