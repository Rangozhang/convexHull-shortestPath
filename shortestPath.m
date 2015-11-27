function [ finalVertices ] = shortestPath(start, end_, robot, obstacles)
%SHORTESTPATH 
% start:        1-by-2
% end:          1-by-2
% robot:        r-by-2
% obstacles:    n-by-1 - each cell: m-by-2
% finalVertices:v-by-2

n = length(obstacles);
r = size(robot, 1);

% assign the first point as base point
bpt = robot(1,:); 

% cspace vertices
cspaceVtx = cell(n);

% find cspace
for i = 1:length(obstacles)
    obs = obstacles{i};
    m = size(obs, 1);
    pts = [];
    
    for j = 1:m
        for k = 1:r
            pts = [pts; obs(j,:)+bpt-robot(k,:)];
        end
    end
    
    cspaceVtx{i} = convexHull(pts);
end

% collect all the vertices
vtces = [start; end_];
for i = 1:length(cspaceVtx)
    vtces = [vtces; cspaceVtx{i}];
end
Vn = size(vtces, 1); %vertices_num

% adjacency matrix
matrix = zeros(Vn*(Vn-1), Vn*(Vn-1));

for i = 1:Vn
   for j = i+1:Vn
       
      v1 = vtces(i,:);
      v2 = vtces(j,:);
      
      if isPassingThroughCspace(v1, v2, cspaceVtx) == false
          matrix(i, j) = norm(v1 - v2);
          matrix(j, i) = norm(v1 - v2);
      end
      
   end
end

graph = sparse(matrix);

[~, vInd] = graphshortestpath(graph, 1, 2, 'directed', true);

finalVertices = vtces(vInd, :);

end

function [Passed] = isPassingThroughCspace(v1, v2, cspaceVtx)
    Passed = false;
    n = length(cspaceVtx);
    
    % check the edge is acrossing edges
    for i=1:n
        vertices = cspaceVtx{i};
        [intescX, interscY] = polyxpoly([vertices(:,1);vertices(1,1)],...
            [vertices(:,2);vertices(1,2)], [v1(1), v2(1)], [v1(2), v2(2)]);
        
        if size(intescX, 1) ~= 0
            for h = 1:size(intescX, 1)
                %if isempty(mfind(vertices, [intescX(intescV), interscY(intescV)]))
                if (intescX(h)~=v1(1) || interscY(h)~=v1(2)) && (intescX(h)~=v2(1) || interscY(h)~=v2(2))
                    Passed = true;
                    return;
                end
            end
        end
    end
    
    % check the edge is in polygon
    for i=1:n
        vertices = cspaceVtx{i};
        mid_x = (v1(1)+v2(1))/2;
        mid_y = (v1(2)+v2(2))/2;
        [in, on] = inpolygon(mid_x, mid_y, vertices(:,1), vertices(:,2));
        if in == 1 && on == 0
           Passed = true;
           return;
        end
    end
end

