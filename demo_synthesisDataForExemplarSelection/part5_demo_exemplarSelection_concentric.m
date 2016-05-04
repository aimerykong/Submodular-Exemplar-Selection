% This is a demo for exemplar selection described in our paper
% 
% S. Kong, S. Punyasena, C. Fowlkes, "Spatially Aware Dictionary Learning 
% and Coding for Fossil Pollen Identification", CVMI, Los Vegas, NV, (July 2016).
% 
% As introduced in the paper, the objective function is submodular and 
% monotonically increasing that a greedy algorithm can solve efficiently. 
% Moreover, a lazy greedy method is described for fast implementation. 
% Comment/uncomment the lines in "exemplar selection" cell wil enable the 
% standard greedy algorithm or the lazy greedy one.
% 
% Run the matlab codes named part5_demo_exemplarSelectionXXXXXX.m will 
% directly output the results.
% 
% For more visualization, please look at the code and uncomment 
% corresponding parts.
% 
% This demo will be updated when necessary.
% 
% Other demo codes in our fossil pollen project will be released soon, 
% please stay tuned.
% 
% For questions, please contact
% 
% Shu Kong (Aimery) aimerykong AT gmail com
% 
% The code is writen by
%           Shu Kong (Aimery)
%           aimerykong@gmail.com
%           http://www.ics.uci.edu/~skong2/
%           Dec. 2013, release version available on Jan. 13, 2014
%              updated: Nov. 16, 2015
%              updated: May. 03, 2015

clear;
close all;
clc;

%% prelude
%sigma = .2; % sigma controls the Gaussian kernel that convert pair-wise distance to similarity

K = 24;  % select K desired receptive fields

lambdaL = 10;
lambdaD = .01; % discriminative term (2) -- make the selected points more "class-pure" 
lambdaE = 20; % equal-size term (3) -- a very large lambda1 means that the points are being selected from class to class iteratively
lambdaB = 2; % balance term (4) -- make the size of clusters represented by selected point similar

ChoiceGraphBuilding = 'overall_knn'; % which way to build the graph, overall_knn or individual_knn or nothing
knn = 7; % knn-graph to measure RF similarity
eta = .4; % soft-threshold the similarity graph to remove some "dissimilar" pairs

distBound = 0.30;

pointNum = 200;

%% data generation and visualization colors
switch2Display = true;   % set this switch as 'true' to display the results

%strOptPoint = {'rd', 'md', 'b^', 'c^', 'ks', 'ys', 'gx'};
strOptPoint = {'rd', 'b^', 'ks', 'gx'};
strOptExemplar = {'ro', 'bo', 'ko'};
gtColor =  'gp';
OrgPoint = [0.1; 0.1];

X = cell(1, 3);
[X1,Y1] = rand_circ(pointNum, 0, 0, 0.5);
X{1} = [X1(:)';Y1(:)'];


[X1,Y1] = rand_circ(pointNum, 0, 0, 0.8);
X{2} = [X1(:)';Y1(:)'];

[X1,Y1] = rand_circ(pointNum, 0, 0, 1.1);
X{3} = [X1(:)';Y1(:)'];


%% visualize the original dataset
%%{
tempPoint = [];
ttt = 1;
if switch2Display
    figure; hold on; grid on;
    for c = 1:length(X)
        a = X{c} - repmat(OrgPoint, 1, size(X{c},2));
        a = sqrt(sum(a.^2, 1) );
        a = find(a > distBound);        
        tt(ttt) = plot( X{c}(1, :), X{c}(2, :), strOptPoint{c}  );
        ttt = ttt+1;
        
        tempPoint = [tempPoint  a(1)];
        
%         a = setdiff(1:size(X{c},2), a);
%         tt(ttt) = plot( X{c}(1, a), X{c}(2, a), strOptPoint{c}, 'linewidth', 4, 'MarkerSize', 4 );
%         ttt= ttt+1;
        %plot( X{c}(1, a), X{c}(2, a), gtColor  );
        
        tempPoint = [tempPoint  a(1)];
    end
    titleName = 'syntheticData';
    title( titleName );
    legend( [tt(1), tt(2), tt(3) ],...
        'class-1 point','class-2 point','class-3 point', 'Location', 'SouthEastoutside');
%     legend( [tt(1), tt(2), tt(3), tt(4), tt(5), tt(6), ],...
%         'class-1 background point','class-1 foreground point','class-2 background point','class-2 foreground point','class-3 foreground point','class-3 background point',...
%         'Location', 'SouthEast');
    hold off;
%     saveas(gcf, ['./figures/' titleName '.eps'], 'psc2');
%     saveas(gcf,['./figures/' titleName '.fig']);
end
%}

