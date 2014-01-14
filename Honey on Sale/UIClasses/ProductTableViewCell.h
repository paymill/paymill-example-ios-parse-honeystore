//
//  ProductTableViewCell.h
//  Honey on Sale
//
//  Created by Vladimir Marinov on 17.12.13.
//  Copyright (c) 2013 г. Vladimir Marinov. All rights reserved.
//

@class Product;

@interface ProductTableViewCell : UITableViewCell

@property (nonatomic, strong) UIButton *orderButton;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, retain) UIImageView *previewImageView;

- (void)configureProduct:(Product *)product;
+ (CGFloat)rowHeight;
@end
