//Installing dotfiles for Windows System
//@author Kenta Suzuki <suzuken326@gmail.com>
WScript.Echo("install the dot files into user's home directory");

//const
var FOF_SILENT            = 0x04;
var FOF_RENAMEONCOLLISION = 0x08;
var FOF_NOCONFIRMATION    = 0x10;
var FOF_ALLOWUNDO         = 0x40;
var FOF_FILESONLY         = 0x80;
var FOF_SIMPLEPROGRESS    = 0x100;
var FOF_NOCONFIRMMKDIR    = 0x200;
var FOF_NOERRORUI         = 0x400;
var FOF_NORECURSION       = 0x1000;

var obj = new ActiveXObject("Shell.Application");
var fileObj = new ActiveXObject("Scripting.FileSystemObject");
var dotfilesDirPath = String(WScript.ScriptFullName).replace(WScript.ScriptName,"");
var targetFolder = fileObj.GetFolder(dotfilesDirPath);
var destinationFolder = targetFolder.ParentFolder;
var targetFolderItems = new Enumerator(targetFolder.files);

var objItem;
for (; !targetFolderItems.atEnd(); targetFolderItems.moveNext()){
    objItem = targetFolderItems.item();
    //ignoring files had dot on that head.
    if(objItem.Name.charAt(0) !== "."){
        WScript.Echo(objItem.Name);
        objItem.Copy(destinationFolder.Path + "\\." + objItem.Name);
    }
}

obj = null;
fileObj = null;
