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

@interface PaymentViewController ()

@property (nonatomic, weak) IBOutlet UITextField *existingClient;
@property (nonatomic, strong) UIPickerView *paymentsPicker;
@property (nonatomic, weak) IBOutlet UITextField *accHolder;
@property (nonatomic, weak) IBOutlet UITextField *email;
@property (nonatomic, weak) IBOutlet UILabel *cardNumber;
@property (nonatomic, weak) IBOutlet UILabel *cardVerification;
@property (nonatomic, weak) IBOutlet UILabel *cardExpire;
@property (nonatomic, weak) IBOutlet UILabel *total;
@property (nonatomic, strong) NSString *selectedClientId;
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
    self.paymentsPicker = [[UIPickerView alloc] init];
    self.paymentsPicker.dataSource = self;
    self.paymentsPicker.delegate = self;
    self.paymentsPicker.showsSelectionIndicator = YES;
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]
                                   initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                   target:self action:@selector(selectDidFinish:)];
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    [toolbar setItems: [NSArray arrayWithObject:doneButton]];
    
    [self.paymentsPicker selectedRowInComponent:0];
    [self.existingClient setInputView:self.paymentsPicker];
    self.existingClient.inputAccessoryView = toolbar;
    self.existingClient.delegate = self;
    self.accHolder.text = [PFUser currentUser].username;
    self.email.text = [PFUser currentUser].email;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
	[MBProgressHUD showHUDAddedTo:self.view animated:NO];
	[[StoreController getInstance] getPaymentsWithComplte:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [self.paymentsPicker reloadAllComponents];
    }];
    self.total.text = [NSString stringWithFormat:@"Total: %d.%d", [[StoreController getInstance] getTotal]/ 100,
                       [[StoreController getInstance] getTotal] %100 ];
	
}

- (void)selectDidFinish:(id)sender {
    [self.existingClient resignFirstResponder];
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
    PMClient *client = [[StoreController getInstance].Payments objectAtIndex:row-1];
    return client.description;
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if(row > 0){
        PMClient *client = [[StoreController getInstance].Payments objectAtIndex:row-1];
        self.selectedClientId = client.id;
        self.existingClient.text = client.description;
        self.accHolder.text = client.description;
        self.email.text = client.email;
    }
    else {
        self.selectedClientId = nil;
        self.existingClient.text = @"";
        self.accHolder.text = @"";
        self.email.text = @"";
    }
    [self.existingClient resignFirstResponder];
    
}
#pragma mark- CardIO
/// This method will be called if the user cancels the scan. You MUST dismiss paymentViewController.
/// @param paymentViewController The active CardIOPaymentViewController.
- (void)userDidCancelPaymentViewController:(CardIOPaymentViewController *)paymentViewController{
    [paymentViewController dismissViewControllerAnimated:YES completion:nil];
}

/// This method will be called when there is a successful scan (or manual entry). You MUST dismiss paymentViewController.
/// @param cardInfo The results of the scan.
/// @param paymentViewController The active CardIOPaymentViewController.
- (void)userDidProvideCreditCardInfo:(CardIOCreditCardInfo *)cardInfo inPaymentViewController:(CardIOPaymentViewController *)paymentViewController{
    
    self.cardNumber.text = [NSString stringWithFormat:@"N: %@",cardInfo.cardNumber];
    self.cardVerification.text = [NSString stringWithFormat:@"CCV: %@", cardInfo.cvv];
    self.cardExpire.text = [NSString stringWithFormat:@"Exp: %d/%d", cardInfo.expiryMonth, cardInfo.expiryYear];
    [paymentViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark-
- (void)payNow:(UIButton*)sender{
    [MBProgressHUD showHUDAddedTo:self.view animated:NO];
   /* if(self.clientSwitch.isOn == NO){
        [[StoreController getInstance] payWithClient: self.selectedClientId
                                                    cardNumber: self.cardNumber.text
                                                    cardExpire: self.cardExpire.text
                                                       cardCcv: self.cardVerification.text
                                        complte:^(NSError *error) {
         NSLog(@"%@", error);
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }];
    }
    else{
        [[StoreController getInstance] payWithAccHolder: self.accHolder.text
                                                  email: self.email.text
                                          cardNumber: self.cardNumber.text
                                          cardExpire: self.cardExpire.text
                                             cardCcv: self.cardVerification.text
                                             complte:^(NSError *error) {
           NSLog(@"%@", error);
           [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }];
    
    } */
}
- (IBAction)scanCard:(id)sender {
	CardIOPaymentViewController *scanViewController = [[CardIOPaymentViewController alloc] initWithPaymentDelegate:self];
	scanViewController.appToken = CARDIO_TOKEN;
	[self presentViewController:scanViewController animated:YES completion:nil];
	
}

@end
