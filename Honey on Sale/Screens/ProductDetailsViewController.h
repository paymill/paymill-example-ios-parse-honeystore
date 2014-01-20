//
//  DetailViewController.h
//  Honey on Sale
//
//  Created by Vladimir Marinov on 17.12.13.
//  Copyright (c) 2013 г. Vladimir Marinov. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Product;
@interface ProductDetailsViewController : UIViewController <UISplitViewControllerDelegate>

- (void)setSelectedProduct:(Product*)product;


@end
