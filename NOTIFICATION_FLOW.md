# Notification Flow Diagram

## 🔄 Notification Flow Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                     FIREBASE CLOUD MESSAGING                     │
│                          (FCM Server)                            │
└────────────────────────────┬────────────────────────────────────┘
                             │
                    Sends Notification
                             │
                             ▼
        ┌────────────────────────────────────────┐
        │         Device Receives                 │
        │      Notification via FCM               │
        └────────────┬───────────────────────────┘
                     │
        ┌────────────┴────────────┐
        │                         │
        ▼                         ▼
┌──────────────┐          ┌──────────────┐
│   ANDROID    │          │     iOS      │
│   System     │          │   System     │
└──────┬───────┘          └──────┬───────┘
       │                         │
       └──────────┬──────────────┘
                  │
        ┌─────────┴─────────┐
        │                   │
        ▼                   ▼
   Has Notification    Has Notification
     Permission?         Permission?
        │                   │
    ┌───┴───┐           ┌───┴───┐
    │  YES  │           │   NO   │
    └───┬───┘           └───┬───┘
        │                   │
        │                   └──> Notification Blocked
        │
        ▼
  Check App State
        │
        ├──────────────────────────────────────┐
        │                                       │
        ▼                                       ▼
┌──────────────┐                      ┌──────────────┐
│  FOREGROUND  │                      │  BACKGROUND  │
│  App Active  │                      │ App Minimized│
└──────┬───────┘                      └──────┬───────┘
       │                                      │
       ▼                                      ▼
FirebaseMessaging.onMessage          System Notification
       │                                      │
       ▼                                      │
notification_service.dart                    │
       │                                      │
       ▼                                      │
showLocalNotification()                      │
       │                                      │
       └──────────────┬───────────────────────┘
                      │
                      ▼
              ┌──────────────┐
              │  TERMINATED  │
              │ App Closed   │
              └──────┬───────┘
                     │
                     ▼
          System Notification
                     │
          ┌──────────┴──────────┐
          │                     │
          ▼                     ▼
    User Taps            User Dismisses
   Notification          Notification
          │                     │
          ▼                     └──> End
  FirebaseMessaging
  .getInitialMessage()
          │
          ▼
_handleNotificationNavigation()
          │
          ▼
    Navigate to Screen
```

## 📊 Notification Service Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                       NotificationService                        │
│                      (@LazySingleton)                           │
└─────────────────────────────────────────────────────────────────┘
                                │
                    ┌───────────┴───────────┐
                    │                       │
                    ▼                       ▼
        ┌──────────────────┐    ┌──────────────────┐
        │ FirebaseMessaging│    │FlutterLocalNotifi│
        │                  │    │   cationsPlugin  │
        └──────────────────┘    └──────────────────┘
                    │                       │
        ┌───────────┴───────────┐           │
        │                       │           │
        ▼                       ▼           ▼
┌──────────────┐    ┌──────────────┐  ┌──────────────┐
│ Get FCM Token│    │Subscribe Topic│  │Show Local    │
│              │    │               │  │Notification  │
└──────────────┘    └──────────────┘  └──────────────┘
        │                       │           │
        ▼                       ▼           ▼
┌──────────────┐    ┌──────────────┐  ┌──────────────┐
│Request       │    │Handle Message│  │Cancel        │
│Permission    │    │(3 States)    │  │Notification  │
└──────────────┘    └──────────────┘  └──────────────┘
```

## 🎯 Message Handling Flow

```
┌─────────────────────────────────────────────────────────────────┐
│                    Incoming FCM Message                         │
└──────────────────────────┬──────────────────────────────────────┘
                           │
            ┌──────────────┼──────────────┐
            │              │              │
            ▼              ▼              ▼
     ┌──────────┐   ┌──────────┐   ┌──────────┐
     │FOREGROUND│   │BACKGROUND│   │TERMINATED│
     └────┬─────┘   └────┬─────┘   └────┬─────┘
          │              │              │
          ▼              ▼              ▼
  onMessage      onBackgroundMsg   getInitialMsg
          │              │              │
          ▼              │              │
  showLocalNotif         │              │
          │              │              │
          └──────┬───────┴──────┬───────┘
                 │              │
         User Taps       User Dismisses
         Notification    Notification
                 │              │
                 ▼              └──> End
    _handleNotificationNavigation
                 │
                 ▼
         Extract Data (type, id)
                 │
                 ▼
         Switch on Type
                 │
         ┌───────┼───────┐
         │       │       │
         ▼       ▼       ▼
      Order  Product  Message
         │       │       │
         ▼       ▼       ▼
    Navigate to Screen
```

## 🔐 Permission Flow

