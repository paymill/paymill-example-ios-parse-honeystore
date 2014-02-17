//
//  PMLProductTableViewCell.h
//  Honey Store
//
//  Created by Vladimir Marinov on 17.12.13.
//  Copyright (c) 2013 г. PAYMILL. All rights reserved.
//

@class PMLProduct;

@interface PMLProductTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIButton *orderButton;
@property (nonatomic, weak) IBOutlet UILabel *priceLabel;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UIImageView *previewImageView;

- (void)configureProduct:(PMLProduct *)product;
+ (CGFloat)rowHeight;
@end