%% fetch the data, extracting RF candidates for all images from specific category
numImg = length(X);
%pointNum = pointNum + pointNumGT;
fprintf('fetch the data (receptive fields candidates)...\n');
imgIdx = zeros( 1, numImg*pointNum );
for i = 1:numImg
    imgIdx(1+pointNum*(i-1):i*pointNum ) = i;
end

%% exemplar selection
Xmat = cell2mat(X);
[SimilarityGraph, SimilarityGraph_full]= graphConstruction(Xmat, imgIdx, ChoiceGraphBuilding, knn);

tic
RFpositive = DiscriminativeExemplarSelection_standardGreedy(SimilarityGraph, SimilarityGraph_full, SimilarityGraph_full, imgIdx, K, lambdaL, lambdaD, lambdaE, lambdaB);
toc

% tic
% RFpositive = DiscriminativeExemplarSelection_LazyGreedy(SimilarityGraph, SimilarityGraph_full, SimilarityGraph_full, imgIdx, K, lambdaL, lambdaD, lambdaE, lambdaB);
% toc


%% check similarity of two lists of exemplars
%{
a = sort(RFpositive1);
b = sort(RFpositive);
flag = true;
ai = 1;
bi = 1;
count = 0;
while flag
    if a(ai) == b(bi)
        count = count + 1;
        ai = ai + 1;
        bi = bi + 1;
    else
        if a(ai) < b(bi)
            ai = ai + 1;
        else
            bi = bi + 1;
        end
    end    
    if ai > length(a) || bi > length(b)
        flag = false;
    end
end
fprintf('similarity between selected exemplars: %.4f\n', count/length(a));
%}

%% visualize the selected RFs
% RFpositive; % find(SelectedFlag);
if switch2Display
    figure; hold on; grid on;
    ttt = 1;
    tt = [];
    for c = 1:3
        tt(ttt) = plot( X{c}(1, :), X{c}(2, :), strOptPoint{c}  );
        ttt = ttt+1;
    end
    IdxImg = imgIdx(RFpositive); % image index
    for i = 1:length(RFpositive)
        plot( Xmat(1, RFpositive(i)), Xmat(2, RFpositive(i)), strOptExemplar{IdxImg(i)}, 'linewidth', 3, 'MarkerSize', 11);        
    end
    
    a = imgIdx(RFpositive);
    b = find(a==1);
    b = b(1);
    b = RFpositive(b);
    tt(ttt) = plot( X{1}(1, b), X{1}(2, b), strOptExemplar{1}, 'linewidth', 3, 'MarkerSize', 11  );
    ttt = ttt+1;
    
    b = find(a==2);
    b = b(1);
    b = RFpositive(b) - pointNum;
    tt(ttt) = plot( X{2}(1, b), X{2}(2, b), strOptExemplar{2}, 'linewidth', 3, 'MarkerSize', 11  );
    ttt = ttt+1;
    
    b = find(a==3);
    b = b(1);
    b = RFpositive(b) - 2*pointNum;
    tt(ttt) = plot( X{3}(1, b), X{3}(2, b), strOptExemplar{3}, 'linewidth', 3, 'MarkerSize', 11  );
    ttt = ttt+1;
    
    titleName = 'selected exemplars';
    hold off; title(titleName);
    legend( [tt(1), tt(4), tt(2), tt(5), tt(3), tt(6), ],...
        'class-1 point', 'class-1 selected point', 'class-2 point', 'class-2 selected point', 'class-3 point','class-3 selected point',...
        'Location', 'SouthEastoutside');
    hold off;
%     saveas(gcf, ['./figures/' titleName '.eps'], 'psc2');
%     saveas(gcf,['./figures/' titleName '.fig'])
%     saveas(gcf,['./figures/' titleName '.jpg']);
end

%% visualize the marginal gain at each iteration
%{
if switch2Display
    az = 30;
    el = 15;
    for iter = 1:size(storeIteration, 2)
        ttt = 1;
        tt = [];
        curFigure = figure(3); hold on; grid on; 
        titleName = ['marginalGainIteration-' num2str(iter)];
        title( titleName );
        for c =1:3
            tt(ttt) = plot3( X{c}(1, :), X{c}(2, :), storeIteration(1+pointNum*(c-1):pointNum*c, iter), strOptPoint{c}  );
            ttt = ttt+1;
        end
        for i = 1:iter
           tt(ttt) = plot3( Xmat(1, RFpositive(i)), Xmat(2, RFpositive(i)), storeIteration( RFpositive(i), iter ), ...
                strOptExemplar{IdxImg(i)}, 'linewidth', 3, 'MarkerSize', 11);
            ttt = ttt+1;
        end
        view(az, el);
%         saveas(gcf, ['./figures/' titleName '.eps'], 'psc2');
%         saveas(gcf,['./figures/' titleName '.fig']);
        saveas(gcf,['./figures/' titleName '.jpg']);
       	close(curFigure)
    end
end
%}


