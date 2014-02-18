
//
//  PMLAccessoryBadge.h
//  Honey on Sale
//
//  Created by Vladimir Marinov on 17.12.13.
//  Copyright (c) 2013 г. PAYMILL All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PMLAccessoryBadge : UIView
@property (weak, readonly) UILabel *textLabel;
@property (nonatomic, strong) UIColor *backgroundColor;
@property (nonatomic, strong) UIColor *strokeColor;
@property (nonatomic, assign) CGFloat strokeWidth;
@property (nonatomic, assign) CGFloat cornerRadius;
@property (nonatomic, strong) UIColor *highlightColor; //default is white
@property (nonatomic, assign) CGFloat highlightAlpha;
@property (nonatomic, assign) CGFloat shadowAlpha;
@property (nonatomic, assign) CGSize shadowOffset;
@property (nonatomic, assign) CGFloat gradientAlpha;
@property (nonatomic, assign) CGSize textLabelOffset;
@property (nonatomic, assign) CGSize textSizePadding;
@property (nonatomic, assign) CGSize badgeInnerPadding;
@property (nonatomic, assign) CGSize badgeContentInset;
@property (nonatomic, assign) CGSize badgeMinimumSize;

@property (nonatomic, strong) UIColor *chevronColor;
@property (nonatomic, assign, getter = isBadgeHidden) BOOL badgeHidden;
@property (nonatomic, assign) CGFloat chevronStrokeWidth;

- (void)setText:(NSString *)string;
- (void)setTextWithNumber:(NSNumber *)number;
- (void)setTextWithIntegerValue:(NSInteger)value;
- (void)setTextColor:(UIColor *)color;
@end

@interface PMLAccessoryBadgeArrow : PMLAccessoryBadge
@end

@interface PMLAccessoryBadgeChevron : PMLAccessoryBadge
//If this is nil, the background color of the badge is used by default.
@end

@interface PMLAccessoryBadgeEmboss : PMLAccessoryBadge
@end


