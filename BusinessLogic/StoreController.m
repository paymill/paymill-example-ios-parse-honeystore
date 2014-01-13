//
//  Controller.m
//  Honey on Sale
//
//  Created by Vladimir Marinov on 13.01.14.
//  Copyright (c) 2014 г. Vladimir Marinov. All rights reserved.
//

#import "StoreController.h"
#import <Parse/Parse.h>

@implementation StoreController

- (StoreController*)init{
	if(self = [super init]){
		[Parse setApplicationId:@"uii9EaqHnJ5fiez0hZOgc5KdIz5Fw9uIXIn24SMY"
					  clientKey:@"mMwscLfDnKDTvVlTUDsiUKp5llTlpJ1hy300F87r"];
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


- (void)fillWithData{

	PFQuery *query = [PFQuery queryWithClassName:@"ItemForSale"];
	[query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
		
	}];
}
@end
