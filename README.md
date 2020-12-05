# iOS-Fall2020-Group3

Professor Bulko
Group Number: 3 

List of Group Members:
Chineye Emeghara - ce8894
Ira Gulati - idg286
Marissa Jenkins - mj26394
Megan Teo - mjt2664

Application Name: made
An application for Bulko iOS Fall 2020 course, for a DIY community application called 'made'

Dependencies: Xcode 12.2, Swift 5.2

Special Instructions:
The main storyboard to make sure you run is the 'Alpha.storyboard' 
Use the iPhone 11 Pro Max Simulator
If you want to see an existing account with uploads already you can use this account:
username: marissa@utexas.edu
password: holahola
If you want to upload your own pictures in the made app, you can drag and drop images from your desktop to the iPhone photos app on the simulator 

Contributions:

Things we did together
Pair programming for Explore page & to add app icon
Pair programming for updating post attributes/image into Firebase and retrieving it
Pair programming for search bar/explore page, post form bugs, initial firebase set up and defining project design
We pair programmed and got pictures to display on the feed, updated feed format, updated logo images across the app, updated profile pictures across the app, added click functionality to the explore view, and worked on this bug we found in our single post view
We got it so that you could click on posts from anywhere in the application and see the single post view
The explore page now populates when you click into specific categories and you can click into specific posts from there
The app does not have a dead end, you can get back to the tab bar or main page

Chineye
Merged files & resolved conflict errors
Single Post Display Page
Comments on Single Post Page
Uploading comment data to Firebase
Connecting comments to the appropriate project ID
Updates to single post page 

Ira
Single Post Form Page
Page to scroll through multiple photos in a single post, to be used for collections (worked on this together with Megan)
Feed Page for users to scroll through their curated content (worked on this together with Megan)
Feed constraints, updating profile picture bug on feed
Pair programming for search bar/explore page, post form bugs, initial firebase set up and defining project design

Marissa
Login / Registration page
Integrated firebase authentication
User profile page 
Set up core data to save information from registration and settings updates
Set up tab bar navigation for the application flow 
Pair programming for the post project view controller and connected the values to firebase database and storage
Updated user profile so that some pictures show up and the saved projects button pulls up a collection view
Pair programming for Explore page & to add app icon
Saved photos view

Megan
Settings page/Edit Settings page
Feed page (worked on this together with Ira)
Users can scroll through content from who they follow
Page to scroll through multiple photos in a single post (worked on this together with Ira)
Profile Picture Setting page where the user can change profile picture and store it into Firebase
Pair programming for updating post attributes/image into Firebase and retrieving it
Pair programming for Explore page


--- Feature | --- Description | --- Release Planned | --- Release Actual | --- Deviations (if any) | --- Who/Percentage Worked on
Registration/Sign in | User is able to login to application or sign up with username/email | Alpha | Alpha | n/a | Marissa
User profiles | A feature to view the user’s profile page, history of posts/projects, access settings, and saved DIY posts. | Alpha
| Beta | Full working profile was not complete until the beta. There was a placeholder view with some features not implemented during Alpha | Marissa
Posting abilities | Specific template of attributes will be asked of the artist. Things like: title of project, description, time taken, materials, cost, category/hashtag (limit to 3), level of difficulty, and a photo of the item. | Alpha | Alpha, revised in Beta | We altered some of the input options and views to make it user friendly. So there is no slider for difficulty, but easy, medium, and hard instead. | Ira
Single upload view | This is so users can select a post/upload and view more details about the project. The users are automatically redirected to this page after creating a post and this is the page users land on from the feed | Not included in proposal | Alpha base was there, truly working in final | Had placeholder information until we were able to pull from firebase | Chineye
Reviews | Users are able to leave reviews for DIYs they have attempted. Reviewers will have a template that asks for their personal rating by 1-5 stars of the project experience, describing difficulty, and/or uploading photos of the attempt, and leaving text. | Alpha | Beta | At first we were doing comments and reviews, now it’s just reviews and we’re using pop up alerts to get their review instead of a text box | Chineye
Settings | Control interaction with the app by changing these things: notifications (from app and from people they follow), username, password, color scheme. | Alpha | Alpha | n/a | Megan
Feed / Home page | A scrolling page of posts populated with posts from people you follow and random posts from categories the artist has pre-selected during registration. | Alpha | Beta | n/a | Ira - 50% & Megan - 50%
Saved Section | Part of the user’s profile (the yellow heart next to their profile photo) where their saved DIY posts will be stored. | Beta | Final | Does not pull from the database as expected. The information is being saved to the database in our code, but there were weird errors, so we left it hardcoded. | Marissa
Search Page / Explore Page | Ability to browse through categories that you might be interested in & a search bar to filter those categories | Beta | Beta | n/a | Everyone
Social Integration | Ability to share posts to Twitter/Facebook/Instagram/Email. | Beta | n/a | Did not have time | Did not implement 
Make it look pretty | Went with a yellow consistent theme throughout the app so its uniform | Final | Final | n/a | Everyone


