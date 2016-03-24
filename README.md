# iOS hostApp

This project presents a host application to run a single iBuildApp
module.

iBuildApp modules are just library projects, so they cannot be run
standalone. They need an application that can properly initialize and
call them. This project is a minimal application able to perform that.

To make the project be built and run with a specific module, proper
configuration is needed. This is done by `configure_module.sh` script.
During configuration some source and project files are created from
the corresponding template files; a fixed string is substituted with
the module name. You may find an additional information within the
script.

Do not open the project in Xcode until the configuration is done.

# Committing changes

Committing changes in the files having been created from templates may
be tricky (especially the Xcode project file). They are intentionally
ignored by version control system, only the corresponding template
files are tracked. You need running `make_templates_from_files.sh`
script before committing, it will write the files back to template
files with reverse transforming. DO NOT MODIFY TEMPLATE FILES BY HAND,
as the script overwrites them entirely. You may find an additional
information within the script.

