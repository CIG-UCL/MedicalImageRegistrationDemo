# Medical Image Registration Demo

Image registration is one of the key enabling technologies for medical image analysis.  The purpose of this repository is to provide a set of demonstrations that showcase the important roles that image registration plays in the processing and analysis of brain MRI scans.

Examples produced from this demo were included as part of [Image Registration - Chapter 6](https://www.sciencedirect.com/science/article/pii/B9780128224793000154) of the book [Advanced Neuro MR Techniques and Applications](https://www.elsevier.com/books/advanced-neuro-mr-techniques-and-applications/choi/978-0-12-822479-3).

## Prerequisites

1. [Matlab](http://mathworks.com)

This is the programming language that the demos are currently written in.
 
2. [FSL](http://fsl.fmrib.ox.ac.uk)

This provides the underpinning image registration tools required for the demos, including
* [FLIRT](https://fsl.fmrib.ox.ac.uk/fsl/fslwiki/FLIRT) - a linear registration tool 
* [FNIRT](https://fsl.fmrib.ox.ac.uk/fsl/fslwiki/FNIRT) - a non-linear registration tool.

The demos also make use of FSL's various utilities for processing NIfTI images.

3. [DTI-TK](https://dti-tk.sourceforge.net/pmwiki/pmwiki.php)

This provides the tool that helps with the visualisation of geometric transformations.

## Download

There are a number of ways to download the repository to your local system.

1. Command line

If you are comfortable with the command line options, you can use the following command:

```bash
  git clone https://github.com/garyhuizhang/MedicalImageRegistrationDemo.git
```

2. Matlab GUI

Matlab provides a simple GUI to download a Git respository. The documentation of this functionality is available [here](https://uk.mathworks.com/help/simulink/ug/clone-git-repository.html). I have provided a set of screenshots to illustrate the process: [Step 1](Help/matlabGitRetrieval1.png), [Step 2](Help/matlabGitRetrieval2.png), and [Step 3](Help/matlabGitRetrieval3.png).

## Initial set up

After you have downloaded the repository onto your local system, there are just a few simple steps before you can run the actual demos.

1. Add the [Code](Code) folder to the Matlab PATH

To do this, first find the full path to this folder. For example, on my system, this is `/Users/gzhang/unix/research/matlab/MedicalImageRegistrationDemo/Code`.

Next call a built-in Matlab function called [`addpath`](https://mathworks.com/help/matlab/ref/addpath.html) with the full path, in quotation marks, as its input.  On my system, the appropriate Matlab command is

```bash
  addpath('/Users/gzhang/unix/research/matlab/MedicalImageRegistrationDemo/Code')
```

If you need help with this, please follow this [visual guide](Help/CodeAdd2Path.png) or refer to [Matlab's documentation](https://mathworks.com/help/matlab/ref/addpath.html).

2. Set up the Matlab environment to run FSL

A number of Matlab environment variables are required to allow FSL tools to run from within Matlab. To set this up, first find the full path to the root folder of your FSL installation. For example, on my system, this is `/opt/fsl`.

Next call a Matlab function we provide called [`setupFSL`](Code/setupFSL.m) with the full path, in quotation marks, as its input. On my system, the appropriate Matlab command is

```bash
  setupFSL('/opt/fsl')
```

If you need help with this, please follow this [visual guide](Help/FSLsetup.png).

3. Set up the Matlab environment to run DTI-TK

The reason to do this is similar to FSL and the process is similar as well. First find the full path to the root directory of your DTI-TK installation. Using my system as an example again, this is `/Users/gzhang/unix/tools/dtitk-2.3.3-Darwin-x86_64`.

Next call a Matlab function we provide called [`setupDTITK`](Code/setupDTITK.m) with the full path, in quotation marks, as its input. On my system, the appropriate Matlab command is

```bash
  setupDTITK('/Users/gzhang/unix/tools/dtitk-2.3.3-Darwin-x86_64')
```

If you need help with this, please follow this [visual guide](Help/DTITKsetup.png).

## Running the demos

There are currently two demos provided: Image Fusion and Spatial Normalisation.

1. [Image Fusion](Code/imageFusionDemo.m)

To run this demo, simply run the following Matlab command:

```bash
  imageFusionDemo
```

2. [Spatial Normalisation](Code/spatialNormalisationDemo.m)

To run this demo, simply run the following Matlab command:

```bash
  spatialNormalisationDemo
```
