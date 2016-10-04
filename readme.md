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
| [30](https://github.com/Kamprath/computercraft-files/tree/master/21)                                                                        | TNT Turtle                 | Turtle that receives GPS coordinates over rednet and drops TNT at the position.                                 |
| [39](https://github.com/Kamprath/computercraft-files/tree/master/39)      | Demo System                | Demonstrates proper file structure, module loading, and menu usage                                              |
=======
| [39](https://github.com/Kamprath/computercraft-files/tree/master/39)      | Demo System                | Demonstrates proper file structure, module loading, and menu usage                                              |

 

Modules
=======

Most of the code in this repository is organized into modules. Modules allow
related code to be encapsulated into files that can be easily distributed and
reused among systems.

 

Creating a Module
-----------------

A module consists of a lua file that simply returns a table or function. Modules
are stored in a `/modules` directory on each computer. Most modules in this
repository are structured like so:

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

 

An example of a module that acts as an instantiable object may look like this:

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local module = {
    init = function(self)
        ...
    end
}

return {
    new = function()
        module:init()
    end
}
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

 

A module may perform a single function and be structured as so:

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
return function()
    -- module code
end
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

 

Using a Module
--------------

Modules can be used anywhere - even within other modules. Modules are typically
‘imported’ using the `dofile` function at the beginning of a script like so:

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local someModule = dofile('/modules/someModule.lua')
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

 

Now, whatever code was returned by the `/modules/someModule.lua` script will be
stored in the `someModule` variable.

 

Updating Modules
----------------

Computers can implement the `update` module to keep their modules synchronized
with a central module repository.

 

To use the `update` module, simply put this code at the beginning of a
computer’s `startup` file:

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
(dofile('/modules/update.lua'))()
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

 

### modules.json

This file exists in the root directory of a computer. It stores version numbers
for modules that are stored on a computer. An example of a `modules.json` file
may look like this:

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
{
  "someModule": "0.1",
  "anotherModule": "1.5.21"
}
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

 

The `update` module will compare versions stored in this file with versions in a
repository server’s `modules.json` file. If any module versions don’t match the
repository, the `update` module retrieves source code for each outdated module,
updates the computer’s module files, and updates module versions in its
`modules.json` file.

 

### Repository Server

Modules are stored on a computer that acts as the central repository server.
This computer has similar file structure to other computers which implement
modules, except that other computers keep their files in sync with the files in
the repository server’s `modules/` directory.

 

To set up a repository server:

1.  Create a `/modules` directory. Store the latest versions of modules in this
    directory.

2.  Create a `modules.json` file in the root directory of a computer. In this
    file, create a JSON object with keys as module names and values as the
    version number of the module stored in the server’s `/modules` directory.

3.  Copy
    [split](https://raw.githubusercontent.com/Kamprath/computercraft-files/master/21/modules/split.lua),
    [json](https://raw.githubusercontent.com/Kamprath/computercraft-files/master/21/modules/json.lua),
    [log](https://raw.githubusercontent.com/Kamprath/computercraft-files/master/21/modules/log.lua),
    and
    [repositoryserver](https://raw.githubusercontent.com/Kamprath/computercraft-files/master/21/modules/repositoryserver.lua)
    modules to the `/modules` directory.

4.  Copy [this startup
    file](https://github.com/Kamprath/computercraft-files/blob/master/21/startup)
    to the root directory.

 

The computer should now act as a repository server in which other computers
using the `update` module will sync their module files with.

 

Menu System
===========

Coming soon!
