//
//  PMLProductDetailsViewController.m
//  Honey Store
//
//  Created by Vladimir Marinov on 17.12.13.
//  Copyright (c) 2013 г. PAYMILL. All rights reserved.
//

#import "PMLProductDetailsViewController.h"
#import "PMLProduct.h"
#import "PMLStoreController.h"



@interface PMLProductDetailsViewController ()

@property (nonatomic, weak) IBOutlet UITextView *descriptionView;
@property (nonatomic, weak) IBOutlet UIButton *addToCartButton;
@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (nonatomic, weak) IBOutlet UILabel *amountLabel;

- (void)configureView;

@property(nonatomic, strong) PMLProduct *product;

@end

@implementation PMLProductDetailsViewController

#pragma mark - Managing the detail item

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.navigationController.navigationBar.translucent = NO;
	[self configureView];
    
   
 }

- (void)setSelectedProduct:(PMLProduct*)product{
	self.product = product;
}
- (void)configureView
{
    // Update the user interface for the detail item.
	if (self.product) {
		self.navigationItem.title = self.product.name;
	    self.descriptionView.text = self.product.description;
		self.amountLabel.text = [NSString stringWithFormat:@"%d.%d %@", self.product.amount/100, self.product.amount%100, self.product.currency];
		UIImage *image = [UIImage imageWithData:self.product.imageData];
		self.imageView.image = image;
	}

}
// Add Selected Item To Cart
- (IBAction)addToCart:(id)sender {
    [[PMLStoreController sharedInstance] addProductToCartd:self.product];
    NSString *msg = [NSString stringWithFormat:@"%@ has been added to your Cart.", self.product.name];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                            message:msg delegate:nil
                                                  cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [self updateBadge];
    [alert show];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Split view



@end