{ <PiNote - free source code editor>

Copyright (C) <2021> <Enzo Antonio Calogiuri> <ecalogiuri(at)gmail.com>

This source is free software; you can redistribute it and/or modify it under
the terms of the GNU General Public License as published by the Free
Software Foundation; either version 2 of the License, or (at your option)
any later version.

This code is distributed in the hope that it will be useful, but WITHOUT ANY
WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
details.

A copy of the GNU General Public License is available on the World Wide Web
at <http://www.gnu.org/copyleft/gpl.html>. You can also obtain it by writing
to the Free Software Foundation, Inc., 51 Franklin Street - Fifth Floor,
Boston, MA 02110-1335, USA.
}
unit U_Messages;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

Var
   NoNameFile                   : String = 'Untitled';
   ErrWriteFile                 : String = 'Error while write file...!';
   ErrReadFile                  : String = 'Error while read file...!';
   ErrCopyFile                  : String = 'Error while copy the file...!';
   ErrFileNotFound              : String = 'Error! File not found!';
   ErrCloseAll                  : String = 'Some documents have been modified, close anyway?';
   ErrClose                     : String = 'The document was modified, close anyway?';
   MsgReloadDoc                 : String = 'Reload the currend document?';
   LabelPassEncrypt             : String = 'Password used to encrypt file:';
   LabelPassDecrypt             : String = 'Password used to decrypt file:';
   LabelPassEncryptClpB         : String = 'Password used to encrypt clipboard:';
   LabelPassDecryptClpB         : String = 'Password used to decrypt clipboard:';
   ClpBEncryptOk                : String = 'Clipboard encrypted.';
   ClpBDecryptOk                : String = 'Clipboard decrypted.';
   ClpBEncryptErr               : String = 'Error, can''t encrypt clipboard!';
   ClpBDecryptErr               : String = 'Error, can''t decrypt clipboard!';
   ClpBNoText                   : String = 'There is no text on the clipboard...';
   ClpFileCopied                : String = 'File copied into clipboard...';
   ClpFileNameCopied            : String = 'File name copied into clipboard...';
   ClpPathCopied                : String = 'Path copied into clipboard...';
   ExtTShortCutExist            : String = 'Shortcut alredy used...';
   ExtTDeleteCommand            : String = 'Delete the selected command?';
   ExtTShortCutNotDefined       : String = 'Shortcut to external tool not defined!';
   DeleteClipboard              : String = 'Are you sure you want empty the clipboard?';
   NeedPrjName                  : String = 'You must insert a project name...';
   NoPrjPath                    : String = 'The path of project not exists...';
   NoPrjTable                   : String = 'Error, missing projects table!';
   ErrPrjTable                  : String = 'Error while write the projects table!';
   PrjDeletePrj                 : String = 'Are you sure to delete the selected project alias?';
   PrjAddNewFile                : String = 'Create new file in project...';
   PrjAddNewFileLabel           : String = 'Enter just the new file name...';
   PrjAddNewDir                 : String = 'Create new folder in project...';
   PrjAddNewDirLabel            : String = 'Enter just the new folder name...';
   PrjFileExists                : String = 'Filename alredy exist in the folder!';
   PrjDirExists                 : String = 'Folder alredy exist!';
   PrjRemoveDir                 : String = 'Delete the selected folder with content?';
   PrjRemoveFile                : String = 'Delete the selected file?';
   PrjNoSelection               : String = 'You must select a file or folder...';
   PrjRenameFile                : String = 'Rename a file of a project...';
   PrjRenameFileLabel           : String = 'Enter just the new name for file...';
   PrjMustSelectFile            : String = 'You must select a file!';
   PrintPrwMsg1                 : String = ' Page ';
   PrintPrwMsg2                 : String = 'Print on: ';
   NoMacroRecorded              : String = 'No Macro Recorded...';
   NoProgIniFile                : String = 'No preference file found. Options set to default values!';
   NoDragDropEnabled            : String = 'Drag and Drop is disabled by Program Options...';
   NoTransparentEnabled         : String = 'Transparent is disabled by Program Options...';

   OSNotSupported               : String = 'Function non supported on this OS!';

implementation

end.

