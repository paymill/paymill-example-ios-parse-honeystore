//
//  Controller.h
//  Honey on Sale
//
//  Created by Vladimir Marinov on 13.01.14.
//  Copyright (c) 2014 г. Vladimir Marinov. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Product;

@interface StoreController : NSObject

typedef void (^ControllerCompleteBlock)(NSError *error);

// tems from Parse, that are visible for sale
@property (nonatomic, strong, readonly, getter = getProducts) NSArray* Products;
@property (nonatomic, strong, readonly, getter = getPayments) NSArray* Payments;

// items in card
@property (nonatomic, strong) NSMutableArray *itemsInCard;

//PayMill public key
@property (nonatomic, strong) NSString *payMillPublicKey;
@property (nonatomic, strong) NSString *payMillClientId;

// pull items for sale from backend
- (void)getItemsWithComplte:(ControllerCompleteBlock)complete;

// pull existing payments for current user from backend
- (void)getPaymentsWithComplte:(ControllerCompleteBlock)complete;

/*get total in cents*/
- (int)getTotal;

- (void)addProductToCartd:(Product*)product;

- (void)payWithClient:(NSString*)clientId
           cardNumber:(NSString*)cardNumber
           cardExpire: (NSString*)cardExpire
              cardCcv:(NSString*)cardVerification
              complte:(ControllerCompleteBlock)complete;

- (void)payWithAccHolder:(NSString*)accHolder
                   email:(NSString*)email
           cardNumber:(NSString*)cardNumber
           cardExpire: (NSString*)cardExpire
              cardCcv:(NSString*)cardVerification
              complte:(ControllerCompleteBlock)complete;

+ (StoreController*)getInstance;

@end
