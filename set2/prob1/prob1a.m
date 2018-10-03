% Init resource using string given by problem 1.
resource = ["$","b","a","b","a","c","a","a","b"]; % $ is the target letter which indicate where the string starts.
change1 = [];
change1 = resource;
% Loop
% When loop ends, resource will be a square matrix, 
% which is mentioned by ”A” in the question
for i = 1:length(resource)-1
	change1 = [change1(end:1:end),change1(1:1:end-1)];
	resource = [resource; change1];
end
% Sort the matrix. The result is mentioned by ”B” in the question
resource = sortrows(resource);
result = resource(:,end)
