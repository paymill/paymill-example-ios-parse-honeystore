# Recurrent Billing with PAYMILL

PAYMILL is a full-stack payment solution with very reasonable pricing and is easy to setup. See how to add it to a iOS application here, for back end we use [Parse](https://parse.com). If you want to use it only in iOS application you can look at VoucherMill(https://github.com/paymill/paymill-ios/tree/master/samples/vouchermill)

If you ever need to process credit card payments or recurring payments aka. subscriptions through your iOS applications, you should take a look at PAYMILL. PAYMILL is a payment gateway that is easy to set up and which is very developer friendly. It only charges fees on a per-transaction basis. 


### What does the application

The application, which we are going use is a simple store that sells jars of honey ;) The customer can browse the available jars and add each of them to his shopping basket. When the user is done with his selection, he can checkout the order by providing a credit card manually or by scanning it.

In this application we combine different SDKs of PAYMILL. For public part we use PAYMILL's [iOS SDK](https://github.com/paymill/paymill-ios) and for private use its [JavaScript SDK](https://github.com/paymill/paymill-js). For easy scan of credit card we use [card.io](https://www.card.io).

Before you use the app you must register as merchant in PAYMILL's website and get your public and private key. Private key you must set on the backend or in our case in Parse, the public key must be used in iOS part.

First thing you need to do is to login or register in HoneyStore Application.
![landing page](./docs-assets/01.pages_index.png)

There are four different products that user can choose from.
![sign up page](./docs-assets/02.users_init.png)

When the user select on one of the products, he will be redirected to the details page, there he can read more about his choice and to add it to the shopping cart.
![sign up page](./docs-assets/02.users_init.png)

On the checkout page the user have to provide a credit card, if none exists. He can scan it, or he can enter the requested information manually. If the user has already given his credit card, he just need to select it.

### Application internals

**Dependencies management**
Lets start at the beginning. 
As every application developer you don't want to write everything on your own. 
Nowadays for each programming language there are a lot of tools and frameworks, which we can use to speed up the development process and make our lives easier.

