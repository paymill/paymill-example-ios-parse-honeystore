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

For iOs we have images, icons, storyboard and plist file, for backend we need PAYMILL's library for PARSE i.e 'paymill.parse.js'. 

**Database**

Because our database is located in PARSE cloud, you must have valid user and password for it. After the registration you must create application for example 'HoneyStore'
and get application keys. Please find the [installation of PARSE Cloud](https://parse.com/docs/cloud_code_guide)
After the installation please find your application keys at [Application Name]->Settings->Application Keys. 
Then copy Product.js, main.js, paymill.parse.js in your PARSE could directory run in console
 ```dos
 curl -X POST \
  -H "X-Parse-Application-Id: APPLICATION_ID" \
  -H "X-Parse-REST-API-Key: APPLICATION_REST_API_KEY" \
  -H "Content-Type: application/json" \
  --data-binary @Product.json \
  https://api.parse.com/1/batch
 ```
 This will create your database.
 After that open main.js and fill your private PAYMILL key, then run:  

```dos
 	parse deploy
 ```

This will upload all code that you need for the backend. 



For store all info that we need we have 2 tables:
* User: Contains columns username, email, password and PAYMILL Client identifier 
* ItemForSale: Contains columns name, amount, currency, description, image, iterval and trial_period_days.

To upload your sample data create parse account and import data from \Parse\_User.json and \Parse\ItemForSale.json 

**Models**




**Controllers**

**Dealing with clients**

**Adding PAYMILL’s API Key**

**Handling the credit cards**

**Dealing with payments**

