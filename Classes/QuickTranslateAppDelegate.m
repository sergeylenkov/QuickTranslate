//
//  QuickTranslateAppDelegate.m
//  QuickTranslate
//
//  Created by Sergey Lenkov on 09.09.10.
//  Copyright 2010 Positive Team. All rights reserved.
//

#import "QuickTranslateAppDelegate.h"

@implementation QuickTranslateAppDelegate

@synthesize window;
@synthesize translatedText;

- (void)dealloc {
    [[NSStatusBar systemStatusBar] removeStatusItem:statusItem];
    [preferencesController release];
    [super dealloc];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    preferencesController = [[PrefsController alloc] initWithDelegate:self];
    [preferencesController.window setCollectionBehavior:NSWindowCollectionBehaviorCanJoinAllSpaces];
    
	statusItem = [[[NSStatusBar systemStatusBar] statusItemWithLength:NSSquareStatusItemLength] retain];
    [statusItem setImage:[NSImage imageNamed:@"MenuIcon.png"]];
    [statusItem setAlternateImage:[NSImage imageNamed:@"MenuIconHighlighted.png"]];
    [statusItem setMenu:statusItemMenu];
    [statusItem setHighlightMode:YES];
    
    [window setAutorecalculatesContentBorderThickness:YES forEdge:NSMinYEdge];
	[window setContentBorderThickness:35 forEdge:NSMinYEdge];
    
    if (![window setFrameUsingName:@"Main"]) {
		[window center];
	} 
    
    defaults = [NSUserDefaults standardUserDefaults];
    
    if ([defaults objectForKey:@"Font Name"] != nil && [defaults objectForKey:@"Font Size"] != nil) {
		textView.font = [NSFont fontWithName:[defaults objectForKey:@"Font Name"] size:[defaults floatForKey:@"Font Size"]];
	}       
    
    [window setCollectionBehavior:NSWindowCollectionBehaviorCanJoinAllSpaces];

    [NSApp activateIgnoringOtherApps:YES];    
    [NSApp setServicesProvider:self];
        
    sourceText = @"";
    translatedText = @"";
    bingAppId = @"";
 
    lastBingTranslate = [[NSDate date] retain];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setText:) name:@"SetText" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showWindow:) name:@"ShowWindow" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(translate:) name:@"Translate" object:nil];
    
    NSUpdateDynamicServices();
 
    [self reloadLanguages];
    [self layoutButtons];
}

#pragma mark -
#pragma mark Translation
#pragma mark -

- (void)googleTranslate {
    NSString *encodedText = [[textView string] stringByEscapingForURLArgument];
	NSString *from = [defaults objectForKey:@"Google From Language"];
	NSString *to = [defaults objectForKey:@"Google To Language"];
    
    NSString *query = [NSString stringWithFormat:@"http://translate.google.com/translate_a/t?client=t&text=%@&sl=%@&tl=%@&multires=1&otf=1&ssel=0&sc=1", encodedText, from, to];

	if ([[defaults objectForKey:@"Google Autodetect"] boolValue]) {
        query = [NSString stringWithFormat:@"http://translate.google.com/translate_a/t?client=t&text=%@&sl=auto&tl=%@&multires=0&otf=1&ssel=0&tsel=0&sc=1", encodedText, to];
	}
    
    __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:query]];
    [request addRequestHeader:@"User-Agent" value:@"Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_6_8; en-us) AppleWebKit/533.21.1 (KHTML, like Gecko) Version/5.0.5 Safari/533.21.1"];
    request.shouldRedirect = NO;
    request.timeOutSeconds = 60;
    
    [request setCompletionBlock:^{
        NSArray *jsonResult = [[request responseString] JSONValue];
        
        if (jsonResult) {
            NSString *translate = @"";

            if ([[jsonResult objectAtIndex:4] isKindOfClass:[NSArray class]]) {
                for (NSArray *items in [jsonResult objectAtIndex:4]) {
                    NSString *word = [items objectAtIndex:0];
                    NSInteger type = [[items objectAtIndex:2] intValue];
                    
                    if ([word length] > 0) {
                        if (type == 0) {
                            translate = [translate stringByAppendingFormat:@"%@", word];
                        } else {
                            translate = [translate stringByAppendingFormat:@" %@", word];
                        }
                    }
                }
            }
            
            translate = [translate stringByConvertingHTMLToPlainText];
            
            if ([translate length] > 0) {
                self.translatedText = translate;
                [textView setString:translatedText];
                
                if ([defaults boolForKey:@"Copy To Clipboard"]) {
                    NSPasteboard *pasteboard = [NSPasteboard generalPasteboard];
                    [pasteboard clearContents];
                    [pasteboard writeObjects:[NSArray arrayWithObject:translatedText]];
                }
            }
        }
        
        [self stopAnimation];
    }];
    
    [request setFailedBlock:^{
        [textView setString:[NSString stringWithFormat:@"%@", [request.error localizedDescription]]];
        [self stopAnimation];
    }];
    
    [request startAsynchronous];
}

