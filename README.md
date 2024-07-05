# निरामय

## free from illness.
Niramaya is a mental health assistant and monitor app that becomes a virtual therapy assistant for you and also creates an in-depth mental health report for you. Apart from this there are several diagnosis tests which help you determine the severity of your mental illness. 

## Getting Started

Download the app from this website - [Niramaya - Apphost](https://appho.st/d/1uHwjk8U)

Youtube Link - [Niramaya Youtube Explanation](https://www.youtube.com/watch?v=zFcgxMAaYa8)

Or - Clone this repository and run these commands:
```
flutter clean
flutter pub get
flutter build apk
```
## Problem Statement

The problem statement for the hackathon was -
AI-Driven Mental Health Monitoring and Support:

Many individuals with mental health issues do not receive timely intervention due to the stigma and lack of accessible resources. Create an AI system that monitors users' mental health through their interactions (e.g., text, voice) and provides real-time support and resources tailored to their needs.

Objective: Promote mental well-being by offering an unobtrusive and accessible AI-based tool that helps detect early signs of mental health issues and provides personalized support.

Hackathon Link: [Prasunethon 2024](https://unstop.com/hackathons/prasunethon-prasunet-company-1018553)

## Our Solution:

We decided to design an app that conquers the social stigma associated with mental health by bringing to you a friendly neighborhood virtual therapy assistant named Dawn. Apart from this, it also has these features:

* Diary analysis to give mental health report
* Diagnosis tests to determine the severity of your specific illness which save time and energy of commuting to a mental health clinic
* Guess my mood game which calculates your average mood by detecting your facial emotions to various scenarios (Side note: This feature currently only works when I run the django emotion recognition server on my local machine. The repository for this can be found [here](https://github.com/gargibendale/face_recognition_api))
* Helpline numbers and links to mental health foundations from all over India
* A medicine and sleep time tracker which notifies you to take the medications at set time
* Links to various mental health exercises

## Tech

* Frontend
  * Flutter
* Backend
  * Django
  * Gemini (GenAI)
  * DeepFace (Emotion Detection)
* Tools
  * Vercel for diary analysis api endpoint
  * Firebase
  * Ngrok for static emotion recognition api endpoint
    
## App Preview

### Home Page
![Untitled design](https://github.com/gargibendale/niramaya/assets/121033752/420e4208-5a51-4586-819b-968c58a29463)
### GenAI features
![Untitled design (1)](https://github.com/gargibendale/niramaya/assets/121033752/fe518274-1b59-4af9-9ee7-1d8cd590b5e3)
### Diagnosis Tests
![Untitled design (2)](https://github.com/gargibendale/niramaya/assets/121033752/cfad54f8-7dfa-4159-9f75-ae4cf999e14f)
### Emotion recognition
![Untitled design (3)](https://github.com/gargibendale/niramaya/assets/121033752/c06c20af-6fc3-4c9b-87a3-0357f200467a)
### Additional Features
![Untitled design (4)](https://github.com/gargibendale/niramaya/assets/121033752/8ca212d8-22a6-44bb-9f93-3b0bed07bc51)
