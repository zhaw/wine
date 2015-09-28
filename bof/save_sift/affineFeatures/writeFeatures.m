function writeFeatures(file, feat, nb, dim)
%writeFeatures    Output regions in format expected by compute_descriptors.ln

if dim==0
     dim=1;
end

fid = fopen(file, 'w');
fprintf(fid, '%d\n', dim);
fprintf(fid, '%d\n', nb);
fprintf(fid, '%f %f %f %f %f\n', feat);
fclose(fid);
