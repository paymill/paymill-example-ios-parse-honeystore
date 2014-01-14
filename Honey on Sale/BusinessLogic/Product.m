//
//  HoneyBox.m
//  Honey on Sale
//
//  Created by Vladimir Marinov on 13.01.14.
//  Copyright (c) 2014 г. Vladimir Marinov. All rights reserved.
//

#import "Product.h"
#import <Parse/Parse.h>

@implementation Product


+ (Product*)parse:(PFObject*)dict{
	Product *result = [[Product alloc] init];
	result.name = [dict objectForKey:@"name"];
    result.currency = [dict objectForKey:@"currency"];
    result.description = [dict objectForKey:@"descrition"];
    result.Id = [dict objectForKey:@"objectId"];
    result.amount = [[dict objectForKey:@"amount"] floatValue];
    PFFile *image = [dict objectForKey:@"image"];
    
	if(image){
		NSError *error = [[NSError alloc] init];
		result.imageData = [image getData:&error];
	}
	return result;
}

@end
