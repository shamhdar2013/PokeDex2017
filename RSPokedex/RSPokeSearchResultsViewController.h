//
//  RSPokeSearchResultsViewController.h
//  RSPokedex
//
//  Created by RADHIKA SHARMA on 9/9/17.
//  Copyright © 2017 RADHIKA SHARMA. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol RSSearchResultsDelegate
-(NSArray *)searchPokemon:(NSString *)searchStr;
@end


@interface RSPokeSearchResultsViewController : UIViewController<UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak) IBOutlet UIButton *nameBtn;
@property (nonatomic, weak) IBOutlet UIButton *idBtn;
@property (nonatomic, weak) IBOutlet UIButton *typeBtn;
@property (nonatomic, weak) IBOutlet UISearchBar *searchBar;
@property (nonatomic, weak) IBOutlet UITableView *searhResultsTbl;
@property (weak) id<RSSearchResultsDelegate> delegate;


@end
