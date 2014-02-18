//
//  PMLProductDetailsViewController.h
//  Honey on Sale
//
//  Created by Vladimir Marinov on 17.12.13.
//  Copyright (c) 2013 г. PAYMILL All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PMLCheckoutViewController.h"

@class PMLProduct;
@interface PMLProductDetailsViewController : PMLCheckoutViewController <UISplitViewControllerDelegate>

- (void)setSelectedProduct:(PMLProduct*)product;


@end
