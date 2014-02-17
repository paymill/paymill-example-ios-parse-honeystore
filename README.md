# Recurrent Billing with PAYMILL

PAYMILL is a full-stack payment solution with very reasonable pricing and is easy to setup. See how to add it to a iOS application here, for back end we use PARSE. If you want to use it only in iOS application you can look at VoucherMill(https://github.com/paymill/paymill-ios/tree/master/samples/vouchermill)

If you ever need to process credit card payments or recurring payments aka. subscriptions through your iOS applications, you should take a look at PAYMILL. 
PAYMILL is a payment gateway that is easy to set up and which is very developer friendly. It only charges fees on a per-transaction basis and these are very reasonable. 
There are no monthly fees or other hidden costs.

### What does the application

The application, which we’ll use is a simple store that sells jars with honey ;) The customer can brouse the available jars and add each of them to his shoping basket. When the user is done with his selection, he can checkout the order by providing a credit card manualy or by scanning it.

In this application we combinate different SDKs of PAYMILL. For public part we use PAYMILL's iOS SDK and for private use JS SDK. For easy scan of credit card we use [CardIo](https://www.card.io).    

Before you use the app you must register as merchant in PAYMILL website and get your public and private key. Private key you must set in PARSE part, the public key must be used in iOS part.
![landing page](./docs-assets/01.pages_index.png)

There are four different products that user can buy and add it to the Cart. When the user select on one of the product, he will be redirected to the details page, there he can read about his choice and to add it in the Shoping Cart.

![sign up page](./docs-assets/02.users_init.png)

For users management we user PARSE SDK. When you lunch the application you will see PARSE's SignUp and Logins screen. 
After the user register himself in the application, credentials are send to PARSE and then we use PAYMILL's JS SDK to create client Id. By this Id we make all transaction to PAYMILL. 


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

The application is virtually separated in tree parts: User management, Business Logic, Screens and Resources.

User management

For easy and fast impltementation we use that functionality from PARSE iOS SDK. There are ready to use Login, SingnUp controllers and views, this save us hours of codding. 

Business Logic

In Business Logic we implement Product and StoreController. Products are items that we sell on our store, when appliation run we download them from PARSE and then show them in our store.
StoreController we use to store all data about our store like Cart and Products.

Screens

In this part we implement all needed Views for our Store.


Resources

Here we have images, icons, storyboard and plist file for our project. 

**Database**

Our database is located in PARSE cloud. 

For store all info that we need we have 2 tables:
* User: Contains columns username, email, password and PAYMILL Client identifier 
* ItemForSale: Contains columns name, amount, currency, description, image, iterval and trial_period_days.

To upload your sample data create parse account and import data from \Parse\_User.json and \Parse\ItemForSale.json 

**Models**

curl -X POST \
  -H "X-Parse-Application-Id: uii9EaqHnJ5fiez0hZOgc5KdIz5Fw9uIXIn24SMY" \
  -H "X-Parse-REST-API-Key: L3CraNfoFgf0ClSJH2yMz0VOhwPShaoLy2wlIM0f" \
  -H "Content-Type: application/json" \
  --data-binary @Product.json \
  https://api.parse.com/1/batch


**Controllers**

**Dealing with clients**

**Adding PAYMILL’s API Key**

**Handling the credit cards**

**Dealing with payments**

