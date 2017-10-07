//
//  RSDataProviderAPI.h
//  RSPokedex
//
//  Created by RADHIKA SHARMA on 9/6/17.
//  Copyright © 2017 RADHIKA SHARMA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef void (^ResultsBlock)(NSDictionary *dict, NSInteger pcount, NSError *err);
typedef void (^DetailsBlock)(NSDictionary *dict, NSString *pname, NSError *err);
typedef void (^ImageBlock)(UIImage *img, NSString *pname, NSError *err);
typedef void (^HabitatBlock)(NSString *habitat, NSString *pname, NSError *err);
extern NSString *const kPokeAPIBaseUrl;


@interface RSDataProviderAPI : NSObject
+(NSDictionary *)getPokemonsWithCompletionBlock:(ResultsBlock)block;
+(UIImage *)getSpriteForPoke:(NSString *)name;
+(NSDictionary *)extractPokemonList:(NSArray *)pokeArr;
+(void)getPokemonDetailsFrom:(NSURL *)url forPokemon:(NSString *)name withCompletionBlock:(DetailsBlock)callbackBlock;
+(void)getPokemonImageFrom:(NSURL *)url forPokemon:(NSString *)name withCompletionBlock:(ImageBlock)block;
+(void)getHabitatForPoke:(NSInteger)pid forName:(NSString *)name withCompletionBlock:(HabitatBlock)block;

@end
