//
//  PMLProductTableViewCell.h
//  Honey on Sale
//
//  Created by Vladimir Marinov on 17.12.13.
//  Copyright (c) 2013 г. PAYMILL All rights reserved.
//

@class PMLProduct;

@interface PMLProductTableViewCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UIButton *orderButton;
@property (nonatomic, strong) IBOutlet UILabel *priceLabel;
@property (nonatomic, strong) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UIImageView *previewImageView;

- (void)configureProduct:(PMLProduct *)product;
+ (CGFloat)rowHeight;
@end
