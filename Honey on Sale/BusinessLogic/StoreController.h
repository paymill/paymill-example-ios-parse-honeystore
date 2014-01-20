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

// items in card
@property (nonatomic, strong) NSMutableArray *itemsInCard;

//PayMill public key
@property (nonatomic, strong) NSString *payMillPublicKey;

// pull items from backend
- (void)pullItemsWithComplte:(ControllerCompleteBlock)complete;


- (void)addToCartProduct:(Product*)product;

+ (StoreController*)getInstance;

@end
