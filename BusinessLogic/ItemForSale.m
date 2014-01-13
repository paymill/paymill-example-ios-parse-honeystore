//
//  HoneyBox.m
//  Honey on Sale
//
//  Created by Vladimir Marinov on 13.01.14.
//  Copyright (c) 2014 г. Vladimir Marinov. All rights reserved.
//

#import "ItemForSale.h"

@implementation ItemForSale

+ (ItemForSale*)parse:(NSDictionary*)dict{
	ItemForSale *result = [[ItemForSale alloc] init];
	result.name = [dict objectForKey:@"name"];
	return result;
}

@end
