# Cell_quant_ADRIAN_V2

### License
Copyright 2018 Novartis Institutes for BioMedidical Research Inc.
Licensed under the Apache License, Version 2.0 (the "License");
ou may not use this file except in complicane with the License.
You may obtain a copy of the License at
http://www.apache.org/licenses/License-2.0
Unless required by applicable law or agreed to in writing, software
distributed under the License is distrubuted on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONITIONS OF ANY KIND, either express or 
implied. See the License for the specific Language Governing the permissions 
and limiations under the License. 

### Overview
This MatLab Image Analysis code will quantify the number of postive ojects in
an image using size and intensity thresholds.

This analysis requires the Image Processing Toolbox and Signal Processing 
Toolbox for MatLab to function. 

All files must be Tagged Image Format (.tiff). Images will be displayed 
to the user in a masked, and randomized fashion to avoid an biases. 

### Procedure 
1. Run the script in MatLab
2. Direct the program to the folder containing the images
3. Crop out any non-specific staining, or unwanted signal
4. Press the "space bar" to advance
5. Click to add any cells back to the image analysis 
6. Press the "space bar" to advance
7. Once all images have been analyzed an excel file will compile the results

### Tips
A temporary data file will be created at the start of the analysis to
keep track of any work in case MatLab shuts down accidentally. This file
can be found in the same folder as the code. Delete this file to run a 
new analysis. 

Line 35 dinfes the backgroun that will be subtracted from the original
image. The radius of the of the structured element disk is defined at
the end of the line. Increasing the radius of the disk decreases how
much background is removed, whereas decreasing the radius of the disk 
will increase how much background is removed. 

Line 40 is the intensity mask, any objects below the designated threshold
will be removed from the analysis. Adjusting the value of the numerator
will change the threshold. Only numbers between 0 and 255 can be used.

Line 41 is the large size exclusion, this will remove objects larger
than the designated pixel area. Adjusting this value will change the 
exclusion/inclusion criteria of larger opbjects.

Line 42 is the small size exlusion, this will remove objects smaller than
the designated pixel area. Adjusting this value will change the exclusion/
inclusion criteria of smaller objects. 