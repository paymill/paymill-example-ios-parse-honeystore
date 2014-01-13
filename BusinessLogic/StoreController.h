//
//  Controller.h
//  Honey on Sale
//
//  Created by Vladimir Marinov on 13.01.14.
//  Copyright (c) 2014 г. Vladimir Marinov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StoreController : NSObject

// this is items from Parse, that are visible for sale
@property (nonatomic, strong) NSArray* ItemsForSale;

- (void)fillWithData;
+ (StoreController*)getInstance;

@end
