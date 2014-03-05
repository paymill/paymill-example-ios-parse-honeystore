//
//  PMLStoreController.h
//  Honey on Sale
//
//  Created by Vladimir Marinov on 13.01.14.
//  Copyright (c) 2014 г. PAYMLLL All rights reserved.
//

#import <Foundation/Foundation.h>

@class PMLProduct;

@interface PMLStoreController : NSObject

typedef void (^ControllerCompleteBlock)(NSError *error);

// tems from Parse, that are visible for sale
@property (nonatomic, strong, readonly, getter = getProducts) NSArray* Products;
@property (nonatomic, strong) PMLProduct *productInCard;

// pull items for sale from backend
- (void)getProductsWithComplte:(ControllerCompleteBlock)complete;

/* cart methods*/
- (void)clearCart;

+ (PMLStoreController*)sharedInstance;

@end
