//
//  PMLCheckoutViewController.m
//  Honey Store
//
//  Created by Vladimir Marinov on 1/22/14.
//  Copyright (c) 2014 PAYMILL. All rights reserved.
//

#import "PMLCheckoutViewController.h"
#import "PMLStoreController.h"
#import <Parse/PFUser.h>

@interface PMLCheckoutViewController ()

@property (nonatomic, strong) IBOutlet PMLAccessoryBadge *numberBadge;

@end

@implementation PMLCheckoutViewController

- (void)updateBadge{
    int productsInStore = [[ PMLStoreController sharedInstance].itemsInCard count];
    if(productsInStore > 0){
        [self.numberBadge setTextWithIntegerValue:productsInStore];
        self.numberBadge.hidden = NO;
    }
}

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
    if(!self.numberBadge){
        CGRect frame = CGRectMake(100, 10, 50, 50);
        self.numberBadge = [[PMLAccessoryBadge alloc] initWithFrame:frame];
    }
    
    UIBarButtonItem *checkoutButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(checkoutObjects:)];
    UIBarButtonItem *logoutbutton = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStylePlain target:self action:@selector(logout:)];

	self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:logoutbutton, checkoutButton, nil];
    
    self.numberBadge.center = CGPointMake(30.0, 6);
    self.numberBadge.badgeMinimumSize = CGSizeMake(1.0, 1.0);
    self.numberBadge.backgroundColor = [UIColor redColor];
    self.numberBadge.shadowAlpha = 0.9;
    self.numberBadge.cornerRadius = 5.0f;
    self.numberBadge.strokeColor = [UIColor whiteColor];
    [self.navigationController.navigationBar addSubview:self.numberBadge];
    [self.navigationController.navigationBar bringSubviewToFront:self.numberBadge];
   
    [self.numberBadge setTextWithIntegerValue:9];
    self.numberBadge.hidden = YES;
    
    if([self respondsToSelector:@selector(edgesForExtendedLayout)]){
        self.edgesForExtendedLayout=UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars=NO;
        self.automaticallyAdjustsScrollViewInsets=NO;
    }
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self updateBadge];
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.numberBadge.hidden = YES;
}
- (void)logout:(UIButton*)sender{
    [PFUser logOut];
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)checkoutObjects:(UIButton*)sender{
    if([[PMLStoreController sharedInstance] getTotal] > 0){
        [self performSegueWithIdentifier:@"CheckOutSeque" sender:sender];
    }
    else{
        NSString *msg = @"Please add items to cart.";
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:msg delegate:nil
                                              cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender   {
    if ([[segue identifier] isEqualToString:@"CheckOutSeque"])
    {
        PMLPaymentViewController *vc = [segue destinationViewController];
        vc.amount = [NSNumber numberWithInt:[[PMLStoreController sharedInstance] getTotal]];
        vc.description = @"Description";
        vc.currency = @"EUR";
        vc.delegate = self;

    }
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
