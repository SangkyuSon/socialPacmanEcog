clear all; 
dataDir = '/home/sangkyu/YlabNAS/sangkyu/opponent/task_human';
addpath(genpath(dataDir))
name = 'ksw';
data = catData(name,dataDir);
%%
nf
subjects = {'ksw','rhr','ssk','mia','jhr'};
NoS = length(subjects);

for m = 1:NoS,
    cdata = catData(subjects{m},dataDir);
    x = cdata.friendlyness;
    y = (cdata.choiceItem+1)/2;
    %out = psychMetric(x,y);
    %plot(out.fitx,out.fity,'Color',[1,1,1]*1)
    %hold on;
    binno =  10;
    [cnt, ed, bins] = histcounts(x, linspace(0,1,binno+1));
    prob = sum((y.*bins==(1:binno)'),2)'./cnt;
    ed = movmean(ed,2);
    plot(ed(2:end),prob,'Color',[0,0,0],'LineStyle','--')
    xx{m} = x;
    yy{m} = y;
    hold on;
end

out = psychMetric(cell2mat(xx),cell2mat(yy));
plot(out.fitx,out.fity,'Color',[1,1,1]*0)




%%
condCols = {[1,0,0],[0,0.7,0],[0,0,1]};
nf;
for p = [1,3],
    
    
    ad = cellfun(@(x1,x2,x3) nanmean(sqrt(sum((x1(x3==p,:)-x2(x3==p,:)).^2,2))),data.eyePos,data.avatar,data.phase,'un',1)';
    od = cellfun(@(x1,x2,x3) nanmean(sqrt(sum((x1(x3==p,:)-x2(x3==p,:)).^2,2))),data.eyePos,data.opponent,data.phase,'un',1)';
    pd = cellfun(@(x1,x2,x3) nanmean(sqrt(sum((x1(x3==p,:)-x2(x3==p,:)).^2,2))),data.eyePos,data.prey,data.phase,'un',1)';
    
    subplot(2,2,p-(p>2)*1)
    corrplot_custom(data.friendlyness',ad-od);

    subplot(2,2,p-(p>2)*1+2)
    corrplot_custom(data.friendlyness',ad,'Color',condCols{1});
    corrplot_custom(data.friendlyness',pd,'Color',condCols{2});
    corrplot_custom(data.friendlyness',od,'Color',condCols{3});

    co(1,p) = corr(data.friendlyness',ad-od,'rows','pairwise');
    
%     subplot(2,3,p+3)
%     pz = cellfun(@(x1,x2) nanmean(x1(x2==p)),data.eyeSz,data.phase,'un',1)';
%     scatter(data.friendlyness',pz)
%     co(2,p) = corr(data.friendlyness',pz);
    
end
disp(co)


%scatter(data.friendlyness,pd)



