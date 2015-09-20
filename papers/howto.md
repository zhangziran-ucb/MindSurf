#Data Analysis
TestBench Manual:
"Data is stored by TestBench in a standard binary format, EDF, which is compatible with many
EEG analysis programs such as EEGLab. Following the initial information line, each successive
row in the data file corresponds to one data sample, or 1/128 second time slice of data. Successive
rows correspond to successive time slices, so for example one second of data is contained in 128
rows. Each column of the data file corresponds to to an individual sensor location or other information tag"
"Ideally you should apply a high-pass filter which matches the characteristics of the electronics
-that is, you should use a 0.16Hz first order high-pass filter to remove the background sig- nal (this also removes any longer term drift, which is not achieved by the average subtraction
method). Another method is to use an IIR filter to track the background level and subtract it - an
example is shown below in Matlab pseudocode, assuming the first row has been removed from
the array input_data():"

Matlab package: EEGLAB http://sccn.ucsd.edu/eeglab/

OpenViBE: http://openvibe.inria.fr

Emokit (Python): https://github.com/daeken/Emokit/blob/master/Announcement.md

Wiki Emotiv: http://wiki.emotiv.com/tiki-index.php?page=EmoState+And+EEG+Logger+Epoc+page

EDF format documentation: http://www.edfplus.info/
