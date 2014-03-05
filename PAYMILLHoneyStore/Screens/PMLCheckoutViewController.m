//
//  PMLCheckoutViewController.m
//  Honey on Sale
//
//  Created by Vladimir Marinov on 1/22/14.
//  Copyright (c) 2014 PAYMILL. All rights reserved.
//

#import "PMLCheckoutViewController.h"
#import "PMLStoreController.h"
#import <Parse/PFUser.h>


@implementation PMLCheckoutViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *logoutbutton = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStylePlain target:self action:@selector(logout:)];

	self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:logoutbutton, nil];
    
    if([self respondsToSelector:@selector(edgesForExtendedLayout)]){
        self.edgesForExtendedLayout=UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars=NO;
        self.automaticallyAdjustsScrollViewInsets=NO;
    }
}

- (void)logout:(UIButton*)sender{
    [PFUser logOut];
    [[PMLStoreController sharedInstance] clearCart];
    [self.navigationController popToRootViewControllerAnimated:YES];
}


#pragma mark- Create Transaction Delegate
- (void)transactionSucceed{
    [[PMLStoreController sharedInstance] clearCart];
    [self.navigationController popToViewController:self animated:YES];
 }
- (void)transactionFailWithError:(NSError*)error{
    NSLog(@"error %@", error.description);
}


@end
