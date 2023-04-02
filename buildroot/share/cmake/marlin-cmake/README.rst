=============
Marlin CMake
=============

Marlin CMake is based on Arduino CMake with some modifications to be used for compiling Marlinf firmware with minimal setup.

**Arduino CMake** is hosted on GitHub and is available at:

https://github.com/queezythegreat/arduino-cmake



Requirements
------------

* Base requirements:

  - ``CMake`` - http://www.cmake.org/cmake/resources/software.html
  - ``Arduino SDK`` - http://www.arduino.cc/en/Main/Software

* Linux requirements:

  - ``gcc-avr``      - AVR GNU GCC compiler
  - ``binutils-avr`` - AVR binary tools
  - ``avr-libc``     - AVR C library
  - ``avrdude``      - Firmware uploader


Getting Started
---------------


The following instructions are for **\*nix** type systems, specifically this is a Linux example.

In short you can get up and running using the following commands::

    mkdir build
    cd build
    cmake ..
    make


CMake Generators
~~~~~~~~~~~~~~~~

Once installed, you can start using CMake the usual way, just make sure to chose either a **MSYS Makefiles** or **Unix Makefiles** type generator::

    MSYS Makefiles              = Generates MSYS makefiles.
    Unix Makefiles              = Generates standard UNIX makefiles.
    CodeBlocks - Unix Makefiles = Generates CodeBlocks project files.
    Eclipse CDT4 - Unix Makefiles
                                = Generates Eclipse CDT 4.0 project files.


Eclipse Environment
-------------------

Eclipse is a great IDE which has a lot of functionality and is much more powerful than the *Arduino IDE*. In order to use Eclipse you will need the following:

1. Eclipse
2. Eclipse CDT extension (for C/C++ development)

On most Linux distribution you can install Eclipse + CDT using your package manager, otherwise you can download the `Eclipse IDE for C/C++ Developers`_ bundle.

Once you have Eclipse, here is how to generate a project using CMake:

1. Create a build directory that is next to your source directory, like this::
   
       build_directory/
       source_directory/

2. Run CMake with the `Eclipse CDT4 - Unix Makefiles` generator, inside the build directory::

        cd build_directory/
        cmake -G"Eclipse CDT4 - Unix Makefiles" ../source_directory

3. Open Eclipse and import the project from the build directory.

   1. **File > Import**
   2. Select `Existing Project into Workspace`, and click **Next**
   3. Select *Browse*, and select the build directoy.
   4. Select the project in the **Projects:** list
   5. Click **Finish**


