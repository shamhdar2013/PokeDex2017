//
//  RSPokemon.h
//  RSPokedex
//
//  Created by RADHIKA SHARMA on 9/6/17.
//  Copyright © 2017 RADHIKA SHARMA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
extern NSString *const ASCPokemonName;
extern NSString *const ASCPokemonId;
extern NSString *const ASCPokemonHeight;
extern NSString *const ASCPokemonWeight;
extern NSString *const ASCPokemonType;
//extern NSString *const ASCPokemonHabitat;
extern NSString *const ASCPokemonThumbnail;

@interface RSPokemon : NSObject<NSCoding>

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSNumber *id;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSNumber *height;
@property (nonatomic, strong) NSNumber *weight;
@property (nonatomic, strong) NSString *habitat;
@property (nonatomic, strong) NSURL *thumbnailURL;
@property (nonatomic, strong) UIImage *thumbnailImg;
@property (nonatomic, strong) NSURL *detailURL;
@end
