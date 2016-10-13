#import "PrefsController.h"

#define TOOLBAR_GENERAL @"TOOLBAR_GENERAL"
#define TOOLBAR_ADVANCED @"TOOLBAR_ADVANCED"

@implementation PrefsController

@synthesize googleLanguageNames;
@synthesize googleLanguageCodes;
@synthesize bingLanguageNames;
@synthesize bingLanguageCodes;

- (id)initWithDelegate:(id)delegate {
    self = [super initWithWindowNibName:@"PrefsWindow"];
    
    if (self) {
        defaults = [NSUserDefaults standardUserDefaults];
		
        _delegate = delegate;
        
		googleLanguageNames = [[NSMutableArray alloc] init];
        googleLanguageCodes = [[NSMutableArray alloc] init];
        bingLanguageNames = [[NSMutableArray alloc] init];
        bingLanguageCodes = [[NSMutableArray alloc] init];
        
        [googleLanguageNames addObject:@"Afrikaans"];
        [googleLanguageNames addObject:@"Albanian"];
        [googleLanguageNames addObject:@"Arabic"];
        [googleLanguageNames addObject:@"Armenian"];
        [googleLanguageNames addObject:@"Azerbaijani"];
        [googleLanguageNames addObject:@"Basque"];
        [googleLanguageNames addObject:@"Belarusian"];
        [googleLanguageNames addObject:@"Bulgarian"];
        [googleLanguageNames addObject:@"Catalan"];
        [googleLanguageNames addObject:@"Chinese (Simplified)"];
        [googleLanguageNames addObject:@"Chinese (Traditional)"];
        [googleLanguageNames addObject:@"Croatian"];
        [googleLanguageNames addObject:@"Czech"];
        [googleLanguageNames addObject:@"Danish"];
        [googleLanguageNames addObject:@"Dutch"];
        [googleLanguageNames addObject:@"English"];
        [googleLanguageNames addObject:@"Esperanto"];
        [googleLanguageNames addObject:@"Estonian"];
        [googleLanguageNames addObject:@"Filipino"];
        [googleLanguageNames addObject:@"Finnish"];
        [googleLanguageNames addObject:@"French"];
        [googleLanguageNames addObject:@"Galician"];
        [googleLanguageNames addObject:@"Georgian"];
        [googleLanguageNames addObject:@"German"];
        [googleLanguageNames addObject:@"Greek"];
        [googleLanguageNames addObject:@"Haitian Creole"];
        [googleLanguageNames addObject:@"Hebrew"];
        [googleLanguageNames addObject:@"Hindi"];
        [googleLanguageNames addObject:@"Hungarian"];
        [googleLanguageNames addObject:@"Icelandic"];
        [googleLanguageNames addObject:@"Indonesian"];
        [googleLanguageNames addObject:@"Irish"];
        [googleLanguageNames addObject:@"Italian"];
        [googleLanguageNames addObject:@"Japanese"];
        [googleLanguageNames addObject:@"Korean"];
        [googleLanguageNames addObject:@"Latvian"];
        [googleLanguageNames addObject:@"Lithuanian"];
        [googleLanguageNames addObject:@"Macedonian"];
        [googleLanguageNames addObject:@"Malay"];
        [googleLanguageNames addObject:@"Maltese"];
        [googleLanguageNames addObject:@"Norwegian"];
        [googleLanguageNames addObject:@"Persian"];
        [googleLanguageNames addObject:@"Polish"];
        [googleLanguageNames addObject:@"Portuguese"];
        [googleLanguageNames addObject:@"Romanian"];
        [googleLanguageNames addObject:@"Russian"];
        [googleLanguageNames addObject:@"Serbian"];
        [googleLanguageNames addObject:@"Slovak"];
        [googleLanguageNames addObject:@"Slovenian"];
        [googleLanguageNames addObject:@"Spanish"];
        [googleLanguageNames addObject:@"Swahili"];
        [googleLanguageNames addObject:@"Swedish"];
        [googleLanguageNames addObject:@"Thai"];
        [googleLanguageNames addObject:@"Turkish"];
        [googleLanguageNames addObject:@"Ukrainian"];
        [googleLanguageNames addObject:@"Urdu"];
        [googleLanguageNames addObject:@"Vietnamese"];
        [googleLanguageNames addObject:@"Welsh"];
        [googleLanguageNames addObject:@"Yiddish"];
        
        [googleLanguageCodes addObject:@"af"];
        [googleLanguageCodes addObject:@"sq"];
        [googleLanguageCodes addObject:@"ar"];
        [googleLanguageCodes addObject:@"hy"];
        [googleLanguageCodes addObject:@"az"];
        [googleLanguageCodes addObject:@"eu"];
        [googleLanguageCodes addObject:@"be"];
        [googleLanguageCodes addObject:@"bg"];
        [googleLanguageCodes addObject:@"ca"];
        [googleLanguageCodes addObject:@"zh-CN"];
        [googleLanguageCodes addObject:@"zh-TW"];
        [googleLanguageCodes addObject:@"hr"];
        [googleLanguageCodes addObject:@"cs"];
        [googleLanguageCodes addObject:@"da"];
        [googleLanguageCodes addObject:@"nl"];
        [googleLanguageCodes addObject:@"en"];
        [googleLanguageCodes addObject:@"eo"];
        [googleLanguageCodes addObject:@"et"];
        [googleLanguageCodes addObject:@"tl"];
        [googleLanguageCodes addObject:@"fi"];
        [googleLanguageCodes addObject:@"fr"];
        [googleLanguageCodes addObject:@"gl"];
        [googleLanguageCodes addObject:@"ka"];
        [googleLanguageCodes addObject:@"de"];
        [googleLanguageCodes addObject:@"el"];
        [googleLanguageCodes addObject:@"ht"];
        [googleLanguageCodes addObject:@"iw"];
        [googleLanguageCodes addObject:@"hi"];
        [googleLanguageCodes addObject:@"hu"];
        [googleLanguageCodes addObject:@"is"];
        [googleLanguageCodes addObject:@"id"];
        [googleLanguageCodes addObject:@"ga"];
        [googleLanguageCodes addObject:@"it"];
        [googleLanguageCodes addObject:@"ja"];
        [googleLanguageCodes addObject:@"ko"];
        [googleLanguageCodes addObject:@"lv"];
        [googleLanguageCodes addObject:@"lt"];
        [googleLanguageCodes addObject:@"mk"];
        [googleLanguageCodes addObject:@"ms"];
        [googleLanguageCodes addObject:@"mt"];
        [googleLanguageCodes addObject:@"no"];
        [googleLanguageCodes addObject:@"fa"];
        [googleLanguageCodes addObject:@"pl"];
        [googleLanguageCodes addObject:@"pt"];
        [googleLanguageCodes addObject:@"ro"];
        [googleLanguageCodes addObject:@"ru"];
        [googleLanguageCodes addObject:@"sr"];
        [googleLanguageCodes addObject:@"sk"];
        [googleLanguageCodes addObject:@"sl"];
        [googleLanguageCodes addObject:@"es"];
        [googleLanguageCodes addObject:@"sw"];
        [googleLanguageCodes addObject:@"sv"];
        [googleLanguageCodes addObject:@"th"];
        [googleLanguageCodes addObject:@"tr"];
        [googleLanguageCodes addObject:@"uk"];
        [googleLanguageCodes addObject:@"ur"];
        [googleLanguageCodes addObject:@"vi"];
        [googleLanguageCodes addObject:@"cy"];
        [googleLanguageCodes addObject:@"yi"];
        
        [bingLanguageNames addObject:@"Arabic"];
        [bingLanguageNames addObject:@"Bulgarian"];
        [bingLanguageNames addObject:@"Catalan"];
        [bingLanguageNames addObject:@"Chinese Simplified"];
        [bingLanguageNames addObject:@"Chinese Traditional"];
        [bingLanguageNames addObject:@"Czech"];
        [bingLanguageNames addObject:@"Danish"];
        [bingLanguageNames addObject:@"Dutch"];
        [bingLanguageNames addObject:@"English"];
        [bingLanguageNames addObject:@"Estonian"];
        [bingLanguageNames addObject:@"Finnish"];
        [bingLanguageNames addObject:@"French"];
        [bingLanguageNames addObject:@"German"];
        [bingLanguageNames addObject:@"Greek"];
        [bingLanguageNames addObject:@"Haitian Creole"];
        [bingLanguageNames addObject:@"Hebrew"];
        [bingLanguageNames addObject:@"Hindi"];
        [bingLanguageNames addObject:@"Hungarian"];
        [bingLanguageNames addObject:@"Indonesian"];
        [bingLanguageNames addObject:@"Italian"];
        [bingLanguageNames addObject:@"Japanese"];
        [bingLanguageNames addObject:@"Korean"];
        [bingLanguageNames addObject:@"Latvian"];
        [bingLanguageNames addObject:@"Lithuanian"];
        [bingLanguageNames addObject:@"Norwegian"];
        [bingLanguageNames addObject:@"Polish"];
        [bingLanguageNames addObject:@"Portuguese"];
        [bingLanguageNames addObject:@"Romanian"];
        [bingLanguageNames addObject:@"Russian"];
        [bingLanguageNames addObject:@"Slovak"];
        [bingLanguageNames addObject:@"Slovenian"];
        [bingLanguageNames addObject:@"Spanish"];
        [bingLanguageNames addObject:@"Swedish"];
        [bingLanguageNames addObject:@"Thai"];
        [bingLanguageNames addObject:@"Turkish"];
        [bingLanguageNames addObject:@"Ukrainian"];
        [bingLanguageNames addObject:@"Vietnamese"];
        
        [bingLanguageCodes addObject:@"ar"];
        [bingLanguageCodes addObject:@"bg"];
        [bingLanguageCodes addObject:@"ca"];
        [bingLanguageCodes addObject:@"zh-CHS"];
        [bingLanguageCodes addObject:@"zh-CHT"];
        [bingLanguageCodes addObject:@"cs"];
        [bingLanguageCodes addObject:@"da"];
        [bingLanguageCodes addObject:@"nl"];
        [bingLanguageCodes addObject:@"en"];
        [bingLanguageCodes addObject:@"et"];
        [bingLanguageCodes addObject:@"fi"];
        [bingLanguageCodes addObject:@"fr"];
        [bingLanguageCodes addObject:@"de"];
        [bingLanguageCodes addObject:@"el"];
        [bingLanguageCodes addObject:@"ht"];
        [bingLanguageCodes addObject:@"he"];
        [bingLanguageCodes addObject:@"hi"];
        [bingLanguageCodes addObject:@"hu"];
        [bingLanguageCodes addObject:@"id"];
        [bingLanguageCodes addObject:@"it"];
        [bingLanguageCodes addObject:@"ja"];
        [bingLanguageCodes addObject:@"ko"];
        [bingLanguageCodes addObject:@"lv"];
        [bingLanguageCodes addObject:@"lt"];
        [bingLanguageCodes addObject:@"no"];
        [bingLanguageCodes addObject:@"pl"];
        [bingLanguageCodes addObject:@"pt"];
        [bingLanguageCodes addObject:@"ro"];
        [bingLanguageCodes addObject:@"ru"];
        [bingLanguageCodes addObject:@"sk"];
        [bingLanguageCodes addObject:@"sl"];
        [bingLanguageCodes addObject:@"es"];
        [bingLanguageCodes addObject:@"sv"];
        [bingLanguageCodes addObject:@"th"];
        [bingLanguageCodes addObject:@"tr"];
        [bingLanguageCodes addObject:@"uk"];
        [bingLanguageCodes addObject:@"vi"];

        if ([defaults objectForKey:@"Google From Language"] == nil) {
            [defaults setObject:@"en" forKey:@"Google From Language"];
        }
        
        if ([defaults objectForKey:@"Google To Language"] == nil) {
            [defaults setObject:@"ru" forKey:@"Google To Language"];
        }
        
        if ([defaults objectForKey:@"Google Autodetect"] == nil) {
            [defaults setBool:YES forKey:@"Google Autodetect"];
        }
        
        if ([defaults objectForKey:@"Bing From Language"] == nil) {
            [defaults setObject:@"en" forKey:@"Bing From Language"];
        }
        
        if ([defaults objectForKey:@"Bing To Language"] == nil) {
            [defaults setObject:@"ru" forKey:@"Bing To Language"];
        }
        
        if ([defaults objectForKey:@"Bing Autodetect"] == nil) {
            [defaults setBool:YES forKey:@"Bing Autodetect"];
        }
        
        if ([defaults objectForKey:@"Opening Action"] == nil) {
            [defaults setInteger:0 forKey:@"Opening Action"];
        }
        
        if ([defaults objectForKey:@"Copy To Clipboard"] == nil) {
            [defaults setBool:NO forKey:@"Paste To Clipboard"];
        }
        
        if ([defaults objectForKey:@"Service"] == nil) {
            [defaults setInteger:0 forKey:@"Service"];
        }
        
        id keyComboPlist = [defaults objectForKey:@"Hot Key"];
        SGKeyCombo *keyCombo = [[SGKeyCombo alloc] initWithPlistRepresentation:keyComboPlist];
            
        hotKey = [[SGHotKey alloc] initWithIdentifier:@"Quick Translate Hot Key" keyCombo:keyCombo target:_delegate action:@selector(hotKeyPressed:)];
                
        [keyCombo release];
    }
    
    return self;
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [hotKey release];
    [googleLanguageNames release];
    [googleLanguageCodes release];
    [bingLanguageNames release];
    [bingLanguageCodes release];
    [super dealloc];
}

