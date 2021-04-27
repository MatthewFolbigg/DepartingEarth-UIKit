# DepartingEarth
### About
Departing Earth is a iOS app that displays details about upcoming space launches from multiple providers. 
Upcoming launch data is from the [Launch Library 2](https://thespacedevs.com/llapi) by [The Space Devs](https://thespacedevs.com). 
You can filter the upcoming launch list by the launch provider, add launches to your calendar and view the launch pad in Apple Maps.

## Built With
* Swift 5
* Xcode 12.4
* iOS 14.4
* UIKit
* Launch Library 2


## User Guide
#### Upcoming Launches
- On first use the app will download a list of upcoming launches, present them in a collection view and save them loaclly. Subsequent loads will check the age of the data and if it is older than 6 hours new data will automatically be downloaded. 
- In the event the app is unable to download new data it will continue to present the older data, inform you of the error with a pop up and re-try updating next time the list of launches appears.
- The data can be manually refreshed by using pull to refresh however the API is rate limited so many refreshes in quick succession will eventually fail. An error message is presented if this happens.
- The button a the top right will present a list of lauch providers, allowing you to view only the launches for a specific provider. For example if you want to just see the next SpaceX launch you could select SpaceX from this list.

#### Launch Details
- Tapping on a launch will provide more details such as the mission type, orbit and launch pad.
- Tapping on the calendar button at the top right will bring up the system 'add event to calendar' view, allowing you to add the current expected launch date to your calendar with relevant information pre filled into the event.
- If mission details are avilable (indicated by an orange right facing chevron in the mission section) tapping on the mission section will present a description of the mission and sometimes other detials. 
- Tapping on the launchpad section will open apple maps at the location of the launchpad with the current camera height/zoom level.

#### Other
- The app is fully compatible with dark and light mode and will dynamically adapt to match the system settings


## Images
#### Icon
<img src="https://github.com/MatthewFolbigg/DepartingEarth/blob/7035fdc6445eb87c2e6acf5d5abbe8064cb2f32b/Images/App%20Icon.PNG" width="110" height="110">

#### Main Screens
<img src="https://github.com/MatthewFolbigg/DepartingEarth/blob/7035fdc6445eb87c2e6acf5d5abbe8064cb2f32b/Images/UpcomingLaunches.PNG" width="150"> <img src="https://github.com/MatthewFolbigg/DepartingEarth/blob/7035fdc6445eb87c2e6acf5d5abbe8064cb2f32b/Images/ProviderFilter.PNG" width="150"> <img src="https://github.com/MatthewFolbigg/DepartingEarth/blob/7035fdc6445eb87c2e6acf5d5abbe8064cb2f32b/Images/LaunchDetail.PNG" width="150"> <img src="https://github.com/MatthewFolbigg/DepartingEarth/blob/d7ed934e1d2934db1733568d59c98d1b11c756ea/Images/MissionDescription.PNG" width="150"> <img src="https://github.com/MatthewFolbigg/DepartingEarth/blob/d7ed934e1d2934db1733568d59c98d1b11c756ea/Images/AddToCal.PNG" width="150">
