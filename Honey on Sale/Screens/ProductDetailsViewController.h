//
//  DetailViewController.h
//  Honey on Sale
//
//  Created by Vladimir Marinov on 17.12.13.
//  Copyright (c) 2013 г. Vladimir Marinov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CheckoutViewController.h"

@class Product;
@interface ProductDetailsViewController : CheckoutViewController <UISplitViewControllerDelegate>

- (void)setSelectedProduct:(Product*)product;


@end