- (void)awakeFromNib {    
    NSToolbar *toolbar = [[NSToolbar alloc] initWithIdentifier:@"Preferences Toolbar"];
    [toolbar setDelegate:self];
    [toolbar setAllowsUserCustomization:NO];
    [toolbar setDisplayMode: NSToolbarDisplayModeIconAndLabel];
    [toolbar setSizeMode: NSToolbarSizeModeRegular];
    [toolbar setSelectedItemIdentifier:TOOLBAR_GENERAL];
    [[self window] setToolbar:toolbar];
    [toolbar release];

	[[self window] center];
	
    [hotKeyControl setKeyCombo:SRMakeKeyCombo(hotKey.keyCombo.keyCode, [hotKeyControl carbonToCocoaFlags:hotKey.keyCombo.modifiers])];
    
    [self reloadLanguages];
    
	[self setPrefView:nil];
}

- (void)reloadLanguages {
    [fromLanguagesButton removeAllItems];
    [toLanguagesButton removeAllItems];
    
    if ([defaults integerForKey:@"Service"] == 0) {
        for (NSString *name in googleLanguageNames) {
            [fromLanguagesButton addItemWithTitle:name];
            [toLanguagesButton addItemWithTitle:name];
        }
    } else {
        for (NSString *name in bingLanguageNames) {
            [fromLanguagesButton addItemWithTitle:name];
            [toLanguagesButton addItemWithTitle:name];
        }
    }
}

