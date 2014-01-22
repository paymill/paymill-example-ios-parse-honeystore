//
//  CheckOutViewController.m
//  Honey on Sale
//
//  Created by Vladimir Marinov on 14.01.14.
//  Copyright (c) 2014 г. Vladimir Marinov. All rights reserved.
//

#import "CartViewController.h"
#import "MBProgressHUD.h"

@interface CartViewController ()

@property (nonatomic, weak) IBOutlet UITextField *existingClient;
@property (nonatomic, weak) IBOutlet UITextField *accHolder;
@property (nonatomic, weak) IBOutlet UITextField *email;
@property (nonatomic, weak) IBOutlet UITextField *cardNumber;
@property (nonatomic, weak) IBOutlet UITextField *cardVerification;
@end

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

- (void)payNow:(UIButton*)sender{
    [MBProgressHUD showHUDAddedTo:self.view animated:NO];
}


@end