For dependancies management *Honey Store* uses very popular dependency manager: **CocoaPods**:
* [CardIo](https://github.com/card-io/card.io-iOS-SDK) - for easy scanning credit card.
* [PARSE](https://parse.com/) - we use PARSE as backend
* [paymill](https://github.com/paymill/paymill-ios) - iOs library, which simplifies development against PAYMILL API and hides communication infrastructure.

Before you start you must install **CocoaPods**, please read you to install it on http://cocoapods.org/.

After successful installation locate  *Honey Store* pod file and run in your terminal:  
```objective-c 
pod install 
``` 

As you can see **CocoaPods** prepare your project file and download all dependancy SDK. After everything is complete you are ready to go. Open xcworkspace file and you will see the main project *Honey on Sale* .

**Project Structure**

The application is virtually separated in tree parts: User management, Business Logic, Screens, Resources and Database.

User management

For users management we user PARSE SDK. When you lunch the application you will see PARSE's SignUp and Logins screen. 
After the user register himself in the application, credentials are send to PARSE and then we use PAYMILL's JS SDK to create client Id. By this Id we make all transaction to PAYMILL. 

For easy and fast impltementation we use that functionality from PARSE iOS SDK. There are ready to use Login, SingnUp controllers and views, this save us hours of codding. 

Business Logic

In iOS part our Business Logic is represented by PMLProduct and PMLStoreController. Products are items that we sell on our store, when appliation run we download them from PARSE and then show them in our store.
StoreController we use to store all data that we need in our store like purchases and available products.

There is another part of Business Logic, which is implement in our backend(PARSE) code. You can find this code in '.\Parse\main.js', here we have methods for client info, 
register our user in PAYMILL and create transactions. 

Screens

All screen that user see are implemented in iOS project.

Resources

For iOS we have images, icons, storyboard and plist file, for backend we need PAYMILL's library for PARSE i.e 'paymill.parse.js'. 

**Database**

Because our database is located in PARSE cloud, you must have valid user and password for it. After the registration you must create application for example 'HoneyStore'
and get application keys. Please find the [installation of PARSE Cloud](https://parse.com/docs/cloud_code_guide)

After the installation please find your application keys at *[Application Name]->Settings->Application Keys*. 
Then copy productDB.js, main.js, paymill.parse.js in your *cloud* directory and run in console

```dos
    curl -X POST \
  		 -H "X-Parse-Application-Id: APPLICATION_ID" \
 		 -H "X-Parse-REST-API-Key: APPLICATION_REST_API_KEY" \
 		 -H "Content-Type: application/json" \
 		 --data-binary @productDB.json \
  		https://api.parse.com/1/batch
```

 This will create your database.
 After that open main.js and fill your private PAYMILL key, then run:  

```dos
 	parse deploy
```

This will upload all code that you need for the backend. 

**Models**

In our app we have 2 different Models

* User: for user management we have PARSE's PFUser, by this class we can take current user and all info about him. In our app users are extended with one more property 'paymillClientId'.
* Product: contains information from PARSE server. All products are stored in our database.


User management is very borring issue, we can escape from this by using PARSE functionality. It is very easy to use and will save us alot of time. Here is very simple way to use it.
When application start we check if there is current user:

```objectivec 
	if (![PFUser currentUser]) 
```
If there is no active user we use PARSE *PFLogInViewController* for login screen (on this screen there is also fuctionality to SingnUp). When user create an acount it automatically calls backend and save the new user in our database.
But before save, we call PAYMILL go get client Id. We need this *client Id* when we create transactions and payments, that's why we save it with the user.

```javascript 
Parse.Cloud.beforeSave("_User", function(request, response) {
	paymill.clients.create(request.object.email, request.object.username).then(function(result) {
		 request.object.set("paymillClientId", result.id);
		 response.success();
	}, function(e) {
		response.error("save user failed" + e);
	});
});
```

In your database we have 4 hardcoded products, to show them in our store we make a request to PARSE. When the user login we make following call in *PMLStoreController*.
By this code we pull all Products from database and save them as PMLProduct in memory

```objectivec 
- (void)getProductsWithComplte:(ControllerCompleteBlock)complete{

	PFQuery *query = [PFQuery queryWithClassName:@"Product"];
    if(self.products == Nil){
        self.products = [[NSMutableArray alloc] init];
    }
    [self.products removeAllObjects];
    
	[query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
		for (PFObject *obj in objects) {
            PMLProduct* product = [PMLProduct parse:obj];
            [self.products addObject:product];
        }
        complete(error);
	}];
}
```

**Store Controller**

* StoreController: contains infromation about our store, here we contains orders, products and total amount.
To save all products and purchases we use PMLStoreController, this is logical prepresentation of our store. For example wen user add product to his card we save 
it in our controller. When user go to payment screen we calculate the amoutn of all orders and put it in the payment. When we want to pull products from database we call: 

```objectivec 
- (void)getProductsWithComplte:(ControllerCompleteBlock)complete
```

**View Controllers**

Our ios application has 5 view controllers

* PMLDefaultViewController: This is main controller of our application, on this controller we decide if there is active user, or ask user to SingIn.
* PMLCheckoutViewController: This is base class for view controllers where have cart button, for example PMLProductDetailsViewController and PMLStoreViewController .
* PMLStoreViewController: in this view controller we are dealing with products that user can buy, this is the front screen of our store. It present simple table controller with predefined cells.
For better view we predefine every cell and implement them in PMLProductTableViewCell.
* PMLProductDetailsViewController: On this view we show detailed infromation for selected product, here we have 'add to card' button, so user can add this product in his cart.
* PMLPaymentViewController: This controller is care for our payments and orders, on it we make actual checkout.


**Dealing with existing creadit cards**

**Adding PAYMILL’s API Key**

**Handling the credit cards**

**Dealing with payments and transactions**

