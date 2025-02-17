# Introducing Abelese - The Perfect Companion To Elevate Your Weeknd Experience

![Abelese Demo](https://github.com/brashanm/Abelese/assets/97188295/7736c731-76f4-451b-8029-9f54b8b04499)

## Overview
Abelese isn't just any other music app. It's an immersive experience designed to break down language barriers and amplify the global accessibility of The Weeknd's lyrics. It all started when I wanted to help out my cousin, who struggled to understand The Weeknd's songs due to the language barrier. Hence, came Abelese, which seamlessly integrates technology to transcend borders.

## Inspiration
The journey began when a cousin, unfamiliar with English, shared their love for The Weeknd's music but struggled to understand the lyrics. This sparked the creation of Abelese, an app designed to provide a seamless experience by integrating The Weeknd's songs with real-time translations.

## Features
* Real-time Translation: Abelese uses Firebase and a REST API, integrating the LibreTranslate API to provide instant translation of The Weeknd's lyrics into over 30 languages. Users can immerse themselves in the essence of the songs, breaking down linguistic barriers effortlessly.
* Extensive Song Library: The app houses a Cloud Firestore database populated with a comprehensive collection of over 100 songs by The Weeknd, ensuring that fans can explore and connect with the artist's entire discography at their fingertips.
* Uses Combine to reactively and asynchronously grab and translate data and Core Data to cache song data to reduce calls to the Cloud Firestore
* MVVM Architecture: Built with Swift and SwiftUI, Abelese adheres to the Model-View-ViewModel (MVVM) architectural pattern, ensuring code organization and maintainability. This thoughtful approach enhances the app's performance and sets the stage for seamless future developments.

## How it's Built
Abelese is the result of Swift, SwiftUI and a bit of love, leveraging the power of Firebase for real-time updates and data storage. The Cloud Firestore database forms the backbone, housing an extensive collection of The Weeknd's songs. The integration of the LibreTranslate API allows users to dynamically translate lyrics.
