function [SimGroup] = kpointsMPBdos(SimGroup)

%Get reciprocal lattice vectors
b1 = SimGroup.lattice.b1;
b2 = SimGroup.lattice.b2;
b3 = SimGroup.lattice.b3;

%Switch on lattice type in use
switch SimGroup.MPBSimulation.latticeType
    
    case 'diamond'
        %Critical points (in terms of reciprocal lattice vectors)
        Gamma = [0 0 0];
        K = [.375 .75 .375];
        L = [0 .5 0];
        U = [0 .625 .375];
        W = [.25 .75 .5];
        X = [0 .5 .5];
        criticalPointLabels = char('Gamma', 'K', 'L', 'U', 'W', 'X');
        
        %Critical points (k_x, k_y, k_z)
        Gamma_k = Gamma.*b1 + Gamma.*b2 + Gamma.*b3;
        K_k = K(1)*b1 + K(2)*b2 + K(3)*b3;
        L_k = L(1)*b1 + L(2)*b2 + L(3)*b3;
        U_k = U(1)*b1 + U(2)*b2 + U(3)*b3;
        W_k = W(1)*b1 + W(2)*b2 + W(3)*b3;
        X_k = X(1)*b1 + X(2)*b2 + X(3)*b3;
        
        %Produce scatter plot of critical  points
        criticalPoints_k = [Gamma_k; K_k; L_k; U_k; W_k; X_k];
        scatter3(criticalPoints_k(:,1), criticalPoints_k(:,2), criticalPoints_k(:,3),...
            'MarkerEdgeColor', 'r', 'MarkerFaceColor' ,'r');
        hold on
        text(criticalPoints_k(:,1), criticalPoints_k(:,2), criticalPoints_k(:,3),...
            criticalPointLabels, 'horizontal','left', 'vertical','bottom');
        
        %Connect critical points with lines
                
        %Gamma-K
        points = [Gamma_k; K_k];
        plot3(points(:,1), points(:,2), points(:,3), 'LineWidth', 2, 'Color', 'r'); 
        
        %Gamma-X
        points = [Gamma_k; X_k];
        plot3(points(:,1), points(:,2), points(:,3), 'LineWidth', 2, 'Color', 'r'); 
        
        %Gamma-L
        points = [Gamma_k; L_k];
        plot3(points(:,1), points(:,2), points(:,3), 'LineWidth', 2, 'Color', 'r');         
        
        %X-U
        points = [X_k; U_k];
        plot3(points(:,1), points(:,2), points(:,3), 'LineWidth', 2, 'Color', 'r'); 
        
        %X-W
        points = [X_k; W_k];
        plot3(points(:,1), points(:,2), points(:,3), 'LineWidth', 2, 'Color', 'r'); 
        
        %U-L
        points = [U_k; L_k];
        plot3(points(:,1), points(:,2), points(:,3), 'LineWidth', 2, 'Color', 'r');
        
        %U-W
        points = [U_k; W_k];
        plot3(points(:,1), points(:,2), points(:,3), 'LineWidth', 2, 'Color', 'r');
        
        %L-K
        points = [L_k; K_k];
        plot3(points(:,1), points(:,2), points(:,3), 'LineWidth', 2, 'Color', 'r'); 
        
        %K-W
        points = [K_k; W_k];
        plot3(points(:,1), points(:,2), points(:,3), 'LineWidth', 2, 'Color', 'r'); 
       
        axis equal
        
        
        %Define plane constraints for computing point cloud
        
        %Gamma-L-K
        normal = cross(L_k-Gamma_k, K_k-Gamma_k); %Compute normal vector
        normal = normal/norm(normal); %Normalize vector
        SimGroup.MPBSimulation.constraints(1).dir = -1; %Below plane
        SimGroup.MPBSimulation.constraints(1).norm = normal;
        SimGroup.MPBSimulation.constraints(1).pt = Gamma_k;
        
        %Gamma-W-K
        normal = cross(W_k-Gamma_k, K_k-Gamma_k); %Compute normal vector
        normal = normal/norm(normal); %Normalize vector
        SimGroup.MPBSimulation.constraints(2).dir = 1; %Above plane
        SimGroup.MPBSimulation.constraints(2).norm = normal;
        SimGroup.MPBSimulation.constraints(2).pt = Gamma_k;
        
        %Gamma-L-U
        normal = cross(L_k-Gamma_k, U_k-Gamma_k); %Compute normal vector
        normal = normal/norm(normal); %Normalize vector
        SimGroup.MPBSimulation.constraints(3).dir = 1; %Above plane
        SimGroup.MPBSimulation.constraints(3).norm = normal;
        SimGroup.MPBSimulation.constraints(3).pt = Gamma_k;

        %L-K-U
        normal = cross(K_k-L_k, U_k-L_k); %Compute normal vector
        normal = normal/norm(normal); %Normalize vector
        SimGroup.MPBSimulation.constraints(4).dir = 1; %Above plane
        SimGroup.MPBSimulation.constraints(4).norm = normal;
        SimGroup.MPBSimulation.constraints(4).pt = L_k;
        
        %U-W-X
        normal = cross(W_k-U_k, X_k-U_k); %Compute normal vector
        normal = normal/norm(normal); %Normalize vector
        SimGroup.MPBSimulation.constraints(5).dir = 1; %Above plane
        SimGroup.MPBSimulation.constraints(5).norm = normal;
        SimGroup.MPBSimulation.constraints(5).pt = U_k;
        
        %Set maximum point for bounding box
        SimGroup.MPBSimulation.maxBound = SimGroup.MPBSimulation.maxBound.setVec(...
            [max(criticalPoints_k(:,1)), max(criticalPoints_k(:,2)), max(criticalPoints_k(:,3))]);
        
        %Set minimum point for bounding box
        SimGroup.MPBSimulation.minBound = SimGroup.MPBSimulation.minBound.setVec(...
            [min(criticalPoints_k(:,1)), min(criticalPoints_k(:,2)), min(criticalPoints_k(:,3))]);
        
        SimGroup = kPointCloud(SimGroup);
        
    case 'hexagonal'
        %Critical points (in terms of reciprocal lattice vectors)
        Gamma = [0 0 0];
        A = [0 0 .5];
        H = [1/3 1/3 1/2];
        K = [1/3 1/3 0];
        M = [.5 0 0];
        L = [.5 0 .5];
        criticalPointLabels = char('Gamma', 'A', 'H', 'K', 'M', 'L');
        
        %Critical points (k_x, k_y, k_z)
        Gamma_k = Gamma.*b1 + Gamma.*b2 + Gamma.*b3;
        A_k = A(1)*b1 + A(2)*b2 + A(3)*b3;
        H_k = H(1)*b1 + H(2)*b2 + H(3)*b3;
        K_k = K(1)*b1 + K(2)*b2 + K(3)*b3;
        M_k = M(1)*b1 + M(2)*b2 + M(3)*b3;
        L_k = L(1)*b1 + L(2)*b2 + L(3)*b3;
        
        %Produce scatter plot of critical  points
        criticalPoints_k = [Gamma_k; A_k; H_k; K_k; M_k; L_k];
        scatter3(criticalPoints_k(:,1), criticalPoints_k(:,2), criticalPoints_k(:,3),...
            'MarkerEdgeColor', 'r', 'MarkerFaceColor' ,'r');
        hold on
        text(criticalPoints_k(:,1), criticalPoints_k(:,2), criticalPoints_k(:,3),...
            criticalPointLabels, 'horizontal','left', 'vertical','bottom');
        
        %Connect critical points with lines
        
        %Gamma-A
        points = [Gamma_k; A_k];
        plot3(points(:,1), points(:,2), points(:,3), 'LineWidth', 2, 'Color', 'r');
       
        %Gamma-K
        points = [Gamma_k;  K_k];
        plot3(points(:,1), points(:,2), points(:,3), 'LineWidth', 2, 'Color', 'r');
        
        %Gamma-M
        points = [Gamma_k; M_k];
        plot3(points(:,1), points(:,2), points(:,3), 'LineWidth', 2, 'Color', 'r');
        
        %A-H
        points = [A_k; H_k];
        plot3(points(:,1), points(:,2), points(:,3), 'LineWidth', 2, 'Color', 'r');
        
        %A-L
        points = [A_k; L_k];
        plot3(points(:,1), points(:,2), points(:,3), 'LineWidth', 2, 'Color', 'r');
        
        %K-M
        points = [K_k; M_k];
        plot3(points(:,1), points(:,2), points(:,3), 'LineWidth', 2, 'Color', 'r');
        
        %K-H
        points = [K_k; H_k];
        plot3(points(:,1), points(:,2), points(:,3), 'LineWidth', 2, 'Color', 'r');
        
        %H-L
        points = [H_k; L_k];
        plot3(points(:,1), points(:,2), points(:,3), 'LineWidth', 2, 'Color', 'r');
        
        %L-M
        points = [L_k; M_k];
        plot3(points(:,1), points(:,2), points(:,3), 'LineWidth', 2, 'Color', 'r');
        
        axis equal
        
        
        %Define plane constraints for computing point cloud
        
        %Gamma-M-K
        normal = cross(M_k-Gamma_k, K_k-Gamma_k); %Compute normal vector
        normal = normal/norm(normal); %Normalize vector
        SimGroup.MPBSimulation.constraints(1).dir = 1; %Above plane
        SimGroup.MPBSimulation.constraints(1).norm = SimGroup.MPBSimulation.constraints(1).norm.setVec(normal);
        SimGroup.MPBSimulation.constraints(1).pt = SimGroup.MPBSimulation.constraints(1).pt.setVec(Gamma_k);

              
        %A-L-H
        normal = cross(L_k-A_k, H_k-A_k); %Compute normal vector
        normal = normal/norm(normal); %Normalize vector
        SimGroup.MPBSimulation.constraints(2).dir = -1; %Below plane
        SimGroup.MPBSimulation.constraints(2).norm = SimGroup.MPBSimulation.constraints(2).norm.setVec(normal);
        SimGroup.MPBSimulation.constraints(2).pt = SimGroup.MPBSimulation.constraints(2).pt.setVec(A_k);

              
        %A-K-H
        normal = cross(K_k-A_k, H_k-A_k); %Compute normal vector
        normal = normal/norm(normal); %Normalize vector
        SimGroup.MPBSimulation.constraints(3).dir = 1; %Above plane
        SimGroup.MPBSimulation.constraints(3).norm = SimGroup.MPBSimulation.constraints(3).norm.setVec(normal);
        SimGroup.MPBSimulation.constraints(3).pt = SimGroup.MPBSimulation.constraints(3).pt.setVec(A_k);

        
        %A-M-L
        normal = cross(M_k-A_k, L_k-A_k); %Compute normal vector
        normal = normal/norm(normal); %Normalize vector
        SimGroup.MPBSimulation.constraints(4).dir = -1; %Below plane        
        SimGroup.MPBSimulation.constraints(4).norm = SimGroup.MPBSimulation.constraints(4).norm.setVec(normal);
        SimGroup.MPBSimulation.constraints(4).pt = SimGroup.MPBSimulation.constraints(4).pt.setVec(A_k);

        
        %L-K-H
        normal = cross(K_k-L_k, H_k-L_k); %Compute normal vector
        normal = normal/norm(normal); %Normalize vector
        SimGroup.MPBSimulation.constraints(5).dir = -1; %Below plane         
        SimGroup.MPBSimulation.constraints(5).norm = SimGroup.MPBSimulation.constraints(5).norm.setVec(normal);
        SimGroup.MPBSimulation.constraints(5).pt = SimGroup.MPBSimulation.constraints(5).pt.setVec(L_k);

        
        %Set maximum point for bounding box
        SimGroup.MPBSimulation.maxBound = SimGroup.MPBSimulation.maxBound.setVec(...
            [max(criticalPoints_k(:,1)), max(criticalPoints_k(:,2)), max(criticalPoints_k(:,3))]);
        
        %Set minimum point for bounding box
        SimGroup.MPBSimulation.minBound = SimGroup.MPBSimulation.minBound.setVec(...
            [min(criticalPoints_k(:,1)), min(criticalPoints_k(:,2)), min(criticalPoints_k(:,3))]);
        
        SimGroup = kPointCloud(SimGroup);
        
end

end


