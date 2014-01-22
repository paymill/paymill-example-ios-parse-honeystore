//
//  CheckoutViewController.m
//  Honey on Sale
//
//  Created by Vladimir Marinov on 1/22/14.
//  Copyright (c) 2014 Vladimir Marinov. All rights reserved.
//

#import "CheckoutViewController.h"
#import "StoreController.h"

@interface CheckoutViewController ()

@property (nonatomic, strong) IBOutlet MLPAccessoryBadge *numberBadge;

@end

@implementation CheckoutViewController

- (void)updateBadge{
    int productsInStore = [[ StoreController getInstance].itemsInCard count];
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
        self.numberBadge = [[MLPAccessoryBadge alloc] initWithFrame:frame];
    }
    
    UIBarButtonItem *checkoutButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(checkoutObjects:)];
	self.navigationItem.rightBarButtonItem = checkoutButton;
    self.numberBadge.center = CGPointMake(30.0, 6);
    self.numberBadge.badgeMinimumSize = CGSizeMake(1.0, 1.0);
    self.numberBadge.backgroundColor = [UIColor redColor];
    self.numberBadge.shadowAlpha = 0.9;
    self.numberBadge.cornerRadius = 5.0f;
    self.numberBadge.strokeColor = [UIColor whiteColor];
    [self.navigationController.navigationBar addSubview:self.numberBadge];
   
    [self.numberBadge setTextWithIntegerValue:9];
    self.numberBadge.hidden = YES;
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self updateBadge];
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.numberBadge.hidden = YES;
}

- (void)checkoutObjects:(UIButton*)sender{
    [self performSegueWithIdentifier:@"CheckOutSeque" sender:sender];   
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
