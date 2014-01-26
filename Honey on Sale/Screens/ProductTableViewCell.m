//
//  ProductTableViewCell.m
//  Honey on Sale
//
//  Created by Vladimir Marinov on 17.12.13.
//  Copyright (c) 2013 г. Vladimir Marinov. All rights reserved.
//

#import "ProductTableViewCell.h"
#import "Product.h"

#define ROW_MARGIN 6.0f
#define ROW_HEIGHT 173.0f

@interface ProductTableViewCell()



@end

@implementation ProductTableViewCell

#pragma mark - Life cycle

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.priceLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.priceLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:20.0f];
        self.priceLabel.textColor = [UIColor colorWithRed:14.0f/255.0f green:190.0f/255.0f blue:255.0f/255.0f alpha:1.0f];
        self.priceLabel.shadowColor = [UIColor colorWithWhite:1.0f alpha:0.7f];
        self.priceLabel.shadowOffset = CGSizeMake(0.0f, 0.5f);
        self.priceLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.priceLabel];
        
        self.orderButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [self.orderButton setTitle:NSLocalizedString(@"Order", @"Order") forState:UIControlStateNormal];
        self.orderButton.titleLabel.shadowColor = [UIColor colorWithWhite:0.0f alpha:0.7f];
        self.orderButton.titleLabel.shadowOffset = CGSizeMake(0.0f, -0.5f);
        self.orderButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:16.0f];
        
        [self addSubview:self.orderButton];
        
        self.previewImageView = [[UIImageView alloc] init];
        [self addSubview:self.previewImageView];
    }
    return self;
}

#pragma mark - UIView

- (void)layoutSubviews {
    CGFloat x = ROW_MARGIN;
    CGFloat y = ROW_MARGIN;
    self.backgroundView.frame = CGRectMake(x, y, self.frame.size.width - ROW_MARGIN*2.0f, 167.0f);
    x += 10.0f;

    self.previewImageView.frame = CGRectMake(x, y + 1.0f, 120.0f, 165.0f);
    x += 120.0f + 5.0f;
    y += 10.0f;
    
    [self.priceLabel sizeToFit];
    CGFloat priceX = self.frame.size.width - self.priceLabel.frame.size.width - ROW_MARGIN - 10.0f;
    self.priceLabel.frame = CGRectMake(priceX, ROW_MARGIN + 10.0f, self.priceLabel.frame.size.width, self.priceLabel.frame.size.height);
    
    y += 40.0f;
    
    [self.textLabel sizeToFit];
    self.textLabel.frame = CGRectMake(x + 2.0f, y, self.textLabel.frame.size.width, self.textLabel.frame.size.height);
    y += self.textLabel.frame.size.height + 2.0f;
    
    y += 36.0f;
    
    self.orderButton.frame = CGRectMake(priceX, y, 80.0f, 35.0f);
}


#pragma mark - UITableViewCell

- (void)prepareForReuse {
    [super prepareForReuse];
}


#pragma mark - Public
+ (CGFloat)rowHeight{
    return ROW_HEIGHT;
}
- (void)configureProduct:(Product *)product {
    UIImage *backgroundImage = [UIImage imageNamed:@"Product.png"];
    UIEdgeInsets backgroundInsets = UIEdgeInsetsMake(backgroundImage.size.height/2.0f, backgroundImage.size.width/2.0f, backgroundImage.size.height/2.0f, backgroundImage.size.width/2.0f);
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:[backgroundImage resizableImageWithCapInsets:backgroundInsets]];
    self.backgroundView = backgroundImageView;

    self.previewImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.previewImageView.image = [UIImage imageWithData:product.imageData];
    self.priceLabel.text = [NSString stringWithFormat:@"%d.%d %@", product.amount/100,  product.amount%100, product.currency];

    self.textLabel.text = product.name;
    self.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:18.0f];
    self.textLabel.textColor = [UIColor colorWithRed:82.0f/255.0f green:87.0f/255.0f blue:90.0f/255.0f alpha:1.0f];
    self.textLabel.shadowColor = [UIColor colorWithWhite:1.0f alpha:0.7f];
    self.textLabel.shadowOffset = CGSizeMake(0.0f, 0.5f);
    self.textLabel.backgroundColor = [UIColor clearColor];
}


@end
