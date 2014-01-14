//
//  DetailViewController.h
//  Honey on Sale
//
//  Created by Vladimir Marinov on 17.12.13.
//  Copyright (c) 2013 г. Vladimir Marinov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderViewController : UIViewController <UISplitViewControllerDelegate>

@property(strong,nonatomic) id detailItem;

@property(weak,nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
