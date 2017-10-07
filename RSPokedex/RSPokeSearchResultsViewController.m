//
//  RSPokeSearchResultsViewController.m
//  RSPokedex
//
//  Created by RADHIKA SHARMA on 9/9/17.
//  Copyright © 2017 RADHIKA SHARMA. All rights reserved.
//

#import "RSPokeSearchResultsViewController.h"
#import "RSPokemon.h"

@interface RSPokeSearchResultsViewController ()

@property (nonatomic, strong) NSMutableArray *searchResults;

@end

@implementation RSPokeSearchResultsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.searhResultsTbl registerClass:[UITableViewCell class] forCellReuseIdentifier:@"searchCell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSString *searchTerm = searchBar.text;
    [self getSearchResults:searchTerm];
}

-(void)getSearchResults:(NSString*) searchTerm{
    
    self.searchResults = [NSMutableArray arrayWithArray:[self.delegate searchPokemon:searchTerm]];
    
    if(self.searchResults && (self.searchResults.count > 0)){
        [self.searhResultsTbl reloadData];
    } else {
        
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"No Results"
                                                                           message:@"No Pokemons found with name, type or id. Try again."
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action) {
                                                                  }];
            
            [alert addAction:defaultAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
   

}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
   
//}

#pragma mark - TableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return self.searchResults.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"searchCell"];
    
    if (self.searchResults.count && (indexPath.row < self.searchResults.count)){
        
            RSPokemon *pkmn = [self.searchResults objectAtIndex:indexPath.row];
            if(pkmn.thumbnailImg){
                cell.imageView.image = pkmn.thumbnailImg;
            }
            if(pkmn.type){
                cell.detailTextLabel.text = pkmn.type;
            }
            if(pkmn.name){
                cell.textLabel.text = pkmn.name;
            }
        
    }
    
    return cell;
    
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.00;
}



@end
