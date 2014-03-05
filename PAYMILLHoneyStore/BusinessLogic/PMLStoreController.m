//
//  PMLStoreController.m
//  Honey on Sale
//
//  Created by Vladimir Marinov on 13.01.14.
//  Copyright (c) 2014 г. PAYMLL All rights reserved.
//

#import "PMLStoreController.h"
#import <Parse/Parse.h>
#import "PMLProduct.h"
#import <PayMillSDK/PMClient.h>
#import <PayMillSDK/PMSDK.h>

@interface PMLStoreController()

@property (strong, nonatomic) NSMutableArray *products;

@end

@implementation PMLStoreController


- (PMLStoreController*)init{
	if(self = [super init]){
        return self;
	}
	return nil;
}

+ (PMLStoreController*)sharedInstance{
    static PMLStoreController *sharedInstance = nil;
    static dispatch_once_t pred;
    
    dispatch_once(&pred, ^{
        sharedInstance = [[PMLStoreController alloc] init];
    });
    return sharedInstance;
}

- (NSArray*)getProducts{
    return self.products;
}

/*get total in cents*/
- (int)getTotal{
    return self.productInCard.amount;
}
#pragma mark- Get Items from Parse

- (void)getProductsWithComplte:(ControllerCompleteBlock)complete{

	PFQuery *query = [PFQuery queryWithClassName:@"Product"];
    if(self.products == Nil){
        self.products = [[NSMutableArray alloc] init];
    }
    [self.products removeAllObjects];
    
	[query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
		for (PFObject *obj in objects) {
            PMLProduct* product = [PMLProduct parse:obj];
            [self.products addObject:product];
        }
        complete(error);
	}];
}
#pragma mark-
- (void)clearCart{
    self.productInCard = nil;
}
- (void)addProductToCartd:(PMLProduct*)product{
    [self clearCart];
    self.productInCard = product;
}

@end
