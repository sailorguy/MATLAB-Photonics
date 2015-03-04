function structurePlot(SimGroup)


%Draw source arrow


%arrow3D([-10 0 0], [3 0 0], 'r', .8);
%axis([-10 10 -8 8 -3 3]);
%campos([0 0 128]);

%grid off
set(gcf, 'Position', [50 50 1000 800]);
set(gcf, 'PaperPositionMode', 'auto');

print(gcf,'-r2000', 'StructurePlot.jpeg', '-djpeg')

end