```
┌─────────────────────────────────────────────────────────────────┐
│                     App Initialization                          │
└──────────────────────────┬──────────────────────────────────────┘
                           │
                           ▼
              NotificationService.initialize()
                           │
                           ▼
                  requestPermissions()
                           │
            ┌──────────────┴──────────────┐
            │                             │
            ▼                             ▼
    ┌──────────────┐            ┌──────────────┐
    │   Android    │            │     iOS      │
    └──────┬───────┘            └──────┬───────┘
           │                           │
    Android 13+?                  Show Alert
           │                           │
    ┌──────┴──────┐              ┌─────┴─────┐
    │             │              │           │
    ▼             ▼              ▼           ▼
  YES           NO           Allow       Deny
    │             │              │           │
    ▼             │              │           │
Show System       │              │           │
Permission        │              │           │
Dialog            │              │           │
    │             │              │           │
┌───┴───┐         │              │           │
│       │         │              │           │
▼       ▼         ▼              ▼           ▼
Allow  Deny    Auto-Grant   Permission   Permission
                              Granted     Denied
    │       │         │           │           │
    └───┬───┴────┬────┴───────────┘           │
        │        │                            │
        ▼        ▼                            ▼
    Granted   Denied                      Blocked
        │        │                            │
        ▼        ▼                            ▼
   Continue  Show Manual                  Show Settings
   Setup     Enable Guide                 Guide
```

## 📱 Device Token Management

```
┌─────────────────────────────────────────────────────────────────┐
│                        App Launch                               │
└──────────────────────────┬──────────────────────────────────────┘
                           │
                           ▼
              NotificationService.getFCMToken()
                           │
                           ▼
                  Firebase Messaging
                           │
            ┌──────────────┴──────────────┐
            │                             │
            ▼                             ▼
    ┌──────────────┐            ┌──────────────┐
    │ Token Exists │            │No Token Yet  │
    └──────┬───────┘            └──────┬───────┘
           │                           │
           ▼                           ▼
    Return Token                 Generate Token
           │                           │
           └──────────┬────────────────┘
                      │
                      ▼
              Save to State/Log
                      │
                      ▼
            Send to Backend Server
                      │
            ┌─────────┴─────────┐
            │                   │
            ▼                   ▼
    ┌──────────────┐    ┌──────────────┐
    │ Store in DB  │    │Associate with│
    │  per Device  │    │   User ID    │
    └──────────────┘    └──────────────┘

Token Refresh:
┌─────────────────────────────────────────────────────────────────┐
│              onTokenRefresh.listen()                            │
└──────────────────────────┬──────────────────────────────────────┘
                           │
                           ▼
                  New Token Generated
                           │
                           ▼
              Update Local State/Log
                           │
                           ▼
            Send Updated Token to Backend
                           │
                           ▼
              Backend Updates Database
```

## 🎨 Topic Subscription Flow

```
┌─────────────────────────────────────────────────────────────────┐
│                   User Action / Auto Subscribe                  │
└──────────────────────────┬──────────────────────────────────────┘
                           │
            ┌──────────────┴──────────────┐
            │                             │
            ▼                             ▼
    subscribeToTopic()          unsubscribeFromTopic()
            │                             │
            ▼                             ▼
    FCM Subscribe API              FCM Unsubscribe API
            │                             │
            ▼                             ▼
    Success/Failure                Success/Failure
            │                             │
            └──────────┬──────────────────┘
                       │
                       ▼
              Update User Preferences
                       │
                       ▼
           Send Preferences to Backend

Topics Examples:
- all_users (global broadcast)
- promotions (marketing)
- orders (order updates)
- user_123 (per-user topic)
- premium_users (segment)
```

## 🔄 Complete User Journey

```
┌─────────────────────────────────────────────────────────────────┐
│                        User Opens App                           │
└──────────────────────────┬──────────────────────────────────────┘
                           │
                           ▼
              Check Notification Permission
                           │
            ┌──────────────┴──────────────┐
            │                             │
            ▼                             ▼
        Granted                       Not Granted
            │                             │
            ▼                             ▼
    Get FCM Token                   Show Permission
            │                        Request UI
            │                             │
            │                             ▼
            │                      User Grants/Denies
            │                             │
            └──────────┬──────────────────┘
                       │
                       ▼
            Initialize Notification
                   Handlers
                       │
        ┌──────────────┼──────────────┐
        │              │              │
        ▼              ▼              ▼
    onMessage   onMessageOpened  getInitialMsg
        │              │              │
        └──────┬───────┴──────┬───────┘
               │              │
               ▼              ▼
       Show Notification  Handle Tap
               │              │
               │              ▼
               │      Navigate to Screen
               │              │
               │              ▼
               │       Update UI State
               │              │
               └──────────────┘
```

---

## 📝 Notes

- **Foreground**: App is active, user can see the screen
- **Background**: App is minimized but still in memory
- **Terminated**: App is completely closed, not in memory

All three states are handled by the NotificationService implementation.
