function Component()
{
    // default constructor
}

Component.prototype.createOperations = function()
{
    // call default implementation to actually install README.txt!
    component.createOperations();

    if (systemInfo.productType === "windows") {
        component.addOperation("CreateShortcut", "@TargetDir@/addhoursandminutes.exe", "@StartMenuDir@/Add Hours and Minutes.lnk", "workingDirectory=@TargetDir@");
        component.addOperation("CreateShortcut", "@TargetDir@/maintenancetool.exe", "@StartMenuDir@/Uninstall.lnk", "workingDirectory=@TargetDir@");
    }
}
