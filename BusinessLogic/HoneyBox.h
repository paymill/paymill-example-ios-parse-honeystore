//
//  HoneyBox.h
//  Honey on Sale
//
//  Created by Lubomir Velkov on 13.01.14.
//  Copyright (c) 2014 г. Vladimir Marinov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HoneyBox : NSObject

@property(nonatomic, strong) NSString* ID;
@property(nonatomic, strong) NSString* Name;
@property(nonatomic, strong) NSString* Currency;
@property(nonatomic, strong) NSNumber* Amount;

@end
