These files accompany the world files found here. Computers and programs are documented here for reference.

Computers
=========

| **ID**                                                                    | **Label**                  | **Description**                                                                                                 |
|---------------------------------------------------------------------------|----------------------------|-----------------------------------------------------------------------------------------------------------------|
| [4](https://github.com/Kamprath/computercraft-files/tree/master/4)        | Rail Station Prototype     |                                                                                                                 |
| [8](https://github.com/Kamprath/computercraft-files/tree/master/8)        | Rail System Control Server |                                                                                                                 |
| [9](https://github.com/Kamprath/computercraft-files/tree/master/9)        | Command Device             | Mobile computer with administrative menus that interact with the command server.                                |
| [10](https://github.com/Kamprath/computercraft-files/tree/master/10)      | Command Server             | Maps rednet messages to functions. Functions are executed when the computer receives their respective messages. |
| [7](https://github.com/Kamprath/computercraft-files/tree/master/7), 11-20 | Rednet Repeater            | Computers that relay rednet messages. These are placed at the top of the world for maximum range.               |
| [21](https://github.com/Kamprath/computercraft-files/tree/master/21)      | Module Repository Server   | Hosts module files. Other systems can query for module versions and download module source code over rednet.    |
| 25-28                                                                     | GPS Host                   | Computers acting as hosts in a GPS cluster                                                                      |
| [30](https://github.com/Kamprath/computercraft-files/tree/master/21)      | TNT Turtle                 | Turtle that receives GPS coordinates over rednet and drops TNT at the position.                                 |
 

Contents
========
1.  **Technical Guides**
    -   The Framework
        -   Installation
        -   Files and Directories
        -   Modules
        -   Menus
    -   The Module Repository
        -   Versioning
        -   The `update` Module
2.  **Systems**
    -   Command Server & Client
        -   Rednet RPC
        -   Modules
    -   TNT Turtles
        -   GPS System
        -   Remote Control Program


The Framework
=============

The framework provides a common file structure and set of core modules for programs to use. The framework enables you to write
programs that can reliably run across any computers that implement the framework and any required modules.

System code is organized into modules that can be reused and redistributed between computers. A repository server makes modules
available to all computers and enables computers to keep their modules up-to-date with the repository.


Installation
------------

An installation script can be run to automatically install files and setup the framework on a computer. The installation script
is available on disk 0. To set up the framework using the installation script:

1.  Attach a disk drive to the computer you're installing the framework on.

2.  Insert disk 0 and then start the computer.

3.  The disk's [startup script](https://github.com/Kamprath/computercraft-files/tree/master/disk/0/startup) will copy framework 
    files to the computer. If a `startup` script already exists on the computer, code will be injected into it to check for
    module updates on startup.


Files and Directories
---------------------

-   **`menus/`**   
    This directory contains menu files. Menus contain a list of options that are bound to functions. Programs use the 
    `menuinterface` module to load menus from this directory. See the Menus section for more details about writing and using
    menus.

-   **`modules/`**   
    Modules reside in this directory. Modules are imported from this directory using `dofile('/modules/...')`.

-   **`startup`**   
    The `startup` file is run when a computer boots. The framework uses this file to check for updates. Custom code should be 
    added to this file to determine what a computer will do on startup, such as displaying a menu or launching another script.

-   **`modules.json`**   
    This file contains a JSON object indicating installed module versions. This file is used by the `update` module to compare
    local versions with the repository.


Modules
-------

Code is organized into modules. Modules allow related code to be encapsulated and easily reused.
 

### Creating a Module

A module is a script that simply returns a table or function. Modules are stored in the `/modules` directory on a computer.
Modules follow this basic structure:

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
return {
    init = function(self)
        ...
    end,

    method = function(self)
        ...
    end
}
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

A module may mimic the behavior of a class in tradional object-oriented programming. An example of a module that returns
an 'instance' when its `new()` method is called:

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local module = {
    init = function(self)
        ...

        return this
    end
}

return {
    new = function()
        return module:init()
    end
}
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 
Alternatively, a module may return a single function:

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
return function()
    ...
end
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 

### Usage
Modules are used by importing them into a program using the `dofile` function at the beginning of a script:

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local someModule = dofile('/modules/someModule.lua')
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

In the example above, the value that was returned by the `/modules/someModule.lua` script will be
stored in the `someModule` variable.


### Updates

The framework provides an `update` module to keep all local modules synchronized
with a remote repository. The repository stores the latest module versions.

To have a computer automatically check for updates and prompt the user on startup, put the following line at the beginning of the
computer’s `startup` file (Note: this is done automatically when the framework is set up using the install disk):

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
(dofile('/modules/update.lua'))()
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


#### modules.json

This file is stored in the root directory of a computer. It stores local version numbers
for modules that are stored on a computer. An example of a `modules.json` looks like this:

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
{
  "someModule": "0.1",
  "anotherModule": "1.5.21"
}
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The `update` module will compare versions stored in this file with the versions in a
repository server’s `modules.json` file. If any module versions don’t match the
repository, the `update` module retrieves source code for each outdated module,
updates the computer’s module files, and then updates the versions in its `modules.json` file.
 

### Repository Server

The repository server is a computer that stores the latest module versions.
Repository servers contain a `/modules` directory and `modules.json` file. Other computers that use the `update` module
will keep their local modules synchronized with the repository's.

When making updates to modules that are used across multiple systems, it's a good idea to keep the latest version stored
on a repository server that other computers can reach over a network.

To set up a repository server:

1.  Create a `/modules` directory and store modules in it.

2.  Create a `modules.json` file in the root directory of a computer. The content of this file should be a JSON object with
    keys as module names and values as the current version number of each module stored in the server’s `/modules` directory.

3.  Copy
    [split](https://raw.githubusercontent.com/Kamprath/computercraft-files/master/21/modules/split.lua),
    [json](https://raw.githubusercontent.com/Kamprath/computercraft-files/master/21/modules/json.lua),
    [log](https://raw.githubusercontent.com/Kamprath/computercraft-files/master/21/modules/log.lua),
    and
    [repositoryserver](https://raw.githubusercontent.com/Kamprath/computercraft-files/master/21/modules/repositoryserver.lua)
    modules to the `/modules` directory.

4.  Copy [this startup file](https://github.com/Kamprath/computercraft-files/blob/master/21/startup)
    to the root directory of the computer.

The computer should now act as a repository server. Computers using the `update` module will check for updates and prompt the user
for updates if local versions do not match the repository's.


Menus
-----

-   Menus are displayed using the `menuinterface` module
-   Modules are stored in the `/menus` directory
-   Menus can be navigated using arrow keys, WASD+E, or by clicking on options

### Creating a Menu


### Using a Menu
