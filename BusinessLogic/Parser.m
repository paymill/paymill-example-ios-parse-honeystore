//
//  Parser.m
//  Honey on Sale
//
//  Created by Vladimir Marinov on 13.01.14.
//  Copyright (c) 2014 г. Vladimir Marinov. All rights reserved.
//

#import "Parser.h"

@implementation Parser


Parser *instance;

+ (Parser*)getInstance{
	if(instance == nil){
		instance = [[Parser alloc] init];
	}
	return instance;
}

@end
