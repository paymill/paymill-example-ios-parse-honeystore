//
//  PMLProduct.h
//  Honey Store
//
//  Created by Vladimir Marinov on 10.01.14.
//  Copyright (c) 2014 г. PAYMILL. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PFFile;
@class PFObject;

@interface PMLProduct : NSObject

@property(nonatomic,strong) NSString* Id;
@property(nonatomic,strong) NSString* name;
@property(nonatomic,strong) NSString* currency;
@property(nonatomic,assign) int amount;
@property(nonatomic,strong) NSData* imageData;
@property(nonatomic,strong) NSString* description;

+ (PMLProduct*)parse:(PFObject*)dict;

@end
