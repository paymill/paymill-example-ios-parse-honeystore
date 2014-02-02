//
//  CheckOutViewController.h
//  Honey on Sale
//
//  Created by Lubomir Velkov on 14.01.14.
//  Copyright (c) 2014 г. Vladimir Marinov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardIOPaymentViewControllerDelegate.h"

@protocol PaymentViewControllerDelegate<NSObject>

@required

- (void)transactionSucceed;
- (void)transactionFailWithError:(NSError*)error;

@end

@interface PaymentViewController : UIViewController<CardIOPaymentViewControllerDelegate,
                                        UIPickerViewDataSource,
                                        UIPickerViewDelegate,
                                        UITextFieldDelegate>

@property (nonatomic, strong) NSNumber *amount;
@property (nonatomic, strong) NSString *description;
@property (nonatomic, strong) NSString *currency;
@property (nonatomic, strong) NSArray *existingPayments;
@property (nonatomic, strong) id<PaymentViewControllerDelegate> delegate;


@end
