//
//  PMLDefaultViewController.h
//  Honey Store
//
//  Created by Vladimir Marinov on 1/20/14.
//  Copyright (c) 2014 PAYMILL. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <Parse/PFLogInViewController.h>

@interface PMLDefaultViewController : UIViewController<
            PFLogInViewControllerDelegate,
            PFSignUpViewControllerDelegate>

@end
