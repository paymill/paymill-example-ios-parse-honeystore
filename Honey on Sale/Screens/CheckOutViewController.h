//
//  CheckoutViewController.h
//  Honey on Sale
//
//  Created by Vladimir Marinov on 1/22/14.
//  Copyright (c) 2014 Vladimir Marinov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLPAccessoryBadge.h"
#import "PaymentViewController.h"

@interface CheckoutViewController : UIViewController<PaymentViewControllerDelegate>

- (void)updateBadge;
@end
