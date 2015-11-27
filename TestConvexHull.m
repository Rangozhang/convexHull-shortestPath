points = rand(randi(100),2);
vertices = convexHull(points);
figure; plot([vertices(:,1);vertices(1,1)], [vertices(:,2);vertices(1,2)]);
hold on; scatter(points(:,1), points(:,2));