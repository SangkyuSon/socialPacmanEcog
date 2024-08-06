function visualize(name,dataDir)

cdata = catData(name,dataDir);

figure;

subplot(1,3,1)
plotPsych(cdata.friendlyness,(cdata.choiceItem+1)/2)
xlabel('Friendlyness')
ylabel('p(blue)')

subplot(1,3,2)
plotPsych(cdata.friendlyness,cdata.rewarded)
xlabel('Friendlyness')
ylabel('rewarded prob')

subplot(1,3,3)
plotPsych(cdata.friendlyness,cdata.earnedMoney)
text(0.5,50,sprintf('%.1f',mean(cdata.earnedMoney)))
xlabel('Friendlyness')
ylabel('money')

end

function plotPsych(x,y)
out = psychMetric(x,y);
scatter(out.x,out.y,50,'o','filled','MarkerFaceColor',[1,1,1]*0.2,'MarkerFaceAlpha',0.2)
hold on;
binno =  7;
[cnt, ed, bins] = histcounts(x, linspace(0,1,binno+1));
prob = sum((y.*bins==(1:binno)'),2)'./cnt;
ed = movmean(ed,2);
plot(ed(2:end),prob,'Color',[0,0,0],'LineStyle','--')
plot(out.fitx,out.fity,'Color',[0,0,0])
hold off;
end