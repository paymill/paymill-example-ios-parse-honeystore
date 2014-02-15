//
//  PMLStoreController.h
//  Honey Store
//
//  Created by Vladimir Marinov on 13.01.14.
//  Copyright (c) 2014 г. PAYMLLL. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PMLProduct;

@interface PMLStoreController : NSObject

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
- (void)addProductToCartd:(PMLProduct*)product;

+ (PMLStoreController*)sharedInstance;

@end
