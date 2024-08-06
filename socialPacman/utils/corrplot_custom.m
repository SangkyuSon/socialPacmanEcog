function [rho,p] = corrplot_custom(x,y,varargin)
if size(x,1)==1, x = x'; end
if size(y,1)==1, y = y'; end

options = struct(...
    'method','Spearman',...
    'Color',[1,1,1]*0,...
    'alpha',0.3,...
    'regIntercept','on',...
    'size',10,...
    'verbose', 1);
options = checkOptions(options,varargin{:});
     
scatter(x,y,options.size,options.Color,'filled','MarkerFaceAlpha',options.alpha)
hold on

y(isinf(y)) = nan;
coef = glmfit(x,y,'normal','Constant',options.regIntercept);
coef = [flipud(coef);zeros(2-length(coef),1)];
if options.verbose, plot(linspace(min(x),max(x),100),linspace(min(x),max(x),100)*coef(1)+coef(2),'Color',options.Color); end

[rho,p] = corr(x,y,'type','Spearman','rows','pairwise');
if options.verbose, text(nanmedian(x),nanmedian(y),sprintf('%s: %.3f (%.3f)',options.method(1),rho,p),'Color',options.Color); end

end