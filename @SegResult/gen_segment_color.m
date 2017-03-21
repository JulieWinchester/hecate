function gen_segment_color(SegResult)
% GEN_SEGMENT_COLOR - Returns 4xnFace matrix with per-segment colors

if ~isfield(SegResult.data, 'segmentN')
	SegResult.calc_data()
end

n = max(SegResult.data.segmentN);
colors = horzcat(distinguishable_colors(n), repmat(1.0, [n, 1]))';
for i = 1:length(SegResult.mesh)
	for j = 1:length(SegResult.mesh{i}.segment)
		SegResult.mesh{i}.segment{j}.c = repmat(colors(:, j), ...
			[1, size(SegResult.mesh{i}.segment{j}.F, 2)]);
	end
end