- (void)bingTranslate {
    int hours = (int)([[NSDate date] timeIntervalSince1970] - [lastBingTranslate timeIntervalSince1970]) / 3600;
    
    if (hours >= 3) {
        bingAppId = @"";
        
        [lastBingTranslate release];
        lastBingTranslate = [[NSDate date] retain];
    }
    
    if ([bingAppId length] == 0) {
        NSString *query = @"http://www.microsofttranslator.com/ajax/v2/toolkit.ashx?loc=en&toolbar=none&ref=&160773";
        
        __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:query]];
        [request addRequestHeader:@"User-Agent" value:@"Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_6_8; en-us) AppleWebKit/533.21.1 (KHTML, like Gecko) Version/5.0.5 Safari/533.21.1"];
        request.shouldRedirect = NO;
        request.timeOutSeconds = 60;
        
        [request setCompletionBlock:^{
            bingAppId = [[request responseString] stringByMatching:@"appId:'(.*?)'" capture:1];
            bingAppId = [[bingAppId stringByReplacingOccurrencesOfString:@"\\x2a" withString:@"*"] copy];

            [self bingTranslateRequest];
        }];
        
        [request setFailedBlock:^{
            [self stopAnimation];
        }];

        [request startAsynchronous];
    } else {
        [self bingTranslateRequest];
    }
}

