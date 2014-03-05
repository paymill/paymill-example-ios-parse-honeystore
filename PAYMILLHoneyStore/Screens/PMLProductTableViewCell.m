//
//  PMLProductTableViewCell.m
//  Honey on Sale
//
//  Created by Vladimir Marinov on 17.12.13.
//  Copyright (c) 2013 г. PAYMILL All rights reserved.
//

#import "PMLProductTableViewCell.h"
#import "PMLProduct.h"

#define ROW_MARGIN 6.0f
#define ROW_HEIGHT 173.0f

@implementation PMLProductTableViewCell

#pragma mark - Life cycle

- (void)awakeFromNib{
    [super awakeFromNib];
    UIImage *backgroundImage = [UIImage imageNamed:@"Product.png"];
    UIEdgeInsets backgroundInsets = UIEdgeInsetsMake(backgroundImage.size.height/2.0f, backgroundImage.size.width/2.0f, backgroundImage.size.height/2.0f, backgroundImage.size.width/2.0f);
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:[backgroundImage resizableImageWithCapInsets:backgroundInsets]];
    self.backgroundView = backgroundImageView;
    
    self.previewImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.nameLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:18.0f];
    self.nameLabel.textColor = [UIColor colorWithRed:82.0f/255.0f green:87.0f/255.0f blue:90.0f/255.0f alpha:1.0f];
    self.nameLabel.shadowColor = [UIColor colorWithWhite:1.0f alpha:0.7f];
    self.nameLabel.shadowOffset = CGSizeMake(0.0f, 0.5f);
    self.nameLabel.backgroundColor = [UIColor clearColor];
    
    self.priceLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:20.0f];
    self.priceLabel.textColor = [UIColor colorWithRed:14.0f/255.0f green:190.0f/255.0f blue:255.0f/255.0f alpha:1.0f];
    self.priceLabel.shadowColor = [UIColor colorWithWhite:1.0f alpha:0.7f];
    self.priceLabel.shadowOffset = CGSizeMake(0.0f, 0.5f);
    self.priceLabel.backgroundColor = [UIColor clearColor];

     [self.orderButton setTitle:NSLocalizedString(@"Buy", @"Buy") forState:UIControlStateNormal];
    self.orderButton.titleLabel.shadowColor = [UIColor colorWithWhite:0.0f alpha:0.7f];
    self.orderButton.titleLabel.shadowOffset = CGSizeMake(0.0f, -0.5f);
    self.orderButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:16.0f];
    
}


#pragma mark - UITableViewCell



#pragma mark - Public
+ (CGFloat)rowHeight{
    return ROW_HEIGHT;
}
- (void)configureProduct:(PMLProduct *)product {
    self.previewImageView.image = [UIImage imageWithData:product.imageData];
    self.priceLabel.text = [NSString stringWithFormat:@"%d.%d %@", product.amount/100,  product.amount%100, product.currency];
    self.nameLabel.text = product.name;
}


@end
