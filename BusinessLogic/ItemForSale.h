//
//  HoneyBox.h
//  Honey on Sale
//
//  Created by Vladimir Marinov on 13.01.14.
//  Copyright (c) 2014 г. Vladimir Marinov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ItemForSale : NSObject

@property(nonatomic, strong) NSString* Id;
@property(nonatomic, strong) NSString* name;
@property(nonatomic, strong) NSString* currency;
@property(nonatomic, strong) NSNumber* amount;

+ (ItemForSale*)parse:(NSDictionary*)dict;

@end
