//
//  iOSFile.h
//  Wofl
//
//  Created by Josh on 2/4/13.
//  Copyright (c) 2013 Josh. All rights reserved.
//

#ifndef Wofl_iOSFile_h
#define Wofl_iOSFile_h

#include "WoflFile.h"

class iOSFile : public WoflFile
{
public:
	
	iOSFile()
		: WoflFile()
	{
		MainBundle = [NSBundle mainBundle];
		WoflBundle = [NSBundle bundleForClass:NSClassFromString(@"WoflViewController")];
	}
	
	virtual std::string GetFinalPath(FileDomain Domain, const char* InSubPath) override
	{
		if (Domain == FileDomain::Absolute)
		{
			return InSubPath;
		}

		assert(Domain == FileDomain::Game || Domain == FileDomain::System || Domain == FileDomain::Save);

		NSString* SubPath = InSubPath ? [NSString stringWithUTF8String:InSubPath] : nil;
		NSString* Path;
		if (Domain == FileDomain::Save)
		{
			// get doc dir location
			NSArray* DocumentsDirs = [[NSFileManager defaultManager] URLsForDirectory:NSApplicationSupportDirectory inDomains:NSUserDomainMask];
			NSURL* DocDir = [DocumentsDirs objectAtIndex:0];
	
			// append bundle id (to work with non-sandboxed)
			DocDir = [DocDir URLByAppendingPathComponent:[NSBundle mainBundle].bundleIdentifier];
			
			Path = [NSString stringWithCString:[DocDir fileSystemRepresentation] encoding:NSUTF8StringEncoding];

//			// make sure the dir exists
//			[[NSFileManager defaultManager] createDirectoryAtPath:Dir withIntermediateDirectories:YES attributes:nil error:nil];
	
			// append the MainResourcesSubdir to differentiate saves
			if (GameDomain.length() > 0)
			{
				Path = [Path stringByAppendingPathComponent:[NSString stringWithUTF8String:GameDomain.c_str()]];
			}
			if (SubPath)
			{
				Path = [Path stringByAppendingPathComponent:SubPath];
			}
			
			// make sure the dir exists, if there's an extension to indicate a file
			if ([Path pathExtension])
			{
				NSString* Dir = [Path stringByDeletingLastPathComponent];
				[[NSFileManager defaultManager] createDirectoryAtPath:Dir withIntermediateDirectories:YES attributes:nil error:nil];
			}
			
			return [Path UTF8String];
		}
		else
		{
//			// check if there's an extension, then we will use bundle magic to get it
//			NSString* Ext = SubPath ? [SubPath pathExtension] : @"";
						
			NSString* Path = [MainBundle resourcePath];
			Path = [Path stringByAppendingPathComponent:@"Resources"];
			if (Domain == FileDomain::Game)
			{
				Path = [Path stringByAppendingPathComponent:[NSString stringWithUTF8String:GameDomain.c_str()]];
			}
			else
			{
				Path = [Path stringByAppendingPathComponent:@"System"];
			}
			if (SubPath)
			{
				Path = [Path stringByAppendingPathComponent:SubPath];
			}
			
			BOOL bIsDir;
			bool bExists = [[NSFileManager defaultManager] fileExistsAtPath:Path isDirectory:&bIsDir];
			
			// for system files
			if (!bExists && Domain == FileDomain::System)
			{
				Path = [WoflBundle resourcePath];
				if (SubPath)
				{
					Path = [Path stringByAppendingPathComponent:SubPath];
				}
				bExists = [[NSFileManager defaultManager] fileExistsAtPath:Path isDirectory:&bIsDir];
			}
			
			if (bExists)
			{
				return Path.UTF8String;
			}
//			
//			if (SubPath)
//
//			NSString* AppBundleFilenameStr = @"Resources";
//			NSString* WoflBundleFilenameStr = @"Resources";
//			if (MainResourceSubdir != nil)
//			{
//				AppBundleFilenameStr = [AppBundleFilenameStr stringByAppendingPathComponent:MainResourceSubdir];
//			}
//			AppBundleFilenameStr = [AppBundleFilenameStr stringByAppendingPathComponent:[NSString stringWithUTF8String:Filename]];
//			WoflBundleFilenameStr = [WoflBundleFilenameStr stringByAppendingPathComponent:[NSString stringWithUTF8String:Filename]];
//
//			NSString* Path = [MainBundle
//							  pathForResource:[AppBundleFilenameStr stringByDeletingPathExtension]
//							  ofType:[AppBundleFilenameStr pathExtension]];
		}

//		if (SubPath)
//		{
//			Path = [Path stringByAppendingPathComponent:[NSString stringWithUTF8String:SubPath]];
//		}

		return "";
	}
	
//	virtual std::string GetResourcePath(const char* Filename) override
//	{
//		NSString* AppBundleFilenameStr = @"Resources";
//		NSString* WoflBundleFilenameStr = @"Resources";
//		if (MainResourceSubdir != nil)
//		{
//			AppBundleFilenameStr = [AppBundleFilenameStr stringByAppendingPathComponent:MainResourceSubdir];
//		}
//		AppBundleFilenameStr = [AppBundleFilenameStr stringByAppendingPathComponent:[NSString stringWithUTF8String:Filename]];
//		WoflBundleFilenameStr = [WoflBundleFilenameStr stringByAppendingPathComponent:[NSString stringWithUTF8String:Filename]];
//
//		NSString* Path = [MainBundle
//						  pathForResource:[AppBundleFilenameStr stringByDeletingPathExtension]
//						  ofType:[AppBundleFilenameStr pathExtension]];
//		
//		if (Path == nil)
//		{
//			Path = [WoflBundle
//					pathForResource:[WoflBundleFilenameStr stringByDeletingPathExtension]
//					ofType:[WoflBundleFilenameStr pathExtension]];
//		}
//
//		return [Path UTF8String];
//	}
	
//	virtual std::string GetSavePath(const char* Filename) override
//	{
//		// get doc dir location
//		NSArray* DocumentsDirs = [[NSFileManager defaultManager] URLsForDirectory:NSApplicationSupportDirectory inDomains:NSUserDomainMask];
//		NSURL* DocDir = [DocumentsDirs objectAtIndex:0];
//
//		// append bundle id (to work with non-sandboxed)
//		DocDir = [DocDir URLByAppendingPathComponent:[NSBundle mainBundle].bundleIdentifier];
//		
//		// make sure the dir exists
//		NSString* Dir = [NSString stringWithCString:[DocDir fileSystemRepresentation] encoding:NSUTF8StringEncoding];
//		[[NSFileManager defaultManager] createDirectoryAtPath:Dir withIntermediateDirectories:YES attributes:nil error:nil];
//		
//		// append the MainResourcesSubdir to differentiate saves
//		if (MainResourceSubdir != nil)
//		{
//			DocDir = [DocDir URLByAppendingPathComponent:MainResourceSubdir];
//		}
//
//		// append filename to it
//		DocDir = [DocDir URLByAppendingPathComponent:[NSString stringWithUTF8String:Filename]];
//		
//		return [DocDir fileSystemRepresentation];
//	}
	
