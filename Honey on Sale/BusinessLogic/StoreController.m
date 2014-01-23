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
@property (strong, nonatomic) NSMutableArray *clients;

@end

@implementation StoreController


- (StoreController*)init{
	if(self = [super init]){
        // Init Parse Library
		[Parse setApplicationId:@"uii9EaqHnJ5fiez0hZOgc5KdIz5Fw9uIXIn24SMY"
					  clientKey:@"mMwscLfDnKDTvVlTUDsiUKp5llTlpJ1hy300F87r"];
        
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
- (NSArray*)getClients{
    return self.clients;
}
- (NSArray*)getProducts{
    return self.products;
}
- (PMClient*)parseClient:(PFObject*)parseObject{
	
	PMClient *result = [[PMClient alloc] init];
	result.description = [parseObject objectForKey:@"description"];
    result.email = [parseObject objectForKey:@"Email"];
    result.id = [parseObject objectForKey:@"clientId"];
   	
	return result;
	
}
- (void)pullClientsWithComplte:(ControllerCompleteBlock)complete{
	
	PFQuery *query = [PFQuery queryWithClassName:@"Client"];
    if(self.clients == Nil){
        self.clients = [[NSMutableArray alloc] init];
    }
    [self.clients removeAllObjects];
    
	[query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
		for (PFObject *obj in objects) {
            PMClient* product = [self parseClient:obj];
            [self.clients addObject:product];
        }
        complete(error);
	}];
}
- (void)pullItemsWithComplte:(ControllerCompleteBlock)complete{

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

- (void)addToCartProduct:(Product*)product{
    [self.itemsInCard addObject:product];
}
@end
