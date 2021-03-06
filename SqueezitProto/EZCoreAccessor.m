//
//  EZCoreAccessor.m
//  SqueezitProto
//
//  Created by Apple on 12-5-31.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "EZCoreAccessor.h"
#import "Constants.h"

@interface EZCoreAccessor(private)

- (NSManagedObjectContext*) createContext:(NSPersistentStoreCoordinator*)coordinator;

- (NSManagedObjectModel*) createModel:(NSURL*)modelURL;

- (NSPersistentStoreCoordinator*) createCoordinator:(NSURL*)storeURL model:(NSManagedObjectModel*)model;

@end

static EZCoreAccessor* accessor = nil;

@implementation EZCoreAccessor
@synthesize model, context, coordinator;

+ (EZCoreAccessor*) getInstance
{
    if(accessor == nil){
        accessor = [[EZCoreAccessor alloc] initWithDBName:CoreDBName modelName:CoreModelName];
    }
    return accessor; 
}

//The purpose of this method, is to provide way to use other instance.
//For example, the test database and the production database are different one.
//I can instantiate a different database for it. 
//Easy and straightforward
+ (void) setInstance:(EZCoreAccessor*)inst
{
    accessor = inst;
}

+ (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (id) initWithDBName:(NSString*)dbName modelName:(NSString*)modelName
{
    self = [super init];
    NSURL* modelURL = [[NSBundle mainBundle] URLForResource:modelName withExtension:@"momd"];
    self.model = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    
    NSURL* dbURL = [[EZCoreAccessor applicationDocumentsDirectory] URLByAppendingPathComponent:dbName];
    self.coordinator = [self createCoordinator:dbURL model:self.model];
    self.context = [self createContext:coordinator];
    return self;
}

+ (void) cleanDefaultDB
{
    [EZCoreAccessor cleanDB:CoreDBName];
}

+ (void) cleanDB:(NSString*)fileName
{
    
    NSURL *storeURL = [[EZCoreAccessor applicationDocumentsDirectory] URLByAppendingPathComponent:fileName];
    [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil];
}

- (NSManagedObjectContext*) createContext:(NSPersistentStoreCoordinator*)coord
{
    NSManagedObjectContext* res = [[NSManagedObjectContext alloc] init];
    [res setPersistentStoreCoordinator:coord];
    return res;
}


- (NSPersistentStoreCoordinator*) createCoordinator:(NSURL*)storeURL model:(NSManagedObjectModel *)mod
{
    NSError* error = nil;
    NSPersistentStoreCoordinator* res = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:mod];
    if(![res addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]){
        EZDEBUG(@"Failed to initialize database, error:%@, userinfo:%@", error, error.userInfo);
        //TODO call cleanData() for possible fix
        abort();
    }
    return res;
}

- (void)saveContext
{
    NSError *error = nil;
    //NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if ([context hasChanges] && ![context save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            EZDEBUG(@"Unresolved error %@, userInfo:%@", error, [error userInfo]);
            abort();
    }
}

//All NSManagedObject should be instantiated from here
- (NSManagedObject*) create:(Class)classType
{
    NSString* className = [classType description];
    NSManagedObject* res = [NSEntityDescription insertNewObjectForEntityForName:className inManagedObjectContext:context];
    return res;
    
}

//po for persistent object
- (BOOL) store:(NSManagedObject*)po
{
    NSError* error = nil;
    BOOL res = false;
    res = [po.managedObjectContext save:&error];
    if(!res){
        EZDEBUG(@"Error at save, error:%@, userinfo:%@",error, error.userInfo);
    }
    return res;
}

//Will remove it from storage
- (BOOL) remove:(NSManagedObject*)po
{
    [po.managedObjectContext deleteObject:po];
    return true;
}

//If passing nil, System will use "name" to sort the result.
- (NSArray*) fetchAll:(Class)classType sortField:(NSString*)fieldName
{
    EZDEBUG(@"Fetch %@, sortField:%@",classType, fieldName);
    return [self fetchObject:classType byPredicate:nil withSortField:fieldName];
}

//Fetch object by the specified predication
- (NSArray*) fetchObject:(Class)classType byPredicate:(NSPredicate*)predicate withSortField:(NSString *)sortField
{
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    NSEntityDescription* entity = [NSEntityDescription entityForName:[classType description] inManagedObjectContext:context];
    [request setEntity:entity];
    [request setPredicate:predicate];
    if(sortField){
        NSSortDescriptor* sortDescriptor = [[NSSortDescriptor alloc] initWithKey:sortField ascending:YES];
        NSArray* descriptors = [NSArray arrayWithObject:sortDescriptor];
        [request setSortDescriptors:descriptors];

    }
    NSError* error = nil;
    NSArray* res = [context executeFetchRequest:request error:&error];
    if(error){
        EZDEBUG(@"Error fetch object %@, predicate:%@", classType, predicate);
    }
    return res;
}

@end
