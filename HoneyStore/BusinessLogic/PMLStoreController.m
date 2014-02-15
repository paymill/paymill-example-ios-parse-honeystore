//
//  PMLStoreController.m
//  Honey Store
//
//  Created by Vladimir Marinov on 13.01.14.
//  Copyright (c) 2014 г. PAYMLL. All rights reserved.
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
        // Init Parse Library
        _itemsInCard = [[NSMutableArray alloc] init];
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
    int result = 0;
    for (PMLProduct *product in self.itemsInCard) {
        result += product.amount;
    }
    return result;
}
#pragma mark- Get Items from Parse

- (void)getItemsWithComplte:(ControllerCompleteBlock)complete{

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
    [self.itemsInCard removeAllObjects];
}
- (void)addProductToCartd:(PMLProduct*)product{
    [self.itemsInCard addObject:product];
}

@end
