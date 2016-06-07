function interp  = prcinterp( precisions, recalls , steps)
% interpolate multiple precision recall curves at the given steps.

% precisions : cellaray containing the precision arrays of the queries
% recalls : cellarray containing the recall arrays of the queries
% steps : 1xn array of recall levels at which to interpolate

nCurves = length(precisions);
nSteps = numel(steps);

%% interpolate all curves
interps = cell(1,nCurves);
for n=1:nCurves
    % get precision and recall for that curve
    precision = precisions{n};
    recall = recalls{n};
    
    nEl = numel(precision);
    
    % interpolate the curve
    interps{n} = zeros(1,nEl);
    for i=1:nEl
        interps{n}(i)= max(precision(i:end)); 
    end
end

%% interpolate between curves
% calculate the average at the given precision steps
interp = zeros(1,nSteps);
indices = ones(1,nCurves);
for i=1:nSteps
    sum = 0;
    rec = steps(i);
    for j=1:nCurves
        recall = recalls{j};
        
        while indices(j)<numel(recall) && recall(indices(j))<rec
            indices(j) = indices(j) + 1;
        end
        sum = sum + interps{j}(indices(j));
    end
    interp(i) = sum/double(nCurves);
end
end

