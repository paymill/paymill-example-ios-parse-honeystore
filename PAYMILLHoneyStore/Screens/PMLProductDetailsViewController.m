//
//  PMLProductDetailsViewController.m
//  Honey on Sale
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
// Add Selected Product To Cart
- (IBAction)addProductToCart:(id)sender {
    [PMLStoreController sharedInstance].productInCard = self.product;
    [self performSegueWithIdentifier:@"CheckOutSeque" sender:sender];

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender   {
    if ([[segue identifier] isEqualToString:@"CheckOutSeque"])
    {
        PMLPaymentViewController *vc = [segue destinationViewController];
        vc.amount = [NSNumber numberWithInt:[PMLStoreController sharedInstance].productInCard.amount];
        vc.productName = [PMLStoreController sharedInstance].productInCard.name;
        vc.currency = [PMLStoreController sharedInstance].productInCard.currency;
        vc.delegate = self;
        
    }
}


@end
