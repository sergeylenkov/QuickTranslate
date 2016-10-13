#import "Scripting.h"

@implementation SetTextCommand

- (id)performDefaultImplementation {
	[[NSNotificationCenter defaultCenter] postNotificationName:@"SetText" object:[self directParameter]];
	return nil;
}

@end

@implementation ShowWindowCommand

- (id)performDefaultImplementation {
	[[NSNotificationCenter defaultCenter] postNotificationName:@"ShowWindow" object:nil];
	return nil;
}

@end

@implementation TranslateCommand

- (id)performDefaultImplementation {
	[[NSNotificationCenter defaultCenter] postNotificationName:@"Translate" object:nil];
	return nil;
}

@end