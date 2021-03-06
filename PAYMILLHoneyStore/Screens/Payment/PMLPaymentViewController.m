//
//  CheckOutViewController.m
//  Honey on Sale
//
//  Created by Vladimir Marinov on 14.01.14.
//  Copyright (c) 2014 г. Vladimir Marinov. All rights reserved.
//

#import "PMLPaymentViewController.h"
#import "MBProgressHUD.h"
#import "CardIOPaymentViewController.h"
#import "CardIOCreditCardInfo.h"
#import <PayMillSDK/PMClient.h>
#import <Parse/PFUser.h>
#import <Parse/PFCloud.h>
#import <PayMillSDK/PMFactory.h>
#import <PayMillSDK/PMManager.h>

@interface PMLPaymentViewController ()

@property (nonatomic, weak) IBOutlet UITextField *existingClientTextField;
@property (nonatomic, weak) IBOutlet UIView *oldPaymentsView;
@property (nonatomic, weak) IBOutlet UIView *cardView;

@property (nonatomic, weak) IBOutlet UIView *paymentsView;
@property (nonatomic, weak) IBOutlet UIPickerView *paymentsPickerView;

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
@property (nonatomic, strong) NSString *selectedPaymentId;
@property (strong, nonatomic) NSMutableArray *oldPayments;

- (void)getOldPayments;

@end


@implementation PMLPaymentViewController

#define CARDIO_TOKEN @"CARDIO_TOKEN"
NSString *PAYMILL_PUBLIC_KEY = @"PAYMILL_PUBLIC_KEY";

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem *checkoutButton = [[UIBarButtonItem alloc]
                                       initWithTitle:@"Pay Now" style:UIBarButtonItemStyleDone
                                       target:self action:@selector(payNow:)];
    self.navigationItem.rightBarButtonItem = checkoutButton;
    self.paymentsPickerView.dataSource = self;
    self.paymentsPickerView.delegate = self;
    self.paymentsPickerView.showsSelectionIndicator = YES;
    self.paymentsView.frame = CGRectMake(0, self.view.frame.size.height + self.paymentsView.frame.size.height,
                                         self.paymentsView.frame.size.width, self.paymentsView.frame.size.height);


    self.accHolderTextField.text = [PFUser currentUser].username;
    self.emailTextField.text = [PFUser currentUser].email;
    if([self respondsToSelector:@selector(edgesForExtendedLayout)]){
        self.edgesForExtendedLayout=UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}
