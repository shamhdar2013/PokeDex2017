 //
//  RSDataProviderAPI.m
//  RSPokedex
//
//  Created by RADHIKA SHARMA on 9/6/17.
//  Copyright © 2017 RADHIKA SHARMA. All rights reserved.
//

#import "RSDataProviderAPI.h"
#import "RSPokemon.h"

NSString *const kPokeAPIBaseUrl = @"https://pokeapi.co/api/v2";

@implementation RSDataProviderAPI

+(NSDictionary *)getPokemonsWithCompletionBlock:(ResultsBlock)block
{
    __block NSDictionary *result = nil;
    NSURLSession  *session = [NSURLSession sharedSession];
    NSString *url = [NSString stringWithFormat:@"%@/%@/", kPokeAPIBaseUrl, @"pokemon"];
     
    
   /* NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/", kPokeAPIBaseUrl, @"pokemon"]]];
    [request setHTTPMethod:@"GET"];*/
    


 [[session dataTaskWithURL:[NSURL URLWithString:url] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
        
     //NSLog(@"******** Process Response **************");
     NSError *jsonError;
     NSDictionary *pokemons = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
     NSArray *parr = [pokemons objectForKey:@"results"];
     result = [RSDataProviderAPI extractPokemonList:parr];
     
     if(result){
         block(result, parr.count, nil);
     }
     
 }] resume];;
    
    return result;
    
}

+(UIImage *)getSpriteForPoke:(NSString *)name
{
    return nil;
}

+(NSDictionary *)extractPokemonList:(NSArray *)pokeArr{
    NSMutableDictionary  *pmap = [NSMutableDictionary dictionaryWithCapacity:pokeArr.count];
    for(int i = 0; i < pokeArr.count; i++){
        NSDictionary *poked = (NSDictionary *)[pokeArr objectAtIndex:i];
        RSPokemon *pkmn = [[RSPokemon alloc] init];
        pkmn.name = [poked objectForKey:@"name"];
        pkmn.detailURL = [NSURL URLWithString:(NSString *)[poked objectForKey:@"url"] ];
        pkmn.type = @"Flying";
        pkmn.height = @11;
        pkmn.weight = @320;
        pkmn.id = @1;
        pkmn.thumbnailURL = [NSURL URLWithString:@"https://madeup.com"];
        
        [pmap setObject:pkmn forKey:pkmn.name];
    }
    return pmap;
    
}

+(void)getPokemonDetailsFrom:(NSURL *)url forPokemon:(NSString *)name withCompletionBlock:(DetailsBlock)callbackBlock
{
    NSURLSession  *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
        
        NSError *jsonError;
        NSDictionary *pokeDetails = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
        NSMutableDictionary *result = [NSMutableDictionary dictionaryWithCapacity:6];
        [result setValue:[pokeDetails valueForKey:@"height"] forKey:@"height"];
        [result setValue:[pokeDetails valueForKey:@"weight"] forKey:@"weight"];
        [result setValue:[pokeDetails valueForKey:@"id"] forKey:@"id"];
        NSArray *types = [pokeDetails valueForKey:@"types"];
        NSMutableString *typeStr = [NSMutableString stringWithCapacity:10];
        int tcnt = 0;
        for(NSDictionary *type in types){
            if(tcnt == (types.count-1)){
                [typeStr appendString:[NSString stringWithFormat:@"%@  ",[type valueForKeyPath:@"type.name"]]];
            } else {
                [typeStr appendString:[NSString stringWithFormat:@"%@,  ",[type valueForKeyPath:@"type.name"]]];
            }
            tcnt ++;
        }
        [result setValue:typeStr forKey:@"types"];
        [result setValue:[pokeDetails valueForKeyPath:@"sprites.front_default"] forKey:@"thumbnailUrl"];
        if(callbackBlock){
            callbackBlock(result, name, error);
        }
    }] resume];
    
}

+(void)getPokemonImageFrom:(NSURL *)url forPokemon:(NSString *)name withCompletionBlock:(ImageBlock)block{
    
    NSURLSession  *session = [NSURLSession sharedSession];
    
    [[session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
        
        UIImage *img = [UIImage imageWithData:data];
        if(block){
            block(img,name,error);
        }
    }] resume];
    
}

+(void)getHabitatForPoke:(NSInteger)pid forName:(NSString *)name withCompletionBlock:(HabitatBlock)block
{
    NSURLSession  *session = [NSURLSession sharedSession];
     NSString *url = [NSString stringWithFormat:@"%@/%@/%ld", kPokeAPIBaseUrl, @"pokemon-habitat", pid];
    [[session dataTaskWithURL:[NSURL URLWithString:url] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
        
        NSError *jsonError;
        NSDictionary *habitat = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
        NSString *habitatStr = [habitat valueForKey:@"name"];
        
        if(block){
            block(habitatStr,name,error);
        }
    }] resume];
}

@end
