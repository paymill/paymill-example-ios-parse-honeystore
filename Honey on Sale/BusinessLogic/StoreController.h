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

// pull items for sale from backend
- (void)getItemsWithComplte:(ControllerCompleteBlock)complete;

/*get total in cents*/
- (int)getTotal;

/* cart methods*/
- (void)clearCart;
- (void)addProductToCartd:(Product*)product;

+ (StoreController*)getInstance;

@end
