//
//  CheckOutViewController.h
//  Honey on Sale
//
//  Created by Vladimir Marinov on 14.01.14.
//  Copyright (c) 2014 г. PAYMILL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardIOPaymentViewControllerDelegate.h"

@protocol PMLPaymentViewControllerDelegate<NSObject>

@required

- (void)transactionSucceed;
- (void)transactionFailWithError:(NSError*)error;

@end

@interface PMLPaymentViewController : UIViewController<CardIOPaymentViewControllerDelegate,
                                        UIPickerViewDataSource,
                                        UIPickerViewDelegate,
                                        UITextFieldDelegate>

@property (nonatomic, strong) NSNumber *amount;
@property (nonatomic, strong) NSString *productName;
@property (nonatomic, strong) NSString *currency;
@property (nonatomic, strong) NSArray *existingPayments;
@property (nonatomic, strong) id<PMLPaymentViewControllerDelegate> delegate;


@end
