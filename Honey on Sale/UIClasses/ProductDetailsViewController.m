//
//  DetailViewController.m
//  Honey on Sale
//
//  Created by Vladimir Marinov on 17.12.13.
//  Copyright (c) 2013 г. Vladimir Marinov. All rights reserved.
//

#import "ProductDetailsViewController.h"
#import "Product.h"

@interface ProductDetailsViewController ()

@property(weak,nonatomic) IBOutlet UITextView *descriptionView;
@property(weak,nonatomic) IBOutlet UIButton *addToCartButton;
@property(weak,nonatomic) IBOutlet UIImageView *imageView;
@property(weak,nonatomic) IBOutlet UILabel *amountLabel;

- (void)configureView;

@property(nonatomic, strong) Product *product;

@end

@implementation ProductDetailsViewController

#pragma mark - Managing the detail item



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
- (void)checkoutObjects:(id)sender{
	// [MBProgressHUD showHUDAddedTo:self.view animated:NO];
	
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	self.navigationController.navigationBar.translucent = NO;
	if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
	[self configureView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Split view



@end
