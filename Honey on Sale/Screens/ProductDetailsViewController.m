//
//  DetailViewController.m
//  Honey on Sale
//
//  Created by Vladimir Marinov on 17.12.13.
//  Copyright (c) 2013 г. Vladimir Marinov. All rights reserved.
//

#import "ProductDetailsViewController.h"
#import "Product.h"
#import "StoreController.h"
#import "MLPAccessoryBadge.h"


@interface ProductDetailsViewController ()

@property (nonatomic, weak) IBOutlet UITextView *descriptionView;
@property (nonatomic, weak) IBOutlet UIButton *addToCartButton;
@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (nonatomic, weak) IBOutlet UILabel *amountLabel;
@property (nonatomic, strong) IBOutlet MLPAccessoryBadge *numberBadge;

- (void)configureView;

@property(nonatomic, strong) Product *product;

@end

@implementation ProductDetailsViewController

#pragma mark - Managing the detail item

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.navigationController.navigationBar.translucent = NO;
	[self configureView];
    
    if (!self.numberBadge) {
        self.numberBadge = [[MLPAccessoryBadge alloc] initWithFrame:CGRectZero];
    }
    self.numberBadge.center = CGPointMake(30.0, 6);
    self.numberBadge.badgeMinimumSize = CGSizeMake(1.0, 1.0);
    self.numberBadge.backgroundColor = [UIColor redColor];
    self.numberBadge.shadowAlpha = 0.9;
    self.numberBadge.cornerRadius = 5.0f;
    self.numberBadge.strokeColor = [UIColor whiteColor];
    [self.navigationController.navigationBar addSubview:self.numberBadge];
    [self.numberBadge setTextWithIntegerValue:9];
}


- (void)setSelectedProduct:(Product*)product{
	self.product = product;
}
- (void)configureView
{
    // Update the user interface for the detail item.
	if (self.product) {
		self.navigationItem.title = self.product.name;
	    self.descriptionView.text = self.product.description;
		self.amountLabel.text = [NSString stringWithFormat:@"%.2f %@", self.product.amount, self.product.currency];
		UIImage *image = [UIImage imageWithData:self.product.imageData];
		self.imageView.image = image;
	}
	UIBarButtonItem *checkoutButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(checkoutObjects:)];
	self.navigationItem.rightBarButtonItem = checkoutButton;
}
// Add Selected Item To Cart
- (IBAction)addToCart:(id)sender {
    [[StoreController getInstance] addToCartProduct:self.product]; 
    
}

- (void)checkoutObjects:(UIButton*)sender{
	[self performSegueWithIdentifier:@"CheckOutSeque" sender:sender];
	
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Split view



@end
