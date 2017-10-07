//
//  ViewController.m
//  RSPokedex
//
//  Created by RADHIKA SHARMA on 9/5/17.
//  Copyright © 2017 RADHIKA SHARMA. All rights reserved.
//

#import "ViewController.h"
#import "RSPokeTableViewCell.h"
#import "RSDataProviderAPI.h"
#import "RSPokemon.h"
#import "RSPokeSearchResultsViewController.h"

@interface ViewController ()<RSSearchResultsDelegate>

@property (nonatomic, strong) NSMutableDictionary *pokemons;
@property (assign) NSInteger pokeCount;



@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleLbl.text = NSLocalizedStringWithDefaultValue(@"table_title", @"Localizable", [NSBundle mainBundle], @"Pokedex", @"Pokedex table title");
    self.pokeCount = 0;
    
    UINib *cellNib = [UINib nibWithNibName:@"RSPokeTableViewCell" bundle:nil];
    [self.pokeTable registerNib:cellNib forCellReuseIdentifier:@"poke"];
    // Do any additional setup after loading the view, typically from a nib.
    
    __weak typeof(self) weakSelf = self;
    [RSDataProviderAPI getPokemonsWithCompletionBlock:^(NSDictionary *dict, NSInteger pcount, NSError *err){
        
        if(err == nil) {
            weakSelf.pokemons = [NSMutableDictionary dictionaryWithDictionary:dict];
            weakSelf.pokeCount = pcount;
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.pokeTable reloadData];
            });
            
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                
                [weakSelf getPokemonDetails];
                
            });
        }
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getPokemonDetails{
    
    NSArray *keys = [self.pokemons allKeys];
    for(NSString *key in keys){
       __block RSPokemon *pkmn = [self.pokemons objectForKey:key];
        __weak typeof(self) weakSelf = self;
        NSInteger idx = [keys indexOfObject:key];
        [RSDataProviderAPI getPokemonDetailsFrom:pkmn.detailURL forPokemon:pkmn.name withCompletionBlock:^(NSDictionary *dict, NSString* name, NSError *err){
            if(err == nil){
                NSLog(@"Details received for poke = %@", name);
                pkmn.height = [dict valueForKey:@"height"];
                pkmn.weight = [dict valueForKey:@"weight"];
                pkmn.id = [dict valueForKey:@"id"];
                NSString *typeStr = [dict valueForKey:@"types"];
                pkmn.type = typeStr;
                pkmn.thumbnailURL  = [NSURL URLWithString:[dict valueForKeyPath:@"thumbnailUrl"]];
                if(pkmn.thumbnailURL){
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                        
                        [weakSelf getPokemonSpriteFrom:pkmn.thumbnailURL forName:name];
                        
                    });

                }
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                    
                    [weakSelf getPokemonHabitat:name];
                    
                });
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSIndexPath *idxp = [NSIndexPath indexPathForRow:idx
                                                           inSection:0];
                    [weakSelf.pokeTable reloadRowsAtIndexPaths:[NSArray arrayWithObjects:idxp, nil] withRowAnimation:UITableViewRowAnimationFade];
                });
            }
            
        }];
    }
}
-(void)getPokemonSpriteFrom:(NSURL *)imgURL forName:(NSString *)name{
    __weak typeof(self) weakSelf = self;
    [RSDataProviderAPI  getPokemonImageFrom:imgURL forPokemon:name withCompletionBlock:^(UIImage *img, NSString *name, NSError *err){
        if(img){
            RSPokemon *pkmn = [weakSelf.pokemons objectForKey:name];
            pkmn.thumbnailImg = img;
            NSArray *keys = [self.pokemons allKeys];
            NSInteger idx = [keys indexOfObject:name];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                NSIndexPath *idxp = [NSIndexPath indexPathForRow:idx
                                                       inSection:0];
                [weakSelf.pokeTable reloadRowsAtIndexPaths:[NSArray arrayWithObjects:idxp, nil] withRowAnimation:UITableViewRowAnimationFade];
            });

            
        }
        
     }];
}

