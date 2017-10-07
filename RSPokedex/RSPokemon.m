//
//  RSPokemon.m
//  RSPokedex
//
//  Created by RADHIKA SHARMA on 9/6/17.
//  Copyright © 2017 RADHIKA SHARMA. All rights reserved.
//

#import "RSPokemon.h"

NSString *const ASCPokemonName = @"name";
NSString *const ASCPokemonId = @"id";
NSString *const ASCPokemonHeight = @"height";
NSString *const ASCPokemonWeight = @"weight";
NSString *const ASCPokemonType = @"type";
//NSString *const ASCPokemonHabitat = @"habitat";
NSString *const ASCPokemonThumbnail = @"thumbnaii";

@implementation RSPokemon

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.name forKey:ASCPokemonName];
    [coder encodeObject:self.id forKey:ASCPokemonId];
    [coder encodeObject:self.height forKey:ASCPokemonHeight];
    [coder encodeObject:self.weight forKey:ASCPokemonWeight];
    [coder encodeObject:self.type forKey:ASCPokemonType];
    [coder encodeObject:self.thumbnailImg forKey:ASCPokemonThumbnail];
}

- (id)initWithCoder:(NSCoder *)coder {
    self = [super init];
    if (self) {
        _name = [coder decodeObjectForKey:ASCPokemonName];
        _id = [coder decodeObjectForKey:ASCPokemonId];
        _height = [coder decodeObjectForKey:ASCPokemonHeight];
        _weight = [coder decodeObjectForKey:ASCPokemonWeight];
        _type = [coder  decodeObjectForKey:ASCPokemonType];
        _thumbnailImg = [coder decodeObjectForKey:ASCPokemonThumbnail];
    }
    return self;
}
@end
