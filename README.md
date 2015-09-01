# ios_hostApp
The "hostApp" folder contains project files for the host-application. These project files are used for launching and deploying your iOS Feature. Normally there is no need to change these files.

The "_REPLACE_MODULE_NAME_" folder contains files and folders of the project that serves as a template for your iOS Feature. This is the place where you will allocate your source code.

The "userContent" folder is used to store a user-generated content (images, audio files, text files, configuration files, etc.) that is required for the Feature you develop. Once your Feature is compiled, the ready-to-use static library will be allocated into this folder.

To properly register your iOS Feature, the iBuildApp SDK requires that project files follow this convention:

Resource file names should start with Feature ID, i.e.  

_REPLACE_MODULE_NAME_logo_small.png (image resource file)

_REPLACE_MODULE_NAME_appconfig.xml (XML resource file)

The static library file created during the Feature compilation should have exactly the same name as the Feature ID, with <.a> extension (by default the template is set up that way - do not change those settings!): _REPLACE_MODULE_NAME_.a
Name of the starting View Controller that serves as a Root View Controller of View Controllers stack for your Feature should be as the following:_REPLACE_MODULE_NAME_ViewController (by default the template is set up that way - do not change those settings!)