-(void)getPokemonHabitat:(NSString *)name{
    __weak typeof(self) weakSelf = self;
     RSPokemon *pkmn = [weakSelf.pokemons objectForKey:name];
    [RSDataProviderAPI getHabitatForPoke:[pkmn.id integerValue] forName:name withCompletionBlock:^(NSString *habitat, NSString *name, NSError *error) {
        if(habitat){
            
            RSPokemon *pkmn = [weakSelf.pokemons objectForKey:name];
            pkmn.habitat = habitat;
            NSArray *keys = [self.pokemons allKeys];
            NSInteger idx = [keys indexOfObject:name];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                NSIndexPath *idxp = [NSIndexPath indexPathForRow:idx
                                                       inSection:0];
                [weakSelf.pokeTable reloadRowsAtIndexPaths:[NSArray arrayWithObjects:idxp, nil] withRowAnimation:UITableViewRowAnimationFade];
            });

            
        }
        
    }];
}



- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    
    
    if(item.tag == 0){
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        RSPokeSearchResultsViewController *searchViewCntl = [storyBoard instantiateViewControllerWithIdentifier:@"SearchViewController"];
        searchViewCntl.delegate = self;
        
        [self.navigationController  pushViewController:searchViewCntl animated:YES];
        
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section{

    if(self.pokemons){
        return [[self.pokemons allKeys] count];
    }
    return (self.pokeCount + 1);
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RSPokeTableViewCell *pokeCell = (RSPokeTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"poke"];
    if(pokeCell == nil){
       NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"RSPokeTableViewCell" owner:self options:nil];
        pokeCell = [nib objectAtIndex:0];
    }
    
    
    
    if(self.pokemons ){
         NSArray *keys = [self.pokemons allKeys];
        if(indexPath.row < keys.count) {
         NSString *key = [keys objectAtIndex:indexPath.row];
         RSPokemon *pkmn = [self.pokemons objectForKey:key];
            if(pkmn) {
                pokeCell.nameVal.text = pkmn.name;
                pokeCell.idVal.text = [pkmn.id stringValue];
                pokeCell.heightVal.text = [pkmn.height stringValue];
                pokeCell.weightVal.text = [pkmn.weight stringValue];
                pokeCell.typeVal.text = pkmn.type;
                if(pkmn.thumbnailImg){
                    pokeCell.spriteImg.image = pkmn.thumbnailImg;
                }
                if(pkmn.habitat){
                    pokeCell.habitatVal.text = pkmn.habitat;
                }
            }
            
         
        }

    }
    return pokeCell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 160.00;
}

#pragma mark - RSSearchResultsDelegate
-(NSArray *)searchPokemon:(NSString *)searchStr{
    
    NSDictionary *searchList;
    @synchronized(self){
        
       NSData *buffer = [NSKeyedArchiver archivedDataWithRootObject: self.pokemons];
        searchList =  [NSKeyedUnarchiver unarchiveObjectWithData: buffer];
        /*searchList = [NSKeyedUnarchiver unarchiveObjectWithData:
                      [NSKeyedArchiver archivedDataWithRootObject:self.pokemons]];*/
        
    }
    
    NSArray *keys = [searchList allKeys];
    if(!searchList || (keys.count == 0)){
        return nil;
    }
    
    
    
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:keys.count];
    
    for(NSString *key  in keys)
    {
        RSPokemon *pkmn = [searchList objectForKey:key];
        if(([pkmn.name caseInsensitiveCompare:searchStr] == NSOrderedSame) || ([pkmn.type containsString:[searchStr lowercaseString]]) || ([[pkmn.id stringValue] caseInsensitiveCompare:searchStr] == NSOrderedSame) ){
            [result addObject:pkmn];
        }
    }

    return result;
    
    
}
@end
