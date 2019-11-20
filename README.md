# PhotoFinder
A test application to search and stream pictures from https://pixabay.com

iOS Deployment Target: 11.0
Swift Language Version: 5

Features

1. An initial  ViewController (searchController) to intiate search with any keyword, and a uicollectionviewController. (gridController) to display searched images in a masonry grid format. Both these viewcontrollers are navigated with UINavigationController.
2. images displayed in grid are downloaded from 'previewURL' instead of 'largeImageURL' to download the smallest size possible.
3. Result of URLRequest for all the search terms are cached (until page is refreshed using UIRefreshControl).
4. Downloaded images are cached.
5. All the cache (image as well as URLCache) is cleared on receiving memory warning.
6. Sopports 'pull down to refresh' on UICollectionViewController to refresh data.
7. Added unit and UI test cases.
8. Application logo and launch icon. 
9. Error handling

Please note that application only supports 'https' calls, no 'NSAppTransportSecurity' is added in plist file to support arbitrary loads. 
