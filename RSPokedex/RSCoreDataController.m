//
//  RSCoreDataController.m
//  RSPokedex
//
//  Created by RADHIKA SHARMA on 9/8/17.
//  Copyright © 2017 RADHIKA SHARMA. All rights reserved.
//

#import "RSCoreDataController.h"
#import "RSPokemonEntity.h"

@interface RSCoreDataController ()
@property (strong, nonatomic, readwrite) NSPersistentContainer *persistentContainer;
@end

@implementation RSCoreDataController

@synthesize persistentContainer = _persistentContainer;

+(RSCoreDataController *)sharedController
{
    
    static id sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[RSCoreDataController alloc] init];
    });
    
    return sharedInstance;
}


- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"RSPokedex"];
            
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *basePath = [paths objectAtIndex:0];
            NSURL *dbURL = [NSURL URLWithString:[basePath stringByAppendingPathComponent:@"RSPokeDex.sqlite"]];
            NSPersistentStoreDescription   *descp = [NSPersistentStoreDescription  persistentStoreDescriptionWithURL:dbURL];
            
            descp.shouldInferMappingModelAutomatically = TRUE;
            descp.shouldMigrateStoreAutomatically = TRUE;
            _persistentContainer.persistentStoreDescriptions = @[descp];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                     */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                   // abort();
                }                 
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Add data to the store
-(void)addEntitiesToStore:(NSArray *)jsonArray
{
    if(jsonArray.count>0){
        
        
        NSManagedObjectContext *moc = self.persistentContainer.viewContext; //Primary context on the main queue
        
        NSManagedObjectContext *private = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        [private setParentContext:moc];
        __weak typeof(self) weakSelf = self;
        [private performBlock:^{
            int idx = 0;
            for (NSDictionary *jsonObject in jsonArray) {
                RSPokemonEntity *mo = [NSEntityDescription insertNewObjectForEntityForName:@"RSPokemonEntity" inManagedObjectContext:private];
                
                mo.name = [jsonObject objectForKey:@"name"];
                mo.detailUrl = (NSString *)[jsonObject objectForKey:@"url"];
                mo.type = @"Flying";
                mo.height = @11;
                mo.weight = @320;
                mo.id = [NSNumber numberWithInt:idx];
                mo.thumbnailUrl = @"https://madeup.com";
                
            }
            NSError *error = nil;
            if (![private save:&error]) {
                NSLog(@"Error saving context: %@\n%@", [error localizedDescription], [error userInfo]);
                //abort();
            }
            [moc performBlockAndWait:^{
                NSError *error = nil;
                if (![moc save:&error]) {
                    NSLog(@"Error saving context: %@\n%@", [error localizedDescription], [error userInfo]);
                    //abort();
                }
            }];
        }];
    }
}

-(RSPokemonEntity *)fetchEntityWithName:(NSString *)name withContext:(NSManagedObjectContext *)context
{
  __block RSPokemonEntity *resEntity;
    [context performBlockAndWait:^{
        NSError *error = nil;
        NSFetchRequest  *fetchReq = [[NSFetchRequest alloc] initWithEntityName:@"RSPokemonEntity"];
        NSPredicate *predicate = [NSPredicate
                                  predicateWithFormat:@"(lastName like[cd] %@)",
                                  name];
        
        NSArray <RSPokemonEntity *> *result = [context executeFetchRequest:fetchReq error:&error];
        if (error) {
            NSLog(@"Unresolved Error: %@", error);
        } else{
            resEntity = result[0];
        }

    }];
    return resEntity;
}

-(NSArray<RSPokemonEntity *> *)fetchAllEntitiesWithContext:(NSManagedObjectContext *)context{
    __block NSArray <RSPokemonEntity *> *result = nil;
    [context performBlockAndWait:^{
        NSError *error = nil;
        NSFetchRequest  *fetchReq = [[NSFetchRequest alloc] initWithEntityName:@"RSPokemonEntity"];
        NSSortDescriptor *nameSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
         fetchReq.sortDescriptors = @[nameSortDescriptor];
        
        result = [context executeFetchRequest:fetchReq error:&error];
        if (error) {
            NSLog(@"Unresolved Error: %@", error);
        }
    }];
    
    return result;
}

-(BOOL)updateEntityWithName:(NSString *)name withAttributes:(NSDictionary *)atribs{
    
    NSManagedObjectContext *moc = self.persistentContainer.viewContext; //Primary context on the main queue
    
    NSManagedObjectContext *private = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    [private setParentContext:moc];

    RSPokemonEntity *pokemon = [self fetchEntityWithName:(NSString *)name withContext:private];
    
    if(pokemon && atribs){
        NSArray *keys = [atribs allKeys];
        for(NSString *key in keys){
            
        }
    }
    
    return TRUE;
    
}


#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        //abort();
    }
}

@end