	virtual std::vector<std::string> FindFiles(FileDomain Domain, const char* InDirectory, const char* Ext, bool bIncludePath, bool bIncludeExtension) override
	{
		std::vector<std::string> Results;
		std::string Directory = GetFinalPath(Domain, InDirectory);
		
		NSDirectoryEnumerator *DirEnum = [[NSFileManager defaultManager] enumeratorAtPath:[NSString stringWithUTF8String:Directory.c_str()]];
		NSString* Extension = [NSString stringWithUTF8String:Ext];
		NSString* File;
		while ((File = [DirEnum nextObject]))
		{
			if ([[File pathExtension] isEqualToString:Extension])
			{
				NSString* Result = File;
				if (!bIncludePath)
				{
					Result = [Result lastPathComponent];
				}
				if (!bIncludeExtension)
				{
					Result = [Result stringByDeletingPathExtension];
				}
				Results.push_back(Result.UTF8String);
			}
		}
		
		return Results;
	}

	virtual bool LoadFile(const std::string& Path, std::string& OutString) override
	{
		NSString* PathStr =[NSString stringWithCString:Path.c_str() encoding:NSUTF8StringEncoding];
		NSString* Contents = [NSString stringWithContentsOfFile:PathStr encoding:NSUTF8StringEncoding error:nil];
		if (Contents && [Contents length] > 0)
		{
			OutString = [Contents UTF8String];
			return true;
		}

		return false;
	}

