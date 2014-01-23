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

@interface PaymentViewController ()

@property (nonatomic, weak) IBOutlet UITextField *existingClient;
@property (nonatomic, strong) IBOutlet UIPickerView *clientsPicker;
@property (nonatomic, weak) IBOutlet UITextField *accHolder;
@property (nonatomic, weak) IBOutlet UITextField *email;
@property (nonatomic, weak) IBOutlet UILabel *cardNumber;
@property (nonatomic, weak) IBOutlet UILabel *cardVerification;
@property (nonatomic, weak) IBOutlet UILabel *cardValid;
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
    self.clientsPicker = [[UIPickerView alloc] init];
    self.clientsPicker.dataSource = self;
    self.clientsPicker.delegate = self;
    self.clientsPicker.showsSelectionIndicator = YES;
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]
                                   initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                   target:self action:@selector(selectDidFinish:)];
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    [toolbar setItems: [NSArray arrayWithObject:doneButton]];
    
    [self.clientsPicker selectedRowInComponent:0];
    [self.existingClient setInputView:self.clientsPicker];
    self.existingClient.inputAccessoryView = toolbar;
    self.existingClient.delegate = self;
    self.accHolder.delegate = self;
    self.email.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
	[MBProgressHUD showHUDAddedTo:self.view animated:NO];
	[[StoreController getInstance] pullClientsWithComplte:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [self.clientsPicker reloadAllComponents];
        
    }];
	
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
    return [[StoreController getInstance].Clients count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    PMClient *client = [[StoreController getInstance].Clients objectAtIndex:row];
    return client.description;
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
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
    self.cardValid.text = [NSString stringWithFormat:@"Exp: %d/%d", cardInfo.expiryMonth, cardInfo.expiryYear];
    [paymentViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark-
- (void)payNow:(UIButton*)sender{
    [MBProgressHUD showHUDAddedTo:self.view animated:NO];
}
- (IBAction)scanCard:(id)sender {
	CardIOPaymentViewController *scanViewController = [[CardIOPaymentViewController alloc] initWithPaymentDelegate:self];
	scanViewController.appToken = CARDIO_TOKEN;
	[self presentViewController:scanViewController animated:YES completion:nil];
	
}

@end
