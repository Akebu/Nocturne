#import "../Headers.h"

@implementation NocturneController
{
	NSMutableArray *pointerList;
}

+ (id)sharedInstance
 {
    static NocturneController *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[NocturneController alloc] init];
    });
    return sharedInstance;
}

- (NSMutableArray *)getPointerList
{
	return pointerList;
}

- (BOOL)pointerExistForItem:(id)item
{
	BOOL hasPointer = NO;
	HBLogInfo(@"POINTER : %p", item);
	for(int i = 0; i < [pointerList count]; i++){
		if([pointerList[i] objectAtIndex:0] == item){
			hasPointer = YES;
			break;
		}
	}
	return hasPointer;
}

- (void)addOriginalCalls:(NSMutableArray *)array
{
	if([pointerList count] == 0)
		[pointerList addObject:array];
	else
	{
		if(![self pointerExistForItem:[array objectAtIndex:0]])
			[pointerList addObject:array];
	}
}

- (id)init
{
	pointerList = [[NSMutableArray alloc] init];
	return [super init];
}

-(void)dealloc
{
	[pointerList release];
	[super dealloc];
}

@end