# iOS Challenge


## Project minimum requirements:

- MacOS Ventura 13.1 +
- iOS 16
- Swift 5
- XCode 14.2

the project doest not have any 3rd libs, just open the .project on xcode :) 

The Project Architecture is based on VIPER + Clean Arch concepts. 


## Why do we choose that architecture? 

The goal here is to show an way to build an escalable project. Since is very easy to have classes with a lot responsabilites, things can get complicated a long the way if we not start right. 

we can also easly change our UI without any impact on the other layers, would be pretty simple to build that screen with SwiftUI for example, withou breaking the other modules.

each layer use protocols to talk to another, so it's pretty simple to test them in isolation. 


## App Features

features

1) FeedViewController with videos

2) User gestures to swipe videos and reactions 



## User Interface

I used a UICollectionView to build the UI, using a modern aproach with UICollectionViewDiffableDataSource and NSDiffableDataSourceSnapshot to manage our CollectionView's data and updates! That's very powerful and save us from many lines of code. 

Also, I used a UICollectionViewCompositionalLayout, a modern aproach to build the CollectionView layout! 


## App Entry Point

The entry point is on SceneDelegate. We have a factory class that creates our main app feature injecting each dependency.
