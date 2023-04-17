// Copyright Epic Games, Inc. All Rights Reserved.

#include "GridCaptureEditorModeCommands.h"
#include "GridCaptureEditorMode.h"
#include "EditorStyleSet.h"

#define LOCTEXT_NAMESPACE "GridCaptureEditorModeCommands"

FGridCaptureEditorModeCommands::FGridCaptureEditorModeCommands()
	: TCommands<FGridCaptureEditorModeCommands>("GridCaptureEditorMode",
		NSLOCTEXT("GridCaptureEditorMode", "GridCaptureEditorModeCommands", "GridCapture Editor Mode"),
		NAME_None,
		FEditorStyle::GetStyleSetName())
{
}

void FGridCaptureEditorModeCommands::RegisterCommands()
{
	TArray <TSharedPtr<FUICommandInfo>>& ToolCommands = Commands.FindOrAdd(NAME_Default);

	UI_COMMAND(CaptureTool,
		"Capture images for scene", 
		"Capture images for scene on an autogenerated grid",
		EUserInterfaceActionType::Button, 
		FInputChord());
	ToolCommands.Add(CaptureTool);

}

TMap<FName, TArray<TSharedPtr<FUICommandInfo>>> FGridCaptureEditorModeCommands::GetCommands()
{
	return FGridCaptureEditorModeCommands::Get().Commands;
}

#undef LOCTEXT_NAMESPACE