- (void)bingTranslateRequest {
    if ([bingAppId length] > 0) {
        NSString *encodedText = [[textView string] stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
        NSString *from = [defaults objectForKey:@"Bing From Language"];
        NSString *to = [defaults objectForKey:@"Bing To Language"];
        
        NSString *query = [NSString stringWithFormat:@"http://api.microsofttranslator.com/v2/ajax.svc/TranslateArray?appId=\"%@\"&texts=[\"%@\"]&from=\"%@\"&to=\"%@\"&oncomplete=_mstc1&onerror=_mste1&loc=en", bingAppId, encodedText, from, to];
        
        if ([[defaults objectForKey:@"Autodetect"] boolValue]) {
            query = [NSString stringWithFormat:@"http://api.microsofttranslator.com/v2/ajax.svc/TranslateArray?appId=\"%@\"&texts=[\"%@\"]&from=\"\"&to=\"%@\"&oncomplete=_mstc1&onerror=_mste1&loc=en", bingAppId, encodedText, to];
        }
        
        __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[query stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
        [request addRequestHeader:@"User-Agent" value:@"Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_6_8; en-us) AppleWebKit/533.21.1 (KHTML, like Gecko) Version/5.0.5 Safari/533.21.1"];
        request.shouldRedirect = NO;
        request.timeOutSeconds = 60;
        
        [request setCompletionBlock:^{
            NSString *temp = [[request responseString] stringByReplacingOccurrencesOfString:@"_mstc1([" withString:@""];
            temp = [temp stringByReplacingOccurrencesOfString:@"]);" withString:@""];

            NSDictionary *jsonResult = [temp JSONValue];
            
            if ([jsonResult objectForKey:@"TranslatedText"]) {
                NSString *translate = [[jsonResult objectForKey:@"TranslatedText"] stringByConvertingHTMLToPlainText];
                
                if ([translate length] > 0) {
                    self.translatedText = translate;
                    [textView setString:translatedText];
                    
                    if ([defaults boolForKey:@"Copy To Clipboard"]) {
                        NSPasteboard *pasteboard = [NSPasteboard generalPasteboard];
                        [pasteboard clearContents];
                        [pasteboard writeObjects:[NSArray arrayWithObject:translatedText]];
                    }
                }
            }
            
            [self stopAnimation];
        }];
        
        [request setFailedBlock:^{
            [textView setString:[NSString stringWithFormat:@"%@", [request.error localizedDescription]]];
            [self stopAnimation];
        }];

        [request startAsynchronous];
    }
}

#pragma mark -
#pragma mark Other
#pragma mark -

- (BOOL)application:(NSApplication *)sender delegateHandlesKey:(NSString *)key {
    if ([key isEqualToString:@"translatedText"]) {
		return YES; 
	}
	
    return NO; 
} 

- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender {
    [defaults setObject:[textView.font fontName] forKey:@"Font Name"];
    [defaults setFloat:[textView.font pointSize] forKey:@"Font Size"];
    
    [defaults synchronize];
    
	return NSTerminateNow;
}

- (void)showWindow:(NSNotification *)notification {
    [self openWindow:self];
}

- (void)startAnimation {
    [progressIndicator startAnimation:self];
}

- (void)stopAnimation {
    [progressIndicator stopAnimation:self];
}

- (void)centerAtMousePosition {
    if ([defaults boolForKey:@"Open At Cursor"]) {
        NSPoint mouse = [NSEvent mouseLocation];
        
        float x = mouse.x - (window.frame.size.width / 2);
        float y = mouse.y + (window.frame.size.height / 2);
        
        [window setFrameTopLeftPoint:NSMakePoint(x, y)];
    }
}

- (void)hotKeyPressed:(id)sender {
    [self centerAtMousePosition];
	[self openWindow:self];
}

- (void)setText:(NSNotification *)notification {
	[textView setString:[notification object]];
}

- (void)translateService:(NSPasteboard *)pboard userData:(NSString *)data error:(NSString **)error {	
	if ([[pboard types] containsObject:NSStringPboardType]) {
        [self centerAtMousePosition];
        
        [self openWindow:self];
        [textView setString:[pboard stringForType:NSStringPboardType]];
        [self translate:self];
	}
}

- (BOOL)textView:(NSTextView *)aTextView doCommandBySelector:(SEL)aSelector {
    if (aSelector == @selector(cancelOperation:)) {
        [window close];
    }
    
    return NO;
}

- (void)reloadLanguages {
    [fromLanguagesButton removeAllItems];
    [toLanguagesButton removeAllItems];
    
    [fromLanguagesButton addItemWithTitle:@"Auto"];
    [[fromLanguagesButton menu] addItem:[NSMenuItem separatorItem]];
    
    if ([defaults integerForKey:@"Service"] == 0) {    
        for (NSString *name in preferencesController.googleLanguageNames) {
            [fromLanguagesButton addItemWithTitle:name];
            [toLanguagesButton addItemWithTitle:name];
        }
    } else {
        for (NSString *name in preferencesController.bingLanguageNames) {
            [fromLanguagesButton addItemWithTitle:name];
            [toLanguagesButton addItemWithTitle:name];
        }
    }
}

- (void)layoutButtons {
    if ([defaults integerForKey:@"Service"] == 0) {
        NSString *fromKey = [defaults objectForKey:@"Google From Language"];
        NSString *toKey = [defaults objectForKey:@"Google To Language"];
        
        [fromLanguagesButton selectItemAtIndex:[preferencesController.googleLanguageCodes indexOfObject:fromKey] + 2];
        [toLanguagesButton selectItemAtIndex:[preferencesController.googleLanguageCodes indexOfObject:toKey]];
        
        if ([[defaults objectForKey:@"Google Autodetect"] boolValue]) {
            [fromLanguagesButton selectItemAtIndex:0];
            [toggleButton setEnabled:NO];
        } else {
            [toggleButton setEnabled:YES];
        }
    } else {
        NSString *fromKey = [defaults objectForKey:@"Bing From Language"];
        NSString *toKey = [defaults objectForKey:@"Bing To Language"];
        
        [fromLanguagesButton selectItemAtIndex:[preferencesController.bingLanguageCodes indexOfObject:fromKey] + 2];
        [toLanguagesButton selectItemAtIndex:[preferencesController.bingLanguageCodes indexOfObject:toKey]];
        
        if ([[defaults objectForKey:@"Bing Autodetect"] boolValue]) {
            [fromLanguagesButton selectItemAtIndex:0];
            [toggleButton setEnabled:NO];
        } else {
            [toggleButton setEnabled:YES];
        }
    }
    
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
	[paragraphStyle setAlignment:NSLeftTextAlignment];
	
	NSFont *font = fromLanguagesButton.font;
	
	NSDictionary *attsDict = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, [NSNumber numberWithInt:NSNoUnderlineStyle], NSUnderlineStyleAttributeName, paragraphStyle, NSParagraphStyleAttributeName, nil];
    
	NSSize size = [[fromLanguagesButton titleOfSelectedItem] sizeWithAttributes:attsDict];
    
    NSRect frame = fromLanguagesButton.frame;
    frame.size.width = size.width + 20;

    if (frame.size.width > 100) {
        frame.size.width = 100;
    }
    
    [fromLanguagesButton setFrame:frame];
    
    frame = toggleButton.frame;
    frame.origin.x = fromLanguagesButton.frame.origin.x + fromLanguagesButton.frame.size.width - 5;
    
    [toggleButton setFrame:frame];
    
    size = [[toLanguagesButton titleOfSelectedItem] sizeWithAttributes:attsDict];
    
    frame = toLanguagesButton.frame;
    frame.size.width = size.width + 20;
    frame.origin.x = toggleButton.frame.origin.x + toggleButton.frame.size.width - 5;
    
    if (frame.size.width > 100) {
        frame.size.width = 100;
    }
    
    [toLanguagesButton setFrame:frame];

    [paragraphStyle release];
}

- (void)settingsDidChange {
    [self reloadLanguages];
    [self layoutButtons];
}

#pragma mark -
#pragma mark IBAction
#pragma mark -

- (IBAction)translate:(id)sender {
    [self startAnimation];
    sourceText = [[textView string] copy];
    
    if ([defaults integerForKey:@"Service"] == 0) {
        [self googleTranslate];
    } else {
        [self bingTranslate];
    }
}

- (IBAction)openWindow:(id)sender {
    if ([defaults integerForKey:@"Opening Action"] == 1) {
        [textView setString:@""];
    } else if ([defaults integerForKey:@"Opening Action"] == 2) {
        [textView setString:[[NSPasteboard generalPasteboard] stringForType:NSPasteboardTypeString]];
    }
    
    [NSApp activateIgnoringOtherApps:YES];
    
    [window makeKeyAndOrderFront:self];    
    [window setOrderedIndex:0];
    [window makeFirstResponder:textView];
    
    [self layoutButtons];
}

- (IBAction)openPreferences:(id)sender {
    [NSApp activateIgnoringOtherApps:YES];
    
    [preferencesController showWindow:nil];
	[preferencesController.window center];
	
	[preferencesController refresh];
}

- (IBAction)toggleLanguage:(id)sender {
    if ([defaults integerForKey:@"Service"] == 0) {
        NSString *from = [defaults objectForKey:@"Google From Language"];
        NSString *to = [defaults objectForKey:@"Google To Language"];
        
        [defaults setObject:from forKey:@"Google To Language"];
        [defaults setObject:to forKey:@"Google From Language"];
    } else {
        NSString *from = [defaults objectForKey:@"Bing From Language"];
        NSString *to = [defaults objectForKey:@"Bing To Language"];
        
        [defaults setObject:from forKey:@"Bing To Language"];
        [defaults setObject:to forKey:@"Bing From Language"];
    }

    [self layoutButtons];
}

- (IBAction)toggleText:(id)sender {
    if ([[textView string] isEqualToString:sourceText]) {
        [textView setString:translatedText];
    } else {
        [textView setString:sourceText];
    }
}

- (IBAction)fromLanguagesDidChange:(id)sender {
    NSInteger index = fromLanguagesButton.indexOfSelectedItem;

    if (index == 0) {
        if ([defaults integerForKey:@"Service"] == 0) {
            [defaults setBool:YES forKey:@"Google Autodetect"];
        } else {
            [defaults setBool:YES forKey:@"Bing Autodetect"];
        }
    } else {
        if ([defaults integerForKey:@"Service"] == 0) {
            [defaults setBool:NO forKey:@"Google Autodetect"];
            [defaults setObject:[preferencesController.googleLanguageCodes objectAtIndex:index - 2] forKey:@"Google From Language"];
        } else {
            [defaults setBool:NO forKey:@"Bing Autodetect"];
            [defaults setObject:[preferencesController.bingLanguageCodes objectAtIndex:index - 2] forKey:@"Bing From Language"];
        }
    }

    [defaults synchronize];
    [self layoutButtons];
}

- (IBAction)toLanguagesDidChange:(id)sender {
    NSInteger index = toLanguagesButton.indexOfSelectedItem;
    
    if ([defaults integerForKey:@"Service"] == 0) {
        [defaults setObject:[preferencesController.googleLanguageCodes objectAtIndex:index] forKey:@"Google To Language"];
    } else {
        [defaults setObject:[preferencesController.bingLanguageCodes objectAtIndex:index] forKey:@"Google To Language"];
    }
    
    [defaults synchronize];
    
    [self layoutButtons];
}

@end