	virtual bool LoadFile(const std::string& Path, std::vector<unsigned char>& OutArray) override
	{
		NSString* PathStr =[NSString stringWithCString:Path.c_str() encoding:NSUTF8StringEncoding];
		NSMutableData* Contents = [NSMutableData dataWithContentsOfFile:PathStr];

		if (Contents && Contents.length > 0)
		{
			// make a vector with the contents
			OutArray.resize(Contents.length);
			memcpy(OutArray.data(), [Contents bytes], Contents.length);
			
			// empty now to free memory before the return copy of the vector
			[Contents setLength:0];
			return true;
		}
		
		return false;
	}

	
	virtual void* LoadPNGToAllocatedBuffer(const char* ImageName, unsigned int& Width, unsigned int& Height) override
	{
		// load PNG
		std::vector<unsigned char> Bytes = LoadFileToArray(ImageName, FileDomain::GameThenSystem);
		if (Bytes.size() == 0)
		{
			return nullptr;
		}
		NSData* Data = [NSData dataWithBytes:Bytes.data() length:Bytes.size()];
//		std::string ImagePathStr = GetFinalPath(FileDomain::Game, ImageName);
//		NSString* ImagePath = [NSString stringWithCString:ImagePathStr.c_str() encoding:NSUTF8StringEncoding];
#if TARGET_OS_MAC
		NSImage* Image = [[NSImage alloc] initWithData:Data];
#else
		UIImage* Image = [UIImage imageWithData:Data];
#endif
		if (Image == nullptr)
		{
			return nullptr;
		}
		
		// pull out info
		Width = [Image size].width;
		Height = [Image size].height;
		
		// allocate all the memory
		void* ImageData = malloc(Width * Height * 4);
		memset(ImageData, 0, Width * Height * 4);
		
#if TARGET_OS_MAC
		NSRect ImageRect = NSMakeRect(0, 0, Width, Height);
		CGImageRef CGImage = [Image CGImageForProposedRect:&ImageRect context:NULL hints:nil];
#else
		CGImageRef CGImage = Image.CGImage;
#endif

		// draw the UIImage into the memory block
		CGContextRef SpriteContext = CGBitmapContextCreate(ImageData, Width, Height, 8, Width * 4,
														   CGImageGetColorSpace(CGImage),
														   kCGImageAlphaPremultipliedLast);
		// After you create the context, you can draw the sprite image to the context.
		CGContextDrawImage(SpriteContext, CGRectMake(0.0, 0.0, (CGFloat)Width, (CGFloat)Height), CGImage);
		// You don't need the context at this point, so you need to release it to avoid memory leaks.
		CGContextRelease(SpriteContext);

		return ImageData;
	}
	
	virtual bool SaveStringToFile(const std::string& String, const char* Path, FileDomain Domain) override
	{
		std::string PathStr = GetFinalPath(Domain, Path);
//		NSString* PathStr = GetFina[NSString stringWithCString:Path encoding:NSUTF8StringEncoding];
		NSString* Contents = [NSString stringWithCString:String.c_str() encoding:NSUTF8StringEncoding];

		NSError* Error;
		[Contents writeToFile:[NSString stringWithUTF8String:PathStr.c_str()] atomically:YES encoding:NSUTF8StringEncoding error:&Error];

		if (Error)
		{
			NSLog(@"Failed to save %s, error = %@", PathStr.c_str(), [Error localizedDescription]);
			return false;
		}
		
		return true;
	}
	
	virtual bool SaveArrayToFile(const std::vector<unsigned char>& Array, const char* Path, FileDomain Domain) override
	{
		NSString* PathStr =[NSString stringWithCString:Path encoding:NSUTF8StringEncoding];
		NSData* Contents = [NSData dataWithBytes:Array.data() length:Array.size()];

		NSError* Error;
		[Contents writeToFile:PathStr options:NSDataWritingAtomic error:&Error];
		
		if (Error)
		{
			NSLog(@"Failed to save %@, error = %@", PathStr, [Error localizedDescription]);
			return false;
		}
		
		return true;
	}

protected:
	NSBundle* WoflBundle;
	NSBundle* MainBundle;
};

#endif