- (void)refresh {
    [serviceButton selectItemAtIndex:[defaults integerForKey:@"Service"]];
    
    if ([defaults integerForKey:@"Service"] == 0) {
        NSString *fromKey = [defaults objectForKey:@"Google From Language"];
        NSString *toKey = [defaults objectForKey:@"Google To Language"];
        
        [fromLanguagesButton selectItemAtIndex:[googleLanguageCodes indexOfObject:fromKey]];
        [toLanguagesButton selectItemAtIndex:[googleLanguageCodes indexOfObject:toKey]];
        
        autodetectButton.state = [defaults boolForKey:@"Google Autodetect"];
    } else {
        NSString *fromKey = [defaults objectForKey:@"Bing From Language"];
        NSString *toKey = [defaults objectForKey:@"Bing To Language"];
        
        [fromLanguagesButton selectItemAtIndex:[bingLanguageCodes indexOfObject:fromKey]];
        [toLanguagesButton selectItemAtIndex:[bingLanguageCodes indexOfObject:toKey]];
        
        autodetectButton.state = [defaults boolForKey:@"Bing Autodetect"];
    }
    
    openAtCursorButton.state = [defaults boolForKey:@"Open At Cursor"];
    copyToClipboardButton.state = [defaults boolForKey:@"Copy To Clipboard"];
    
    [openingActionButton selectItemAtIndex:[defaults integerForKey:@"Opening Action"]];
    [fromLanguagesButton setEnabled:!autodetectButton.state];

    startAtLoginButton.state = [PTLoginItem willStartAtLogin:[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]]];
}

