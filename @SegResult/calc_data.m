function calc_data(SegResult)
% Calculates mesh/segment properties and populates SegResult.data fields

	r = SegResult;

	data = struct;
	data.meshN            = length(SegResult.mesh);
	data.meshArea         = zeros(SegResult.data.meshN, 1);
	data.meshBorderArea   = zeros(SegResult.data.meshN, 1);
	data.segmentN         = zeros(SegResult.data.meshN, 1);
	data.segmentAreaTotal = zeros(SegResult.data.meshN, 1);
	data.segmentArea      = cell(SegResult.data.meshN, 1);
	data.meshName		  = cellfun(@(x) x.Aux.name, ...
		SegResult.mesh, 'UniformOutput', 0);

	for i = 1:data.meshN		
		data.meshArea(i) = surface_area(r.mesh{i}.V, r.mesh{i}.F);
		data.segmentN(i) = length(r.mesh{i}.segment);
		segAreaArray = zeros(data.segmentN(i), 1);
		for j = 1:data.segmentN(i)
			segAreaArray(j) = surface_area(r.mesh{i}.segment{j}.V, ...
				r.mesh{i}.segment{j}.F);
		end
		data.SegmentArea{i} = segAreaArray;
		data.segmentAreaTotal(i) = sum(segAreaArray); 
	end
	data.meshborderArea = data.meshArea - data.segmentAreaTotal;

	SegResult.data = data;

	function A = surface_area(V, F)
		% Expects dim x nV and dim x nF matrices
		pArea = zeros(size(F, 2), 1);
		for j = 1:length(pArea)
			p = V(:, F(:, j));
			pArea(j) = triangle_area(p(:, 1), p(:, 2), p(:, 3));
		end
		A = sum(pArea);
	end

	function A = triangle_area(a, b, c)
		A = 0.5 * sqrt(sum(abs(cross(b-a, c-a)).^2));
	end

end