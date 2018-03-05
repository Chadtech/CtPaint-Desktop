# CtPaint Desktop

This is the desktop part of CtPaint. By that I mean, the home page, settings page, and the login, and all the things that are not part of the paint app. Thats just part of the larger architecture of CtPaint. Theres an over-arching App-Shell, that manages the initialization of sub-apps. 

## Getting Started

I dont think you can run this project locally unfortunately, because it requires some private repositories. Sorry. But if you did have access to those private repos, heres how you would get started:

```
npm install
npm run client
elm package install
gulp
--> localhost:2964
```

## Directory Structure

```
├── Comply.elm         -- For handling page update functions
├── Data               
│   ├── Config.elm     -- The config stores values that dont change during runtime
│   ├── Drawing.elm    -- This is the drawing, a fundamental type in CtPaint
│   ├── Entities.elm   -- Entities is a place to store remote data
│   ├── Flags.elm      -- The initial values of the app
│   ├── Taco.elm       -- A Taco stores values that are useful across the whole app
│   └── User.elm       -- The user, and the different states of being logged in
├── Desktop.elm        -- The Main Elm file
├── Html
│   ├── Custom.elm     -- Widely used custom html and css
│   ├── InitDrawing.elm
│   ├── Main.elm
│   └── Variables.elm
├── Js
│   └── Flags.js
├── Model.elm
├── Msg.elm
├── Nav.elm            -- The nav bar
├── Page
│   ├── About.elm
│   ├── Contact.elm
│   ├── Documentation.elm
│   ├── Error.elm
│   ├── ForgotPassword.elm
│   ├── Home.elm
│   ├── Loading.elm
│   ├── Login.elm
│   ├── Logout.elm
│   ├── Offline.elm
│   ├── Pricing.elm
│   ├── Register.elm
│   ├── RoadMap.elm
│   ├── Settings.elm
│   ├── Splash.elm
│   └── Verify.elm
├── Page.elm
├── Ports.elm
├── Reply.elm          -- Aka an "ExternalMsg", replies from update functions 
├── Route.elm
├── Stylesheets.elm    -- Elm-css stylesheet compilation
├── Tos.elm            -- Terms of Service
├── Tracking.elm       -- Tracking UI events, WIP
├── Update.elm
├── Util.elm
└── app.js
```