//
//  ViewController.h
//  RSPokedex
//
//  Created by RADHIKA SHARMA on 9/5/17.
//  Copyright © 2017 RADHIKA SHARMA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITabBarDelegate>


@property (nonatomic, weak) IBOutlet UITableView *pokeTable;
@property (nonatomic, weak) IBOutlet UITabBarItem *searchButton;
@property (nonatomic, weak) IBOutlet UILabel *titleLbl;



@end

