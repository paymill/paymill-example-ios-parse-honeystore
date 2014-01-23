//
//  CheckOutViewController.h
//  Honey on Sale
//
//  Created by Lubomir Velkov on 14.01.14.
//  Copyright (c) 2014 г. Vladimir Marinov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardIOPaymentViewControllerDelegate.h"
@interface PaymentViewController : UIViewController<CardIOPaymentViewControllerDelegate,
                                        UIPickerViewDataSource,
                                        UIPickerViewDelegate,
                                        UITextFieldDelegate>

@end