- (NSToolbarItem *)toolbar:(NSToolbar *)toolbar itemForItemIdentifier:(NSString *)ident willBeInsertedIntoToolbar:(BOOL)flag {
    NSToolbarItem * item = [[NSToolbarItem alloc] initWithItemIdentifier:ident];

    if ([ident isEqualToString:TOOLBAR_GENERAL]) {
        [item setLabel:@"General"];
        [item setImage:[NSImage imageNamed:@"NSPreferencesGeneral"]];
        [item setTarget:self];
        [item setAction:@selector(setPrefView:)];
        [item setAutovalidates:NO];
    } else if ([ident isEqualToString:TOOLBAR_ADVANCED]) {
        [item setLabel:@"Advanced"];
        [item setImage:[NSImage imageNamed:@"NSAdvanced"]];
        [item setTarget:self];
        [item setAction:@selector(setPrefView:)];
        [item setAutovalidates:NO];
    } else {
        [item release];
        return nil;
    }

    return [item autorelease];
}

- (NSArray *)toolbarSelectableItemIdentifiers:(NSToolbar *)toolbar {
    return [self toolbarDefaultItemIdentifiers:toolbar];
}

- (NSArray *)toolbarDefaultItemIdentifiers:(NSToolbar *)toolbar {
    return [self toolbarAllowedItemIdentifiers:toolbar];
}

