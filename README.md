# Medical Image Registration Demo

Image registration is one of the key enabling technologies for medical image analysis.  The purpose of this repository is to provide a set of demonstrations that showcase the important roles that image registration plays in the processing and analysis of brain MRI scans.

## Prerequisites

1. [Matlab](http://mathworks.com)

This is the programming language that the demos are currently written in.
 
2. [FSL](http://fsl.fmrib.ox.ac.uk)

This provides the underpinning image registration tools required for the demos, including
* [FLIRT](https://fsl.fmrib.ox.ac.uk/fsl/fslwiki/FLIRT) - a linear registration tool 
* [FNIRT](https://fsl.fmrib.ox.ac.uk/fsl/fslwiki/FNIRT) - a non-linear registration tool.

The demos also make use of FSL's various utilities for processing NIfTI images.

3. [DTI-TK](http://dti-tk.sf.net)

This provides the tool that helps with the visualisation of geometric transformations.

## Download

Please download the entire repository either as a zip archive or as a git clone from https://github.com/garyhuizhang/MedicalImageRegistrationDemo

## Initial set up

After you have downloaded the repository onto your local system, there are just a few simple steps before you can run the actual demos.

1. Add the [Codes](Codes) folder to the Matlab PATH

To do this, first find the full path to this folder. For example, on my system, this is `/Users/gzhang/unix/research/matlab/MedicalImageRegistrationDemo/Codes`.

Next call a built-in Matlab function called [`addpath`](https://mathworks.com/help/matlab/ref/addpath.html) with the full path, in quotation marks, as its input.  On my system, the appropriate Matlab command is

```bash
  addpath('/Users/gzhang/unix/research/matlab/MedicalImageRegistrationDemo/Codes')
```

If you need help with this, please follow this [visual guide](Help/CodesAdd2Path.png) or refer to [Matlab's documentation](https://mathworks.com/help/matlab/ref/addpath.html).

2. Set up the Matlab environment to run FSL

A number of Matlab environment variables are required to allow FSL tools to run from within Matlab. To set this up, first find the full path to the root folder of your FSL installation. For example, on my system, this is `/opt/fsl`.

Next call a Matlab function we provide called [`setupFSL`](Codes/setupFSL.m) with the full path, in quotation marks, as its input. On my system, the appropriate Matlab command is

```bash
  setupFSL('/opt/fsl')
```

If you need help with this, please follow this [visual guide](Help/FSLsetup.png).

3. Set up the Matlab environment to run DTI-TK

The reason to do this is similar to FSL and the process is similar as well. First find the full path to the root directory of your DTI-TK installation. Using my system as an example again, this is `/Users/gzhang/unix/tools/dtitk-2.3.3-Darwin-x86_64`.

Next call a Matlab function we provide called [`setupDTITK`](Codes/setupDTITK.m) with the full path, in quotation marks, as its input. On my system, the appropriate Matlab command is

```bash
  setupDTITK('/Users/gzhang/unix/tools/dtitk-2.3.3-Darwin-x86_64')
```

If you need help with this, please follow this [visual guide](Help/DTITKsetup.png).

## Running the demos

There are currently two demos provided: Image Fusion and Spatial Normalisation.

1. Image Fusion

To run this demo, simply run the following Matlab command:

```bash
  imageFusionDemo
```

2. Spatial Normalisation

To run this demo, simply run the following Matlab command:

```bash
  spatialNormalisationDemo
```
