//
//  DetailViewController.h
//  Honey on Sale
//
//  Created by Lubomir Velkov on 17.12.13.
//  Copyright (c) 2013 г. Vladimir Marinov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController <UISplitViewControllerDelegate>

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
