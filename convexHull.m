function [ vertices ] = convexHull( points )
% points: n-by-2
% vertices: m-by-2

n = size(points, 1);


lIdx = 1;           %lowest index 
for i=2:n
    if (points(lIdx, 2) > points(i, 2)) ||...
      ((points(lIdx, 2) == points(i, 2)) && (points(lIdx, 1) > points(i, 1)))
        lIdx = i;
    end
end

points = swapRows_(points, lIdx, 1);
vec = points(2:end, :) - repmat(points(1, :), n-1, 1);
cosvec = vec(:,1) ./ sqrt(abs(sum(vec.^2, 2)));

sortingHelper = [points(2:end, :), cosvec];

sortedvec = sortrows(sortingHelper, -3);

points(2:end, :) = sortedvec(:,1:2);

vertices_num = 1;
for i=2:n
    while crossProduct(getP(points, vertices_num), points(vertices_num, :), points(i, :)) <= 0
        if vertices_num > 1
            vertices_num = vertices_num-1;
        else
            if i == n
                break;
            else 
                i = i+1;
            end
        end
    end
    vertices_num = vertices_num + 1;
    points = swapRows_(points, vertices_num, i);
end

vertices = points(1:vertices_num, :);
end

function [res] = crossProduct(p1, p2, p3)
    res = (p2(1)-p1(1))*(p3(2)-p1(2))...
        -(p2(2)-p1(2))*(p3(1)-p1(1));
end

function [A] = swapRows_(A, r1, r2)
    tmp = A(r1, :);
    A(r1, :) = A(r2, :);
    A(r2, :) = tmp;
end

function [p1] = getP(points, vertices_num)
    if vertices_num == 1
        p1 = points(end, :);
    else
        p1 = points(vertices_num-1, :);
    end
end