- (void)clearCardInfo{
    self.cardVerificationLabel.text = @"";
    self.cardExpireLabel.text = @"";
    self.cardExpireLabel.text = @"";
    self.cardNumberLabel.text = @"";
    self.selectedPaymentId = nil;
}
- (IBAction)selectDidFinish:(id)sender{
    int selectedRow = [self.paymentsPickerView selectedRowInComponent:0];
    if(selectedRow > 0)
    {
        PMPayment *payment = [self.oldPayments objectAtIndex: selectedRow -1];
        self.cardNumberLabel.text = [NSString stringWithFormat:@"*****%@", payment.last4 ];
        self.cardVerificationLabel.text = payment.code;
        self.cardExpireLabel.text = [NSString stringWithFormat:@"Exp: %@/%@", payment.expire_month, payment.expire_year];
        self.cardVerificationLabel.text = @"****";
        // save card info
        self.cardExpireMonth = payment.expire_month;
        self.cardExpireYear = payment.expire_year;
        self.selectedPaymentId = payment.id;
    }
    else {
        [self clearCardInfo];
    }
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:.50];
    [UIView setAnimationDelegate:self];
    self.paymentsView.frame = CGRectMake(0, self.view.frame.size.height + self.paymentsView.frame.size.height,
                                               self.paymentsView.frame.size.width, self.paymentsView.frame.size.height);
    [UIView commitAnimations];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
	[MBProgressHUD showHUDAddedTo:self.view animated:YES];
	[self getOldPayments];
    self.totalLabel.text = [NSString stringWithFormat:@"Total: %d.%d %@", [self.amount intValue]/ 100,
                       [self.amount intValue] %100, self.currency ];
	
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
    return self.oldPayments.count + 1;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if(row == 0){
        return @"Select Card";
    }
    PMPayment *payment = [self.oldPayments objectAtIndex:row-1];
    return [NSString stringWithFormat:@"*****%@", payment.last4 ];
}
/*
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    PMPayment *payment = [self.oldPayments objectAtIndex:row-1];
    self.cardNumberLabel.text = [NSString stringWithFormat:@"*****%@", payment.last4 ];
    self.cardVerificationLabel.text = payment.code;
    self.cardExpireLabel.text = [NSString stringWithFormat:@"Exp: %@/%@", payment.expire_month, payment.expire_year];
    self.cardVerificationLabel.text = @"****";
    // save card info
    self.cardExpireMonth = payment.expire_month;
    self.cardExpireYear = payment.expire_year;
     self.selectedPaymentId = payment.id;
   [self.existingClientTextField resignFirstResponder];
    
}*/
#pragma mark- Get Old Payments
- (PMPayment*)parsePayment:(PFObject*)parseObject{
	
	PMPayment *result = [[PMPayment alloc] init];
	result.type = [parseObject objectForKey:@"type"];
    result.card_type = [parseObject objectForKey:@"card_type"];
    result.id = [parseObject objectForKey:@"id"];
    result.expire_month = [parseObject objectForKey:@"expire_month"];
    result.expire_year = [parseObject objectForKey:@"expire_year"];
    result.last4 = [parseObject objectForKey:@"last4"];
	return result;
	
}
- (void)hideOldPaymentsView{
    [UIView animateWithDuration:0.6
                          delay: 0.0
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.oldPaymentsView.alpha = 0.0;
                         CGRect frame = self.oldPaymentsView.frame;
                         [self.cardView setFrame:CGRectMake(frame.origin.x, frame.origin.y,
                                                            self.cardView.frame.size.width, self.cardView.frame.size.height)];
                        
                     }
                     completion:^(BOOL finished){
                         // Wait one second and then fade in the view
                         self.oldPaymentsView.hidden = YES;
                     }];
    
   
}
- (void)getOldPayments{
	
    if(self.oldPayments == Nil){
        self.oldPayments = [[NSMutableArray alloc] init];
    }
    [self.oldPayments removeAllObjects];
    [PFCloud callFunctionInBackground:@"getPayments" withParameters:@{}
                                block:^(id object, NSError *error) {
                                    if(error == nil){
                                        NSArray *payments = nil;
                                        if([object isKindOfClass:[NSDictionary class]])
                                        {
                                            payments = [ (NSDictionary*)object  objectForKey:@"items"];
                                        }
                                        else if([object isKindOfClass:[NSArray class]]){
                                            payments = (NSArray*)object;
                                        }
                                         if(payments != nil && [payments count] > 0){
                                            for (PFObject *obj in payments) {
                                                PMPayment* pmPayment = [self parsePayment:obj];
                                                if([pmPayment.last4 isKindOfClass:[NSNull class]] == NO){
                                                    [self.oldPayments addObject:pmPayment];
                                                }
                                            }
                                        }
                                        
                                    }
                                    else {
                                        NSLog(@"Error %@", error.localizedDescription);
                                    }
                                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                    if([self.oldPayments count] == 0){
                                        [self hideOldPaymentsView];
                                    }
                                    [self.paymentsPickerView reloadAllComponents];
                                } ];
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

    self.selectedPaymentId = nil;
    [paymentViewController dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark- Create Transaction
- (void)transactionSucceed{
    NSString *msg = @"Transaction has been successfull";
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                    message:msg delegate:nil
                                          cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    if([self.delegate respondsToSelector:@selector(transactionSucceed) ]){
        [self.delegate transactionSucceed];
    }
}
- (void)transactionFailWithError:(NSError*)error{
    NSString *msg = @"Transaction has failed.";
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                    message:msg delegate:nil
                                          cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];

    NSLog(@"error %@", error.description);
    if([self.delegate respondsToSelector:@selector(transactionFailWithError:) ]){
        [self.delegate transactionFailWithError:error];
    }
    
}
- (NSString*)paymentDescription{
    NSString* clientId = [[PFUser currentUser] objectForKey:@"paymillClientId"];
    return [NSString stringWithFormat:@"client:%@ purchase:%@", clientId, self.productName];
}
- (void)createTransactionWithToken:(NSString*)token {
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:token forKey:@"token"];
    [parameters setObject:self.amount forKey:@"amount"];
    [parameters setObject:self.currency forKey:@"currency"];
    [parameters setObject:[self paymentDescription] forKey:@"description"];

    [PFCloud callFunctionInBackground:@"createTransactionWithToken" withParameters:parameters
                                block:^(id object, NSError *error) {
                                    if(error == nil && [(NSString*)object isEqualToString:@"success"] ){
                                        [self transactionSucceed];
                                    }
                                    else {
                                        [self transactionFailWithError:error];
                                    }
                                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                } ];

}
- (void)createTransactionWithPayment:(NSString*)paymentId
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:paymentId forKey:@"paymillPaymentId"];
    [parameters setObject:self.amount forKey:@"amount"];
    [parameters setObject:self.currency forKey:@"currency"];
    [parameters setObject:[self paymentDescription] forKey:@"description"];
    [PFCloud callFunctionInBackground:@"createTransactionWithPayment" withParameters:parameters
                                block:^(id object, NSError *error) {
                                    
                                    if(error == nil && [(NSString*)object isEqualToString:@"success"] ){
                                        [self transactionSucceed];
                                     }
                                    else {
                                        [self transactionFailWithError:error];
                                    }
                                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                } ];
    
}

