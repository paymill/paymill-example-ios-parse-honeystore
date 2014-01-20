//
//  LoginScreenViewController.m
//  Honey on Sale
//
//  Created by Vladimir Marinov on 1/20/14.
//  Copyright (c) 2014 Vladimir Marinov. All rights reserved.
//

#import "LoginScreenViewController.h"
#import <PayMillSDK/PMSDK.h>
#import "StoreController.h"

@interface LoginScreenViewController ()

@end

@implementation LoginScreenViewController

static NSString *publicKey = @"4369741839217a7d10cbed5d417715f4";

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
   
}
- (IBAction)Login:(id)sender {
    [PMManager initWithTestMode:NO merchantPublicKey:publicKey
                    newDeviceId:nil init:^(BOOL success, PMError *error) {
                        if(success){
                            [self performSegueWithIdentifier:@"GoToStoreSeque" sender:self];
                            [StoreController getInstance].payMillPublicKey = publicKey;
                        }
                        else {
                            UIAlertView *notAuthorized = [[UIAlertView alloc] initWithTitle:@"Authorization failed" message:error.message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                            [notAuthorized show];
                        }
                    }];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