- (NSArray *)toolbarAllowedItemIdentifiers: (NSToolbar *)toolbar {
    return [NSArray arrayWithObjects:TOOLBAR_GENERAL, TOOLBAR_ADVANCED, nil];
}

- (void)setPrefView:(id)sender {
    NSString *identifier;
	
    if (sender) {
        identifier = [sender itemIdentifier];
        [[NSUserDefaults standardUserDefaults] setObject:identifier forKey:@"SelectedPrefView"];
    } else {
        identifier = [[NSUserDefaults standardUserDefaults] stringForKey:@"SelectedPrefView"];
    }
	
    NSView *view;
	
    if ([identifier isEqualToString:TOOLBAR_ADVANCED]) {
        view = advancedView;
	} else {
        identifier = TOOLBAR_GENERAL;
        view = generalView;
    }
        
    [[[self window] toolbar] setSelectedItemIdentifier:identifier];
    
    NSWindow *window = [self window];
	
    if ([window contentView] == view) {
        return;
    }

    NSRect windowRect = [window frame];
    float difference = ([view frame].size.height - [[window contentView] frame].size.height) * [window userSpaceScaleFactor];
    windowRect.origin.y -= difference;
    windowRect.size.height += difference;
   
	difference = ([view frame].size.width - [[window contentView] frame].size.width) * [window userSpaceScaleFactor];
    windowRect.size.width += difference;
	
    [view setHidden:YES];
    [window setContentView:view];
    [window setFrame:windowRect display:YES animate:YES];
    [view setHidden:NO];
    
    if (sender) {
        [window setTitle:[sender label]];
    } else {
        NSToolbar *toolbar = [window toolbar];
        NSString *itemIdentifier = [toolbar selectedItemIdentifier];
        NSEnumerator *enumerator = [[toolbar items] objectEnumerator];
        NSToolbarItem *item;
		
        while ((item = [enumerator nextObject])) {
            if ([[item itemIdentifier] isEqualToString:itemIdentifier]) {
                [window setTitle:[item label]];
                break;
            }
		}
    }
}

- (void)selectTabWithIndetifier:(NSString *)identifier {
	NSView *view;
	
    if ([identifier isEqualToString:TOOLBAR_ADVANCED]) {
        view = advancedView;
	} else {
        identifier = TOOLBAR_GENERAL;
        view = generalView;
    }
        
    [[[self window] toolbar] setSelectedItemIdentifier:identifier];
    
    NSWindow *window = [self window];
	
    if ([window contentView] == view) {
        return;
    }
	
    NSRect windowRect = [window frame];
    float difference = ([view frame].size.height - [[window contentView] frame].size.height) * [window userSpaceScaleFactor];
    windowRect.origin.y -= difference;
    windowRect.size.height += difference;
	
	difference = ([view frame].size.width - [[window contentView] frame].size.width) * [window userSpaceScaleFactor];
    windowRect.size.width += difference;
	
    [view setHidden:YES];
    [window setContentView:view];
    [window setFrame:windowRect display:YES animate:YES];
    [view setHidden:NO];
    
	NSToolbar *toolbar = [window toolbar];
	NSString *itemIdentifier = [toolbar selectedItemIdentifier];
	NSEnumerator *enumerator = [[toolbar items] objectEnumerator];
	NSToolbarItem *item;
    
	while ((item = [enumerator nextObject])) {
		if ([[item itemIdentifier] isEqualToString:itemIdentifier]) {
			[window setTitle:[item label]];
			break;
		}
	}
}

