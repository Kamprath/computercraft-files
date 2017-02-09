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
-   [The Framework](#framework)
    -   [Installation](#framework-installation)
    -   [Files and Directories](#framework-files)
    -   [Modules](#framework-modules)
    -   [Menus](#framework-menus)
-   [Command Server & Client](#command)
    -   [Rednet RPC](#command-rednet)
    -   [Modules](#command-modules)
-   [TNT Turtles](#tnt)
    -   [GPS System](#tnt-gps)
    -   [Remote Control Program](#tnt-remote)


The Framework<a name="framework"></a>
=============

Computers use a basic framework to achieve program compatibility across systems. Computers that utilize the framework
share a basic set of modules that allow programs to use features such as system updates, menus, networking, data formatting, and 
more.

Framework code follows a modular strucure. Code is organized into modules that can be reused across systems. A 
[repository server](#framework-modules-repository) can be set up to provide systems with module updates.

Installation<a name="framework-installation"></a>
------------

An installation script on disk 0 automatically installs framework files to a computer. To use the installation script:

1.  Attach a disk drive to the computer.

2.  Insert disk 0 and then start the computer.

3.  The disk's [startup script](https://github.com/Kamprath/computercraft-files/tree/master/disk/0/startup) will copy framework 
    files to the computer. If a `startup` script already exists on the computer, code will be injected into it to check for
    module updates on startup.


Files and Directories<a name="framework-files"></a>
---------------------

The framework consists of several basic files and directories.

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


Modules<a name="framework-modules"></a>
-------

All programs and libraries are organized into modules. Modules allow related code to be encapsulated into files that can be
reused throughout your code.
 

### Creating a Module

A module is simply a script that returns a table or function. Modules are stored in the `/modules` directory and loaded using
Lua's built-in `dofile` function.

Modules follow a simple structure. Here is an example of a module that contains two methods, `init` and `someMethod`:

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
return {
    init = function(self)
        ...
    end,

    someMethod = function(self)
        ...
    end
}
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

A module can be written to mimic the behavior of a class in tradional object-oriented programming. Here is an example of a module
that returns an 'instance' of itself when its `new()` function is called:

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
A module is loaded into a program using Lua's built-in `dofile` function:

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local someModule = dofile('/modules/someModule.lua')
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

In the example above, the `someModule.lua` script is executed. A value is returned and stored in the `someModule` variable.

Some modules may return a function. These types of modules can be 'immediately-invoked' by calling their returned function
immediately after `dofile()`. For example:

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
dofile('/modules/functionModule.lua')()
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This type of module invocation is useful for executing a program in a computer's `startup` file.

### Updates

The framework provides an `update` module that keeps all local modules on a computer up-to-date
with modules on a 'repository' computer. The `update` module sends local module versions to a repository computer
via rednet message. If any of the repository's modules do not match, it sends the computer source code for each
outdated module.

To automatically check for updates and prompt the user on computer startup, prepend the following line to the
computer’s `startup` file (Note: this is done automatically when the framework is set up using the install disk):

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
dofile('/modules/update.lua')()
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

A repository server is required for the `update` module to work. See the [Repository Server](#framework-modules-repository)
section for setup instructions.

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
 

### Repository Server<a name="framework-modules-repository"></a>

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


Menus<a name="framework-menus"></a>
-----

-   Menus are displayed using the `menuinterface` module
-   Modules are stored in the `/menus` directory
-   Menus can be navigated using arrow keys, WASD+E, or by clicking on options


### Creating a Menu


### Using a Menu
