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
@property (nonatomic, strong, readonly, getter = getClients) NSArray* Clients;

// items in card
@property (nonatomic, strong) NSMutableArray *itemsInCard;

//PayMill public key
@property (nonatomic, strong) NSString *payMillPublicKey;

// pull items for sale from backend
- (void)pullItemsWithComplte:(ControllerCompleteBlock)complete;

// pull existing clients from backend
- (void)pullClientsWithComplte:(ControllerCompleteBlock)complete;

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
