#import "../Headers.h"

@implementation NocturneController
{
	NSMutableDictionary *storedCalls;
}

+ (NSAttributedString *)_replaceColorForAttributedString:(NSAttributedString *)oldString withColor:(UIColor *)color
{
	NSDictionary *attributesFromString = [oldString attributesAtIndex:0 longestEffectiveRange:nil inRange:NSMakeRange(0, oldString.length)];
	NSMutableDictionary *newAttributes = [attributesFromString mutableCopy];
	[newAttributes setObject:color forKey:@"NSColor"];
	NSAttributedString *newString = [[NSAttributedString alloc] initWithString:oldString.string attributes:newAttributes];
	return newString;
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

- (BOOL)classExists:(id)delegateClass
{
	if([storedCalls objectForKey:delegateClass])
		return TRUE;
	else
		return FALSE;
}

- (void *)getPointerAtIndex:(int)index forDelegate:(id)delegateClass
{
	NSPointerArray *pointerList = [storedCalls objectForKey:delegateClass];
	if(pointerList){
		return [pointerList pointerAtIndex:index];
	}
	return nil;
}

- (void)addPointerList:(NSPointerArray *)pointerList forDelegate:(id)delegateClass
{
	[storedCalls setObject:pointerList forKey:delegateClass];
}

- (id)init
{
	storedCalls = [[NSMutableDictionary alloc] init];
	return [super init];
}

@end