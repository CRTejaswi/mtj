********************* libSpin: Modular Library for Spintronics*******************
README File
Contains instructions and information regarding the Spintronics Verilog-A Library
Author: Samiran Ganguly, Purdue University
Date: Oct, 2014
Version: 1.0.0alpha
Contact us at: https://nanohub.org/groups/spintronics/
**********************************************************************************

Contents
--------
1. General Information
2. Installation
3. Usage
4. Need Help?

1. General Information
-----------------------

libSpin is a library of basic building blocks that can be used to model a wide variety of spintronic devices and experimental setups. The purpose of this library is to provide an (evolving) set of "building blocks" that can be used to build a circuit model of these devices and designs, much like lego blocks are used to build larger more complex models.

To get to the task of using these modules one needs following tools:

1. A SPICE Program: There are many different SPICE programs avilable, both commerical products from vendors such as Synopsys, Cadence etc. and free ones such a ngspice. Unfortunately SPICE is not a standardized language and all simulators have their own quirks. The library has been tested extensively with HSPICE but in principle should work with other tools too, provided it comes with what follows next.

2. A Verilog-AMS Compiler: To ensure portability across the tools, the library has been written completely in Verilog-A(MS). Therefore, to use this library one must have a Verilog-AMS compiler that produces binaries compatible the SPICE tool being used. Commercial vendors usually bundle a JIT-compiler with their SPICE engine that compiles the modules when necessary. The situation is not so clear in free/open source world where the one compiler used is ADMS whose support for the full language standard is sketchy. Also in such a case the library compilation is not automatic. This might make the task of using the library (first time) a bit more complex.The authors' development platform is HSPICE and the bundled pVA compiler. We'd be very interested to hear experiences using other platforms.

3. A Waveform Viewer: To see the output of the simulation results. Use your favorite tool. The authors use "hspice toolbox" available freely for MATLAB that allows one to directly import the output plots in MATLAB for post-processing.

Along with these one would need a basic understanding of Spintronics. One does not need to be knowledgeable about details of transport theories or magnet-dyanmics, however some basic understanding of the spintronic phenomena is necessary to be able to make spintronic device designs. The modules hide all the complex physics, but one still needs to be able to connect the modules in a meaningful way. For developing that understanding we recommend going through the "NCN NEEDS Summer School on Spintronics 2014" available for free on nanoHUB.org.

Once all the tools are avilable and setup, to model a device one needs to create a netlist of the device/structure under study and simulate it using a SPICE program (after compilation step).

The next two section gives a brief overview of how the library itself has to be installed and used.

2. Installation
----------------

The library is a set of bundled text files. Therefore installation essentially means unpacking the archive file in an appropriate directory and simply reference/include the top level file "libspin.vams" in the netlist. This top level file includes all the other files of the library under the folder "vams" which contains the actual library modules.

This however means every time a new model is built, the library is recompiled which usually shouldn't take more than a few seconds to a few minutes. Since there is a wide variety of tools available it is difficult to suggest a workflow where this compilation is a one time task. Authors are interested to hear about any suggestions and experiences about directly using compiled binaries in their designs.

3. Usage
---------

Inclusion of the library commands depend on the specific SPICE tool being used, for example under HSPICE use < .hdl "\path\to\libspin.vams" >, for other tools the command would be different. Use the directive as per your tool's manual.

Once the library files are included, its modules can be used in a netlist along with other builtin models such as resistors, capacitors, controlled sources, mosfets etc. for example, to use the module "Non-Magnetic Channel" in an HSPICE netlist one would use:

XNM t1c t1x t1y t1z t2c t2x t2y t2z ls_non_magnet length=100e-9 area='(100e-9)*(5e-9)' 

This instantiates a "non-magnetic channel" named XNM between nodes "t1" and "t2" whose length is 100nm and area of cross-section is 100nm x 5nm. Note that there are 8 nodes in there. This is because in libSpin a node carries both charge as well spin voltages and currents. Therefore they come in a set of 4 (hence t1 -> t1c t1x t1y t1z and t2 -> t2c t2x t2y t2z). 
The name of the module is ls_non_magnet, where ls stands for libSpin to ensure unique name for all the libSpin modules and prevent any clashes with any other custom model libraries. All libspin modules are preceded by "ls_".

To attach an MTJ with the "t2" node one will need to use the following command in the netlist:

XMTJ t2c t2x t2y t2z t3c t3x t3y t3z m2x m2y m2z m3x m3y m3z s2x s2y s2z s3x s3y s3z ls_mtj_transport

This connects the MTJ between the nodes "t2" and "t3". Notice that there are extra sets of nodes "m2", "m3", "s2", "s3".
This is done to attach the MTJ to an LLG Solver module that sets up a "self-consistent" simulation of spin transport and in the MTJ and the motion of the MTJ free layer. To attach an LLG solver to the node 3 side magnet (i.e. magnet on node 3 of the circuit is the free layer) one would use:

XLLG 0 0 0 s3x s3y s3z m3x m3y m3z ls_monodomain_noiseless_llg

Which now takes in the "spin torque" current from the MTJ to the LLG and output of the LLG, which is the magnetization direction, is provided to the MTJ. Notice that the first three terminals are grounded. These terminals in LLG accept any external magnetic field. Here it means there is no net external magnetic field on the MTJ.

By connecting together such modules, one can construct a circuit model for a device. As an example, the above three lines shows how one can start creating a model for an STT-RAM module as it has all the vital pieces, MTJ and LLG.

The modules currently available in the library are:

Type                                           Name
-----------                                    ---------------
Non-magnetic channel                           ls_non_magnet
Ferromagnet                                    ls_ferromagnet
FM-NM Interface                                ls_fm_nm_interface
MTJ Transport                                  ls_mtj_transport
Giant Spin Hall Effect                         ls_gsh
LLG Solver                                     ls_monodomain_noiseless_llg
Magnetic Coupling                              ls_coupling

The details of these modules are available on the website https://nanohub.org/groups/spintronics

4. Need Help?
---------------- 

The library itself is hosted on https://nanohub.org/groups/spintronics/ with details about the models of each individual blocks and a few examples and more comprehensive documentation. The library is evolving and more modules will be added in near future.

The authors welcome questions, comments, suggestions, and bug reports regarding the library on the discussion forums on the webpage.

Interested in contributing a module? Please contact the authors in the discussion forums of the webpage liked above and we will contact you.
The modules are copyrighted under the NEEDS modified CMC license and the sopyright will be retained by each contributor themselves.

