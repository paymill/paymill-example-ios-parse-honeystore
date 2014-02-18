//
//  PMLProductTableViewCell.h
//  Honey on Sale
//
//  Created by Vladimir Marinov on 17.12.13.
//  Copyright (c) 2013 г. PAYMILL All rights reserved.
//

@class PMLProduct;

@interface PMLProductTableViewCell : UITableViewCell

@property (nonatomic, strong) UIButton *orderButton;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, retain) UIImageView *previewImageView;

- (void)configureProduct:(PMLProduct *)product;
+ (CGFloat)rowHeight;
@end
