//
//  CheckOutViewController.m
//  Honey on Sale
//
//  Created by Vladimir Marinov on 14.01.14.
//  Copyright (c) 2014 г. Vladimir Marinov. All rights reserved.
//

#import "PaymentViewController.h"
#import "MBProgressHUD.h"
#import "StoreController.h"
#import "CardIOPaymentViewController.h"
#import "CardIOCreditCardInfo.h"
#import <PayMillSDK/PMClient.h>
#import <Parse/PFUser.h>
#import <Parse/PFCloud.h>
#import <PayMillSDK/PMFactory.h>
#import <PayMillSDK/PMManager.h>

@interface PaymentViewController ()

@property (nonatomic, weak) IBOutlet UITextField *existingClientTextField;
@property (nonatomic, strong) UIPickerView *paymentsPickerView;
@property (nonatomic, weak) IBOutlet UITextField *accHolderTextField;
@property (nonatomic, weak) IBOutlet UITextField *emailTextField;
@property (nonatomic, weak) IBOutlet UILabel *cardNumberLabel;
@property (nonatomic, weak) IBOutlet UILabel *cardVerificationLabel;
@property (nonatomic, weak) IBOutlet UILabel *cardExpireLabel;
@property (nonatomic, weak) IBOutlet UILabel *totalLabel;
@property (nonatomic, strong) NSString *cardExpireMonth;
@property (nonatomic, strong) NSString *cardExpireYear;
@property (nonatomic, strong) NSString *cardCvv;
@property (nonatomic, strong) NSString *cardNumber;
@property (nonatomic, strong) NSString *existingPaymentId;
@end

#define CARDIO_TOKEN @"2bcc1401544a4e24b6036b4fda84000f"

@implementation PaymentViewController


- (IBAction)chooseExistingClient:(id)sender {
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
     UIBarButtonItem *checkoutButton = [[UIBarButtonItem alloc]
                                        initWithBarButtonSystemItem:UIBarButtonSystemItemPlay
                                        target:self action:@selector(payNow:)];
    self.navigationItem.rightBarButtonItem = checkoutButton;
    self.paymentsPickerView = [[UIPickerView alloc] init];
    self.paymentsPickerView.dataSource = self;
    self.paymentsPickerView.delegate = self;
    self.paymentsPickerView.showsSelectionIndicator = YES;
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]
                                   initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                   target:self action:@selector(selectDidFinish:)];
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    [toolbar setItems: [NSArray arrayWithObject:doneButton]];
    
    [self.paymentsPickerView selectedRowInComponent:0];
    [self.existingClientTextField setInputView:self.paymentsPickerView];
    self.existingClientTextField.inputAccessoryView = toolbar;
    self.existingClientTextField.delegate = self;
    self.accHolderTextField.text = [PFUser currentUser].username;
    self.emailTextField.text = [PFUser currentUser].email;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
	[MBProgressHUD showHUDAddedTo:self.view animated:NO];
	[[StoreController getInstance] getPaymentsWithComplte:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [self.paymentsPickerView reloadAllComponents];
    }];
    self.totalLabel.text = [NSString stringWithFormat:@"Total: %d.%d", [[StoreController getInstance] getTotal]/ 100,
                       [[StoreController getInstance] getTotal] %100 ];
	
}

- (void)selectDidFinish:(id)sender {
    [self.existingClientTextField resignFirstResponder];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}


#pragma mark- UIPickerView
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}


// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [[StoreController getInstance].Payments count] + 1;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if(row == 0){
        return @"Select Card";
    }
    PMPayment *payment = [[StoreController getInstance].Payments objectAtIndex:row-1];
    return payment.last4;
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    PMPayment *payment = [[StoreController getInstance].Payments objectAtIndex:row-1];
    self.cardNumberLabel.text = payment.last4;
    self.cardVerificationLabel.text = payment.code;
    self.cardExpireLabel.text = [NSString stringWithFormat:@"Exp: %@/%@", payment.expire_month, payment.expire_year];
    // save card info
    self.cardExpireMonth = payment.expire_month;
    self.cardExpireYear = payment.expire_year;
     self.existingPaymentId = payment.id;
   [self.existingClientTextField resignFirstResponder];
    
}
#pragma mark- CardIO

- (void)userDidCancelPaymentViewController:(CardIOPaymentViewController *)paymentViewController{
    [paymentViewController dismissViewControllerAnimated:YES completion:nil];
}


