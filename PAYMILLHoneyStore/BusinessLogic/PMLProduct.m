//
//  PMLProduct.m
//  Honey on Sale
//
//  Created by Vladimir Marinov on 13.01.14.
//  Copyright (c) 2014 г. PAYMILL All rights reserved.
//

#import "PMLProduct.h"
#import <Parse/Parse.h>

@implementation PMLProduct


+ (PMLProduct*)parse:(PFObject*)dict{
	PMLProduct *result = [[PMLProduct alloc] init];
	result.name = [dict objectForKey:@"name"];
    result.currency = [dict objectForKey:@"currency"];
    result.description = [dict objectForKey:@"descrition"];
    result.Id = [dict objectForKey:@"objectId"];
    result.amount = [[dict objectForKey:@"amount"] doubleValue] * 100;
    NSString *imageURL = [dict objectForKey:@"image"];
    
	if(imageURL){
		result.imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]];
    }
	return result;
}

@end
