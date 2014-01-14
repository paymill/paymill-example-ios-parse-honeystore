//
//  MasterViewController.h
//  Honey on Sale
//
//  Created by Vladimir Marinov on 17.12.13.
//  Copyright (c) 2013 г. Vladimir Marinov. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailViewController;

@interface StoreViewController : UITableViewController

@property(strong,nonatomic) DetailViewController *detailViewController;
@property(strong,nonatomic) IBOutlet UITableView *productsTable;

@end
