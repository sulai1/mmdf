function interp  = prcinterp( precisions, recalls, steps)
% interpolate multiple precision recall curves at the given steps.

% precisions : cellaray containing the precision arrays of the queries
% recalls : cellarray containing the recall arrays of the queries
% steps : 1xn array of recall levels at which to interpolate

    nCurves = length(precisions);
    nSteps = numel(steps);

    
    % interpolate the curve
    interp = zeros(1,length(steps));
    for i=1:nSteps
        % we have to look for that particular recall
        recall = steps(i);
        for n=1:nCurves
            % now we have to find the element with the given recall
            indices = recalls{n}>=recall;
            % next get the max from the right side
            tail = precisions{n}(indices);
            interp(i) = interp(i)+max(tail);
        end
        interp(i) = interp(i)/nCurves;
    end
end
