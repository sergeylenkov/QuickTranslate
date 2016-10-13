//
//  QuickTranslateAppDelegate.h
//  QuickTranslate
//
//  Created by Sergey Lenkov on 09.09.10.
//  Copyright 2010 Positive Team. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "JSON.h"
#import "PrefsController.h"
#import "NSString+HTML.h"
#import "SGHotKey.h"
#import "SGHotKeyCenter.h"
#import "ASIHTTPRequest.h"
#import "RegexKitLite.h"

@interface QuickTranslateAppDelegate : NSObject <NSApplicationDelegate, PrefsControllerDelegate> {
    IBOutlet NSWindow *window;
    IBOutlet NSTextView *textView;
    IBOutlet NSProgressIndicator *progressIndicator;
    IBOutlet NSMenu *statusItemMenu;
    IBOutlet NSButton *toggleButton;
    IBOutlet NSPopUpButton *fromLanguagesButton;
    IBOutlet NSPopUpButton *toLanguagesButton;
    NSStatusItem *statusItem;
    NSUserDefaults *defaults;
    PrefsController *preferencesController;
    SGHotKey *hotKey;
    NSString *sourceText;
    NSString *translatedText;
    NSString *bingAppId;
    NSDate *lastBingTranslate;
}

@property (assign) NSWindow *window;
@property (nonatomic, copy) NSString *translatedText;

- (void)googleTranslate;
- (void)bingTranslate;
- (void)bingTranslateRequest;
- (void)centerAtMousePosition;
- (void)layoutButtons;
- (void)reloadLanguages;
- (void)startAnimation;
- (void)stopAnimation;

- (IBAction)translate:(id)sender;
- (IBAction)openWindow:(id)sender;
- (IBAction)openPreferences:(id)sender;
- (IBAction)toggleLanguage:(id)sender;
- (IBAction)toggleText:(id)sender;
- (IBAction)fromLanguagesDidChange:(id)sender;
- (IBAction)toLanguagesDidChange:(id)sender;

@end
