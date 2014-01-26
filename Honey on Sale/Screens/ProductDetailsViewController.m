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



@interface ProductDetailsViewController ()

@property (nonatomic, weak) IBOutlet UITextView *descriptionView;
@property (nonatomic, weak) IBOutlet UIButton *addToCartButton;
@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (nonatomic, weak) IBOutlet UILabel *amountLabel;

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
		self.amountLabel.text = [NSString stringWithFormat:@"%d.%d %@", self.product.amount/100, self.product.amount%100, self.product.currency];
		UIImage *image = [UIImage imageWithData:self.product.imageData];
		self.imageView.image = image;
	}

}
// Add Selected Item To Cart
- (IBAction)addToCart:(id)sender {
    [[StoreController getInstance] addProductToCartd:self.product];
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
