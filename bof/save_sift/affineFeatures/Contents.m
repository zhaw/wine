% AFFINE FEATURES
%
% These scripts call functions provided by the Oxford Visual Geometry Group:
%    http://www.robots.ox.ac.uk/~vgg/software/
% Files needed:  h_affine.ln, mser.ln, compute_descriptors.ln
% --> THESE EXECUTABLES MUST BE DOWNLOADED AND PLACED IN THIS DIRECTORY
%
% Feature extraction, description, and visualization
%   displayROI - Overlay regions of interest on image as colored ellipses
%   features   - Detects regions and extracts descriptors
%
% Auxiliary functions
%   edgeROI          - Use linked Canny edges to define regions of interest
%   getROIproperties - Extract geometric properties of region of interest (ROI)
%   h_affine         - (OLD) Detects regions and extracts descriptors
%   loadFeatures     - Input SIFT descriptors as computed by compute_descriptors.ln
%   matchDescriptors - Compute index of closets matching SIFT descriptors
%   overlapSegmentFeature - Overlap between ROI and a segmentation mask
%   removeRedundancy - Remove redundant interest regions with significant overlap
%   showSIFT         - Visualization of SIFT descriptors
%   writeFeatures    - Output regions in format expected by compute_descriptors.ln
