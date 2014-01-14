//
//  HoneyBox.h
//  Honey on Sale
//
//  Created by Vladimir Marinov on 10.01.14.
//  Copyright (c) 2014 г. Vladimir Marinov. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PFFile;
@class PFObject;

@interface Product : NSObject

@property(nonatomic,strong) NSString* Id;
@property(nonatomic,strong) NSString* name;
@property(nonatomic,strong) NSString* currency;
@property(nonatomic,assign) CGFloat amount;
@property(nonatomic,strong) PFFile* image;
@property(nonatomic,strong) NSString* description;

+ (Product*)parse:(PFObject*)dict;

@end
