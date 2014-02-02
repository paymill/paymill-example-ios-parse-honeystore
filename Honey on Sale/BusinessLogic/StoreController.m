//
//  Controller.m
//  Honey on Sale
//
//  Created by Vladimir Marinov on 13.01.14.
//  Copyright (c) 2014 г. Vladimir Marinov. All rights reserved.
//

#import "StoreController.h"
#import <Parse/Parse.h>
#import "Product.h"
#import <PayMillSDK/PMClient.h>
#import <PayMillSDK/PMSDK.h>

@interface StoreController()

@property (strong, nonatomic) NSMutableArray *products;

@end

@implementation StoreController


- (StoreController*)init{
	if(self = [super init]){
        // Init Parse Library
       
        _itemsInCard = [[NSMutableArray alloc] init];
        return self;
	}
	return nil;
}

StoreController *instance;

+ (StoreController*)getInstance{
	if(instance == nil){
		instance = [[StoreController alloc] init];
	}
	return instance;
}

- (NSArray*)getProducts{
    return self.products;
}

/*get total in cents*/
- (int)getTotal{
    int result = 0;
    for (Product *product in self.itemsInCard) {
        result += product.amount;
    }
    return result;
}
#pragma mark- Get Items from Parse

- (void)getItemsWithComplte:(ControllerCompleteBlock)complete{

	PFQuery *query = [PFQuery queryWithClassName:@"ItemForSale"];
    if(self.products == Nil){
        self.products = [[NSMutableArray alloc] init];
    }
    [self.products removeAllObjects];
    
	[query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
		for (PFObject *obj in objects) {
            Product* product = [Product parse:obj];
            [self.products addObject:product];
        }
        complete(error);
	}];
}
#pragma mark-
- (void)clearCart{
    [self.itemsInCard removeAllObjects];
}
- (void)addProductToCartd:(Product*)product{
    [self.itemsInCard addObject:product];
}

@end
