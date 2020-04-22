# # Posts App

### Prerequisites

What things you need to install

```
* Xcode 11.3
* Cocoapods
```

## Built Features

* Show a list of post fetched from https://jsonplaceholder.typicode.com
* There is a segmented control to swith between all and favorites posts
* Unread posts have a bluedot, after being read it dissapears
* Favorite posts have a star indicator instead a bluedot
* Tapping on a post displays the post information
* Every post has its comments on details screen
* At post detail screen you can mark the post as favorite
* Posts offline persistence, if no internet, posts load from cache
* Ability to delete a post by swiping it
* Includes a button to remove all posts
* Includes a button to refresh all posts
* Includes Unit tests

## Architecture

* MVVM & Coordonators architecture with injected dependencies

## Authors

**Jeff Velez**

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details
