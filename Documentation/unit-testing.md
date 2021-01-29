# 🛡 Unit Testing

When designing the APIs of my classes, I tried to keep testability in mind when creating classes. I kept the responsibilities of each class implementation small, and used techniques like dependency injection to make sure each class could be easily tested. I also used protocols heavily in the network layer of the application so that I could create and use mock network providers throughout test cases.

## Mock Class Usage Example

Here is a good example of the power that protocols provide when testing. This is a test case taken out of the `ETAuthenticationManagerTests` file.

```Objective-C
- (void)test_refreshAuthenticationStatusWithAuthenticatedResponse_thatStateIsSetToAuthenticated {
    // setup
    NSDictionary *responseData = @{
        @"isAuthenticated": [NSNumber numberWithUnsignedInteger:ETAuthenticated]};
    ETAuthenticationServerMock *mockServer = [ETAuthenticationServerMock
                                              authenticationServerMockWithCompletionHandlerData:responseData
                                              error:nil];

    // testing
    ETAuthenticationManager *sut = [[ETAuthenticationManager alloc]
                                    initWithAuthenticationServer:mockServer];

    [sut refreshAuthenticationStatus];

    XCTAssert(sut.authenticationState == ETAuthenticated);
}
```

In this test case, we are testing the `refreshAuthenticationStatus` method of `ETAuthenticationManager`. During initialization, `ETAuthenticationManager` expects an `ETAuthenticationServer` instance, which is a protocol that exposes some network methods related to authentication. In the application code, the class `ETAuthenticationServerProvider` adopts this protocol and provides concrete implementations of these methods, allowing the application to work under normal use. But in testing, the `ETAuthenticationServerMock` is used for intercepting the network calls that the authentication manager makes and providing predetermined response data back to the authentication manager. This makes it so we don't need to rely on making real network requests in testing, since that could cause a lot of problems if our network is down or the server has slow response times.

```Objective-C
NSDictionary *responseData = @{
        @"isAuthenticated": [NSNumber numberWithUnsignedInteger:ETAuthenticated]};
```

In the first few lines of this method, I created a `NSDictionary` which contains a property `isAuthenticated: true`. This dictionary is the data we would expect our server to return to us under normal conditions if the user was authenticated.

```Objective-C
ETAuthenticationServerMock *mockServer = [ETAuthenticationServerMock
                                              authenticationServerMockWithCompletionHandlerData:responseData
                                              error:nil];
```

Next, we created a new instance of `ETAuthenticationServerMock` and supplied it the response data dictionary that we just created. The `ETAuthenticationServerMock` is setup such that it will use whatever values it was initialized with and pass them to the completion handler of its methods, meaning we can control the `ETAuthenticationManager` will receive, without the use of real network requests.

```Objective-C
   // testing
    ETAuthenticationManager *sut = [[ETAuthenticationManager alloc]
                                    initWithAuthenticationServer:mockServer];

    [sut refreshAuthenticationStatus];

    XCTAssert(sut.authenticationState == ETAuthenticated);
```

In this case, we're testing that our `ETAuthenticationManager` will update its internal `authenticationState` property to `true` after we invoke its `refreshAuthenticationState` method. Since our mock authentication server will feed an `isAuthenticated: true` response to `ETAuthenticationManager`, we test that the authentication manager correctly updates its internal state as a result.

Using protocols makes it alot easier to test classes that have dependencies. Having the ability to create a fake version of a dependency and take control of the data that will flow through it makes it much simpler to write test cases.
