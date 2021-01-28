# 🏗 App Architecture

Expense Tracker is a relatively simple application, currently sporting three unique screens. Although simple, I utilized MVC to architect the app such that adding more features in the future should be easy. It consists of an authentication component that manages authenticating the user, and an expense item component which allows the user to create and delete different expense items. Both of these components depend on network connectivity to perform their respective actions, so I utilized protocols and objective inheritance to build a robust network layer that can be unit tested easily.

## Authentication

#### Overview

Expense Tracker uses a simple mechanism to implement authenticated routes by following a structure similar to MVC. The diagram below illustrates how a controller directly communicates with the model, and then uses key-value observing updates to determine whether it should display the authenticated, or non-authenticated view hierarchy to the user.

<img src="resources/auth-diagram.png">

The authentication navigation controller first calls a method on the authentication manager called `refreshAuthenticationStatus`, which the authentication manager uses as an excuse to use network data and retrieve the current navigation status from the server:

<img src="resources/refresh-auth-status-diagram.png">

The server will then check the session object it has associated with the current user's request to determine if the user is authenticated or not. It will return a JSON object containing the property `isAuthenticated: Bool`.

<img src="resources/refresh-auth-server-response-diagram.png">

In this example, the authentication manager will receive and decode a JSON object that contains `isAuthenticated: False` from the server. The authentication manager will then set an internal `authenticationState` property to reflect the response it received from the server. The authentication navigation controller on the left hand side is essentially eavesdropping and receives an update that the authentication state has updated through the use of the KVO mechanism.

<img src="resources/refresh-auth-display-login-diagram.png">

The Authentication navigation controller will use this newly acquired information to then display the correct view hierarchy depending on the new authentication status it was given.

From a high level, this represents the inner workings of the authentication flow in the Expense Tracker application. It follows an architecture that resembles MVC, where network requests and authentication state management is abstracted away from the controller. This allows the navigation controller to focus on one job: Display the correct view hierarchies given the user's current authentication status. This helps keep implementation files small and easy to understand.

#### Sign in with Apple

<img src="resources/login-screen.png" width="300">

I wanted to get experience with more frameworks available on iOS, so I decided to implement Sign in with Apple from the Authentication Services framework. When the user presses the button to sign in, I present an `ASAuthorizationController` which is set up to authenticate users using their Apple ID. The `ETAuthenticationManager` that I introduced above implements the `ASAuthorizationControllerDelegate` protocol, so once the user has finished the Sign in with Apple flow, it is responsible for the completion.

Once the user finished authenticating, the presented `ASAuthorizationController` will call the `authorizationController didCompleteWithAuthorization` method of its delegate. The authorization object passed to the delegate contains information that was requested about the newly authenticated user such as email, name, user identifier, and identity token. The identity token is an encrypted JWT (JSON Web Token) provided by Apple which can be used to verify if the user has officially authenticated with their Apple ID using Authentication Services.

<img src="resources/auth-authentication-services.png">

Now that we have an identity token from Apple that represents this user, we can send it to our server which can verify its legitimacy before authenticating the user.

<img src="resources/auth-server-identity-token.png">

If the server determines the identity token is valid, it will mark this user as authenticated for future requests. More information can be found about how the server verifies the token and manages user authentication state in the [Expense Tracker Server Repository](https://github.com/mikemalisz/expense-tracker-server).

## Expense Items

Now that user is authenticated, they will have access to their expense items. From here, the user can either create a new itemized expense, or delete existings ones.

<img src="resources/demo.gif" height="500">

#### Data Structure

An expense item is simply a container of a few properties such as the expense title, amount, date purchased, and date created. Here is what a JSON representation of an expense item would look like coming from the server:

```json
{
	"itemId": "0be79211-d813-402a-b2d1-11c78be98695",
	"amountInCents": 329,
	"expenseTitle": "Milk",
	"dateOfPurchase": 1610919480000,
	"dateCreated": 1611351573627
}
```

Coming from Swift, structs are the perfect container for storing simple data like this from the server. Normally, I would adopt `Codable` for my data container structs and would be able to convert them to and from JSON objects easily. I learned quickly that Objective-C's structs are very different. Since Objective-C structures aren't objects, they don't play nicely with other Objective-C data structures like `NSArray` which only accepts objects.

This led me to create an `ETExpenseItem` class which would contain all the information as properties, and would be compatible with other common data structures.

#### Expense Item Manager

The `ETExpenseItemManager` class is the Swiss Army Knife when it comes to working with expense items. It can retrieve the user's expense items from the server and store them locally, create new expense items, and delete existing ones. All interactions with expense items go through this object.

Some of the methods require sending the server some information, such as `submitNewExpenseItemWithTitle` and `deleteExpenseItemWithItemId`. In these cases, the information that's passed into the method is bundled up into an `NSDictionary` object, and then serialized using the `NSJSONSerialization dataWithJSONObject` API. Once this data is serialized, it can be handed off to the `ETItemServer` property which takes care of performing the network request. `ETItemServer` is a protocol, which makes it easy to swap in different implementations when unit testing or using it normally.

Each method that requires a network request (such as refresh/submit/delete expense item) expects to be provided a completion handler block. This block gets executed when the server request has completed and can optionally contain an error if something goes wrong.

The server returns the user's updated list of expense items for each network request related to expense items. For example, if the `submitNewExpenseItemWithTitle` method is called, the server will first insert the new expense item into the database and then query for all of the user's expense items before returning a JSON object of them. This makes it easy to keep the client always up to date with what is stored in the database.
