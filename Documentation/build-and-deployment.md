# Build Configuration and Deployment

I used XCConfig files, Schemes, and Configurations under project settings to create multiple build environments. These build environments can be accessed easily through the use of different Schemes. Currently, there is an "Expense Tracker DEV" and "Expense Tracker PROD" scheme representing development and production environemnts, respectively.

The main difference between the environments is which XCConfig file is used at runtime. The values from the XCConfig files become available as variables which can be accessed on the main `info.plist` file. The `info.plist` values can then be accessed in the application code and our custom environment variables can be accessed through that.

Currently, the only environment variable being used is the `SERVER_URL` property, which provides the application code the hostname of the server to connect to. During development, I set the `SERVER_URL` to my machines IP address on my local network, since I'm running a development server as well. In production, I use the domain where my server is hosted.

This article from thoughtbot helped me learn about creating multiple environments and goes more into depth: https://thoughtbot.com/blog/let-s-setup-your-ios-environments
