# CtPaint Desktop

This is the desktop part of CtPaint. By that I mean, the home page, settings page, and the login, and all the things that are not part of the paint application ("PaintApp"). Now that I have hindsight, "Desktop" appears to be a poor name. "Main" might have been better. Desktop and PaintApp are just two parts of a broader application. Theres an over-arching App-Shell, that manages the initialization of the Desktop and PaintApp apps. App-Shell is an Elm app with no view, that just parses the url, determines what application to run, and builds the flags for the right app and initializes it. 

I chose this architecture, firstly because I expect users to either be in PaintApp or Desktop and secondly because the PaintApp is relatively large compared to everything else. Having to re-initialize the whole application when the use transitions between PaintApp and Desktop is a penalty, but its worth it. If these two apps were together, it would be much bigger and more monolithic, but more importantly there would be a lot of lingering state that wouldnt be significant to the UX.

## Getting Started

I dont think you can run this project locally unfortunately, because it requires some private repositories. Sorry. But if you did have access to those private repos, heres how you would get started:

```
npm install
npm run client
elm package install
gulp
--> localhost:2964
```

Oh, and install `elm` and `elm-css` as well.

## Directory Structure

```
├── Data                -- For modules dedicated to one data type and its helpers
│   ├── Config.elm      -- A config is for values defined at init and never changed
│   ├── Drawing.elm
│   ├── Entities.elm
│   ├── Feature.elm
│   ├── Flags.elm       -- Values passed into the app at init
│   ├── Taco.elm        -- A Taco is for values globally relevant
│   ├── Tracking.elm
│   └── User.elm
├── Desktop.elm         -- The main Elm file
├── Helpers             -- Helpers are miscellanious useful functions
│   ├── Email.elm
│   ├── Password.elm
│   └── Random.elm
├── Html                -- Html functions useful in many places
│   ├── Custom.elm
│   ├── InitDrawing.elm
│   ├── Main.elm
│   └── Variables.elm
├── Js                  -- All the JS code
│   ├── Drawing.js
│   ├── Flags.js        -- Code for building the flags for the Elm app
│   ├── PaintApp.js
│   └── User.js
├── Model.elm           -- The main Model
├── Msg.elm             -- The main Message type
├── Nav.elm             -- The navigation bar
├── Page                -- All the pages in the application
│   ├── About.elm
│   ├── AllowanceExceeded.elm
│   ├── Contact.elm
│   ├── Documentation.elm
│   ├── Error.elm
│   ├── ForgotPassword.elm
│   ├── Home.elm
│   ├── Login.elm
│   ├── Logout.elm
│   ├── Offline.elm
│   ├── Pricing.elm
│   ├── Register.elm
│   ├── ResetPassword.elm
│   ├── RoadMap.elm
│   ├── Settings.elm
│   ├── Splash.elm
│   └── Verify.elm
├── Page.elm
├── Ports.elm           -- Sending information into the JS side of the app
├── Route.elm           -- interpretting the url, and routing to the right page
├── Stylesheets.elm     -- CSS generation module
├── Tos.elm             -- "Terms of Service"
├── Track.elm           -- Main UI tracking module
├── Update.elm          -- Main update function listening for Msgs
├── Util.elm
└── app.js
```