# DESI-2-histology
Project to register DESI-MS images to corresponding histology images
Main functions are: nnmftest and registrationtest
nnmftest takes in the sample DESI and histology images and performs all of the image processing (DESI to image and edge detection)
registrationtest performs the EM-ICP registration
In nnmftest, the images are either in .tif or .png format, so there are two different import functions used depending on which is the case.
The emregister folder contains all relevant code for the ICP registration
