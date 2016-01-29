README File for setting up the Automatic Choroid Segmentation Tool! (AKA, SAVE SPACE Tool)



****** Before Starting ******
Read the manual (or at least familiarize yourself with it).  It is not only a manual on how to use the SAVE SPACE tool, but a manual on how TO USE THIS ENTIRE PROCESS (Heidelberg Eye Explorer -> Matlab -> Export for Statistics).  The manual has tutorials on how to:
- Alter the Heidelberg Engineering software to output XML files and enabling Anterior Angle Measurements
- export poses, in the correct order and format to be use with the segmentation tool
- how to use the segmentation tool
- exporting data in a large table format to facilitate use with any statistical software



****** Inside each folder ******
SAVE SPACE FOLDER
Highest folder.  Contains:
- README.txt (first familiarization)
- ChoroidVolumeGUI.m (Script for editing the choroid lines)
- ChoroidVolumeGUI.fig (GUI for definition of placement of all items)
- SegmentPoses.m (Script for processing xml data and organizing images)
- results.mat (load and export as excel file for all your statistical needs!)
- folders: mfiles, references, XMLOutput, SavedSubjects

MFILES FOLDER
Contains all the matlab files for doing all the fancy-schmancy, nobel prize winning, grant obtaining automatic segmentation.

REFERENCES FOLDER
Contains a manual/tutorial for using the tool, an hraviewer.ini file for setting up Heidelberg Engineering software, and a white paper on the automatic segmentation tool from 2013.

XMLOUTPUT FOLDER
This folder holds the subject poses, grouped by folder, of the images, xml output, and meta data.  If you want more detail in a subject, you can load the subjects _meta.mat file using matlab.

SAVEDSUBJECTS FOLDER
A (currently) empty folder where you can copy paste processed and saved subjects used in the tool.  The tool automatically loads all folders in XMLOutput.  If you already saved a subject, you could move it to SaveSubjects folder so it doesnt automatically open so many folders at once when you open the tool



****** Setting up matlab path ******
Be sure to add all subfolders to your  matlab directory before running the SAVE SPACE tool, or else the tool is no bueno (thats spanish for 'this script will not run because you didnt set up your matlab path').  To set up the path, save the SAVE SPACE folder to wherever you want to work from, and open matlab.  Then:
- click "set path" 
- click "Add with Subfolders..."
- navigate to .../SAVE SPACE
Voila! (Thats French for 'Congratulations! You set up your matlab path!')



****** Questions and contact ******
If you have any questions, feel free to reach me at mvanegas@alum.mit.edu.  I tried testing extensively, but of course, comments always help improve this tool.  As Jay once announced loudly in the lab, almost unprovoked, "Feedback is the breakfast of champions!" So feel free to reach out =)



I hope you enjoy this tool as much as I enjoyed working in the lab.

Best,

Morris Vanegas
morrisvanegas.com