function APF = computeAPF(lattice)
%Compute Atomic Packing Factor from a lattice object

switch lattice.type
    
    case 'hexagonal'
        
        %Number of atoms
        Natoms = 6;
        
        %Compute crystal volume, assume regular hexagonal structure
        Vcrystal = [(3*sqrt(3)*sqrt(2/3)*lattice.a^3)];
        
        
end

%Compute APF
APF = Natoms*pi*lattice.radius^3/Vcrystal;


end