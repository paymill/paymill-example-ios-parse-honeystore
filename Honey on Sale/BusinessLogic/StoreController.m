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

@interface StoreController()

@property (strong,nonatomic)NSMutableArray *products;
@end

@implementation StoreController

- (StoreController*)init{
	if(self = [super init]){
		[Parse setApplicationId:@"uii9EaqHnJ5fiez0hZOgc5KdIz5Fw9uIXIn24SMY"
					  clientKey:@"mMwscLfDnKDTvVlTUDsiUKp5llTlpJ1hy300F87r"];
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
@end
