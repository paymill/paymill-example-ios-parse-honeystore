//
//  CheckOutViewController.m
//  Honey on Sale
//
//  Created by Vladimir Marinov on 14.01.14.
//  Copyright (c) 2014 г. Vladimir Marinov. All rights reserved.
//

#import "CartViewController.h"
#import "MBProgressHUD.h"
#import "StoreController.h"
#import "CardIOPaymentViewController.h"

@interface CartViewController ()

@property (nonatomic, weak) IBOutlet UITextField *existingClient;
@property (nonatomic, weak) IBOutlet UITextField *accHolder;
@property (nonatomic, weak) IBOutlet UITextField *email;
@property (nonatomic, weak) IBOutlet UITextField *cardNumber;
@property (nonatomic, weak) IBOutlet UITextField *cardVerification;
@end

#define CARDIO_TOKEN @"2bcc1401544a4e24b6036b4fda84000f"

@implementation CartViewController


- (IBAction)chooseExistingClient:(id)sender {
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
     UIBarButtonItem *checkoutButton = [[UIBarButtonItem alloc]
                                        initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(payNow:)];
    self.navigationItem.rightBarButtonItem = checkoutButton;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
	[MBProgressHUD showHUDAddedTo:self.view animated:NO];
	[[StoreController getInstance] pullClientsWithComplte:^(NSError *error) {
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//        /[self.productsTable reloadData];
    }];
	
}
#pragma mark- CardIO
/// This method will be called if the user cancels the scan. You MUST dismiss paymentViewController.
/// @param paymentViewController The active CardIOPaymentViewController.
- (void)userDidCancelPaymentViewController:(CardIOPaymentViewController *)paymentViewController{
}

/// This method will be called when there is a successful scan (or manual entry). You MUST dismiss paymentViewController.
/// @param cardInfo The results of the scan.
/// @param paymentViewController The active CardIOPaymentViewController.
- (void)userDidProvideCreditCardInfo:(CardIOCreditCardInfo *)cardInfo inPaymentViewController:(CardIOPaymentViewController *)paymentViewController{
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