- (void)userDidProvideCreditCardInfo:(CardIOCreditCardInfo *)cardInfo inPaymentViewController:(CardIOPaymentViewController *)paymentViewController{
    
    self.cardNumberLabel.text = [NSString stringWithFormat:@"N: %@", cardInfo.cardNumber];
    self.cardVerificationLabel.text = [NSString stringWithFormat:@"CCV: %@", cardInfo.cvv];
    self.cardExpireLabel.text = [NSString stringWithFormat:@"Exp: %d/%d", cardInfo.expiryMonth, cardInfo.expiryYear];
    
    self.cardExpireMonth = [NSString stringWithFormat:@"%d", cardInfo.expiryMonth];
    if(cardInfo.expiryMonth < 10){
         self.cardExpireMonth = [NSString stringWithFormat:@"0%d", cardInfo.expiryMonth];
    }
    self.cardExpireYear = [NSString stringWithFormat:@"%d", cardInfo.expiryYear];
    self.cardNumber = cardInfo.cardNumber;
    self.cardCvv = cardInfo.cvv;

    self.existingPaymentId = nil;
    [paymentViewController dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark-
- (void)createTransactionWithToken:(NSString*)token amount:(NSString*)amount currency:(NSString*)currency descrition:(NSString*)descrition{
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:token forKey:@"token"];
    [parameters setObject:amount forKey:@"amount"];
    [parameters setObject:currency forKey:@"currency"];
    [parameters setObject:descrition forKey:@"descrition"];
    
    [PFCloud callFunctionInBackground:@"createTransactionWithToken" withParameters:parameters
                                block:^(id object, NSError *error) {
                                    
                                    if(error == nil){
                                        [[StoreController getInstance] clearCart];
                                        NSString *msg = @"Payment has been successfull.";
                                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                                                        message:msg delegate:nil
                                                                              cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                        [alert show];
                                    }
                                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                } ];

}
- (void)createTransactionWithPayment:(NSString*)paymentId amount:(NSString*)amount currency:(NSString*)currency descrition:(NSString*)descrition{
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:paymentId forKey:@"paymillPaymentId"];
    [parameters setObject:amount forKey:@"amount"];
    [parameters setObject:currency forKey:@"currency"];
    [parameters setObject:descrition forKey:@"descrition"];
    
    [PFCloud callFunctionInBackground:@"createTransactionWithPayment" withParameters:parameters
                                block:^(id object, NSError *error) {
                                    
                                    if(error == nil){
                                        [[StoreController getInstance] clearCart];
                                        NSString *msg = @"Payment has been successfull.";
                                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                                                        message:msg delegate:nil
                                                                              cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                        [alert show];
                                        
                                    }
                                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                } ];
    
}
- (void)payNow:(UIButton*)sender{
    NSString *amount = [NSString stringWithFormat:@"%d", [[StoreController getInstance] getTotal]];
    [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    if(self.existingPaymentId != nil){
        [self createTransactionWithPayment:self.existingPaymentId amount:amount currency:@"EUR" descrition:@"Descrition"];
    }
    else
    {
        PMError *error;
        PMPaymentParams *params;
        // 1. generate paymill payment method
        id paymentMethod = [PMFactory genCardPaymentWithAccHolder:self.accHolderTextField.text
                                                       cardNumber:self.cardNumber
                                                      expiryMonth:self.cardExpireMonth
                                                       expiryYear:self.cardExpireYear
                                                     verification:self.cardCvv
                                                            error:&error];
        if(!error) {
            // 2. generate params
            params = [PMFactory genPaymentParamsWithCurrency:@"EUR" amount:150 //[[StoreController getInstance] getTotal]
                                                 description:@"3DS Test" error:&error];
        }
        
        if(!error) {
            // 3. generate token
            [PMManager generateTokenWithMethod:paymentMethod parameters:params success:^(NSString *token) {
                //token successfully created
                [self createTransactionWithToken:token amount:amount currency:@"EUR" descrition:@"Descrition"];
            }
                                       failure:^(PMError *error) {
                                           //token generation failed
                                           NSLog(@"Generate Token Error %@", error.message);
                                           [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                       }];  
        }
        else{
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            NSLog(@"GenCardPayment Error %@", error.message);
        }
        
    }

}
- (IBAction)scanCard:(id)sender {
	CardIOPaymentViewController *scanViewController = [[CardIOPaymentViewController alloc] initWithPaymentDelegate:self];
	scanViewController.appToken = CARDIO_TOKEN;
	[self presentViewController:scanViewController animated:YES completion:nil];
	
}

@end
