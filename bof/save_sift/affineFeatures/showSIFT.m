function showSIFT(v)
%showSift     Visualization of SIFT descriptors
% Assumes that the organization is:
%   orientations: 1 - vertical_up and rotates clockwise
%   locations: 1 = top-left (scanning in rows)

% I assume that the descriptor is of length 128
Nr = 4;
Nc = 4;

% Normalize the maximum to be 0.5
v = .5*v/max(v(:));

% Draw all in the same axis in order to be able to use subplot to visualize
% multiple descrptors in the same figure.
i = 0;
t = linspace(0, 2*pi, 9); t = t(1:8);
for r = 1:Nr
    for c = 1:Nc
        w = v(i+1:i+8);
        
        x = c + sin(t).*w;
        y = (Nr-r) + cos(t).*w;
                
        for n = 1:8
            plot([c x(n)],[(Nr-r) y(n)], 'b', 'linewidth',2); hold on
        end
        plot(c,(Nr-r),'ro','MarkerFaceColor','r'); hold on

        i = i+8;
    end
end

axis([-1 Nc+2 -2 Nr+1]); axis('square'); axis('off')

