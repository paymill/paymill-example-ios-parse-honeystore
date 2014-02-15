//
//  PMLCheckoutViewController.h
//  Honey Store
//
//  Created by Vladimir Marinov on 1/22/14.
//  Copyright (c) 2014 PAYMILL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PMLAccessoryBadge.h"
#import "PMLPaymentViewController.h"

@interface PMLCheckoutViewController : UIViewController<PMLPaymentViewControllerDelegate>

- (void)updateBadge;
@end