- (IBAction)changeFromLanguage:(id)sender {
    if ([defaults integerForKey:@"Service"] == 0) {
        [defaults setObject:[googleLanguageCodes objectAtIndex:fromLanguagesButton.indexOfSelectedItem] forKey:@"Google From Language"];
    } else {
        [defaults setObject:[bingLanguageCodes objectAtIndex:fromLanguagesButton.indexOfSelectedItem] forKey:@"Bing From Language"];
    }
    
    [defaults synchronize];
    
    [_delegate settingsDidChange];
}

- (IBAction)changeToLanguage:(id)sender {
    if ([defaults integerForKey:@"Service"] == 0) {
        [defaults setObject:[googleLanguageCodes objectAtIndex:toLanguagesButton.indexOfSelectedItem] forKey:@"Google To Language"];
    } else {
        [defaults setObject:[bingLanguageCodes objectAtIndex:toLanguagesButton.indexOfSelectedItem] forKey:@"Bing To Language"];
    }
    
    [defaults synchronize];
    
    [_delegate settingsDidChange];
}

- (IBAction)changeAutoDetect:(id)sender {
    [fromLanguagesButton setEnabled:!autodetectButton.state];
    
    if ([defaults integerForKey:@"Service"] == 0) {
        [defaults setBool:autodetectButton.state forKey:@"Google Autodetect"];
    } else {
        [defaults setBool:autodetectButton.state forKey:@"Bing Autodetect"];
    }
    
    [defaults synchronize];
    
    [_delegate settingsDidChange];
}

- (IBAction)changeOpenAtCursor:(id)sender {
    [defaults setBool:openAtCursorButton.state forKey:@"Open At Cursor"];
    [defaults synchronize];
}

- (IBAction)openingActionDidChange:(id)sender {
    [defaults setInteger:openingActionButton.indexOfSelectedItem forKey:@"Opening Action"];
    [defaults synchronize];
}

- (IBAction)copyToClipboardDidChange:(id)sender {
    [defaults setBool:copyToClipboardButton.state forKey:@"Copy To Clipboard"];
    [defaults synchronize];
}

- (IBAction)changeStartAtLogin:(id)sender {
    [PTLoginItem setStartAtLogin:[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]] enabled:startAtLoginButton.state];
}

- (BOOL)shortcutRecorder:(SRRecorderControl *)aRecorder isKeyCode:(NSInteger)keyCode andFlagsTaken:(NSUInteger)flags reason:(NSString **)aReason {	
	return NO;
}

- (void)shortcutRecorder:(SRRecorderControl *)aRecorder keyComboDidChange:(KeyCombo)newKeyCombo {
    SGKeyCombo *keyCombo = [SGKeyCombo keyComboWithKeyCode:[aRecorder keyCombo].code modifiers:[aRecorder cocoaToCarbonFlags:[aRecorder keyCombo].flags]];

    if ([keyCombo isValidHotKeyCombo]) {
        [[SGHotKeyCenter sharedCenter] unregisterHotKey:hotKey];
        
        hotKey.keyCombo = keyCombo;
        
        [[SGHotKeyCenter sharedCenter] registerHotKey:hotKey];
        
        [defaults setObject:[keyCombo plistRepresentation] forKey:@"Hot Key"];
        [defaults synchronize];
    } else {
        [[SGHotKeyCenter sharedCenter] unregisterHotKey:hotKey];
        
        [defaults removeObjectForKey:@"Hot Key"];
        [defaults synchronize];
    }
}

- (IBAction)changeService:(id)sender {
    [defaults setInteger:serviceButton.indexOfSelectedItem forKey:@"Service"];
    [defaults synchronize];
    
    [self reloadLanguages];
    [self refresh];
    
    [_delegate settingsDidChange];
}

@end