- (void)createTransactionForAccHolder:(NSString *)ccHolder cardNumber:(NSString*)cardNumber
                          expiryMonth:(NSString*)expiryMonth
                           expiryYear:(NSString*)expiryYear cardCvv:(NSString*)cardCvv{
    NSError *error;
    PMPaymentParams *params;
    // 1. generate paymill payment method
    id paymentMethod = [PMFactory genCardPaymentWithAccHolder:ccHolder
                                                   cardNumber:cardNumber
                                                  expiryMonth:expiryMonth
                                                   expiryYear:expiryYear
                                                 verification:cardCvv
                                                        error:&error];
    if(!error) {
        // 2. generate params
        params = [PMFactory genPaymentParamsWithCurrency:self.currency amount:[self.amount intValue]
                                             description:self.description error:&error];
    }
    
    if(!error) {
        // 3. generate token
        [PMManager generateTokenWithPublicKey:PAYMILL_PUBLIC_KEY
                                     testMode:YES method:paymentMethod
                                   parameters:params success:^(NSString *token) {
                                       //token successfully created
                                       [self createTransactionWithToken:token];
                                   }
                                      failure:^(NSError *error) {
                                          //token generation failed
                                          NSLog(@"Generate Token Error %@", error.localizedDescription);
                                          [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                      }];  
    }
    else{
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSLog(@"GenCardPayment Error %@", error.localizedDescription);
    }
}

- (IBAction)showExistingCards:(id)sender{
    self.paymentsView.frame = CGRectMake(0, self.view.frame.size.height + self.paymentsView.frame.size.height,
                                    self.paymentsView.frame.size.width, self.paymentsView.frame.size.height);
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:.50];
    [UIView setAnimationDelegate:self];
    self.paymentsView.frame = CGRectMake(0, self.view.frame.size.height - self.paymentsView.frame.size.height,
                                 self.paymentsView.frame.size.width, self.paymentsView.frame.size.height);
    [UIView commitAnimations];
}
- (BOOL)formIsValid{
    if(self.cardNumberLabel.text.length == 0){
        NSString *msg = @"Please enter credit card";
        if([self.oldPayments count] > 0){
            msg = [msg stringByAppendingString:@" or select existing"];
        }
        msg = [msg stringByAppendingString:@"."];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:msg delegate:nil
                                              cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return NO;
    }
    return YES;
}
- (void)payNow:(UIButton*)sender{
    if([self formIsValid] == YES){
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        if(self.selectedPaymentId != nil){
            [self createTransactionWithPayment:self.selectedPaymentId ];
        }
        else
        {
            [self createTransactionForAccHolder:self.accHolderTextField.text
                                     cardNumber:self.cardNumber expiryMonth: self.cardExpireMonth
                                     expiryYear:self.cardExpireYear cardCvv:self.cardCvv];
            
        }
    }

}
- (IBAction)scanCard:(id)sender {
	CardIOPaymentViewController *scanViewController = [[CardIOPaymentViewController alloc] initWithPaymentDelegate:self];
	scanViewController.appToken = CARDIO_TOKEN;
	[self presentViewController:scanViewController animated:YES completion:nil];
	
}

@end
