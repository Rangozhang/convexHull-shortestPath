obstacles = cell(5);
figure;
for i=1:length(obstacles)
    obstacles{i} = convexHull(10*rand(3+randi(2),2));
    vertices = obstacles{i};
    plot([vertices(:,1);vertices(1,1)], [vertices(:,2);vertices(1,2)],'r','LineWidth',3);
    hold on; 
end
%{
obstacles{1} = [2,2;2,6;6,6;6,2]; vertices = obstacles{1};
plot([vertices(:,1);vertices(1,1)], [vertices(:,2);vertices(1,2)]); hold on;
obstacles{1} = [3,3;2,6;6,6;6,2]; vertices = obstacles{1};
plot([vertices(:,1);vertices(1,1)], [vertices(:,2);vertices(1,2)]); hold on;
%}
start = [0,0]; 
end_ = [10,10];
robot = [0,0;0,1;1,1];
plot([robot(:,1);robot(1,1)], [robot(:,2);robot(1,2)]);

finalVertices = shortestPath(start, end_, robot, obstacles)

plot(finalVertices(:,1), finalVertices(:,2),'b','LineWidth',2);
scatter([start(:,1);end_(:,1)], [start(:,2);end_(:,2)]);