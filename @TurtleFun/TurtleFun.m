
classdef TurtleFun
    
    properties
        
    end
    
    methods
        
        function [hi, lo, cl, op, da] = returnOHLCDarray(obj, t)
            hi = t(:,3); lo = t(:,4); cl = t(:,5); op = t(:,2); da = t(:,1);
        end
        
        
        function plotHiLo(obj, t)
            [hi, lo, cl, op, da] = obj.returnOHLCDarray(t);
            highlow(hi, lo, op, cl, 'black', da);
            datetick('x',12, 'keeplimits');
            hold on
        end
        
        
        function  [foundRes, foundSup, foundDates,...
                closestRes, closestSup] = getContainerLevels(obj, maxNumDays, hi, lo, da)
            
            begin = 2;
            
            founder = [];
            for i = 10:maxNumDays
                
                res = max(hi(begin:begin+i));
                sup = min(lo(begin:begin+i));
                
                founder = [founder; begin + i, (res-sup)/sup];
                
            end
            
            uniqueNY = unique(founder(:,2));
            foundX = [];
            for i = 1:length(uniqueNY)
                
                specific = find(uniqueNY(i) == founder(:,2));
                
                foundX = [foundX; uniqueNY(i), max(founder(specific,1))];
                
            end
            
            
%             weightedContainer = (100 - foundX(:,1)*100).*[(1./power(1:size(foundX,1),.1))]'
%             weightedTime = foundX(:,2)
%             fScore = weightedContainer.*weightedTime ./ (weightedContainer+weightedTime)
            
            foundLevels = [];
            for i = 1: size(foundX,1)
                
                indxStart   = begin;
                indxEnd     = foundX(i,2);
                
                foundDates  = da(indxStart:indxEnd);
                foundRes    = max(hi(indxStart:indxEnd));
                foundSup    = min(lo(indxStart:indxEnd));
                
                foundLevels = [foundLevels; foundRes, foundSup, da(indxStart), da(indxEnd)];
                
            end
            
            foundRes = foundLevels(:,1);
            foundSup = foundLevels(:,2);
            foundDates = foundLevels(:,3:4);
            
            closestRes = sort(abs((hi(1)-foundRes)./foundRes));
            closestRes = closestRes(1);
            closestSup = sort(abs((lo(1)-foundSup)./foundSup));
            closestSup = closestSup(1);
            
            
            
        end
        
        
        function plotContainer(obj, foundLevels)
            for i = 1:size(foundLevels,1)
                plot([foundLevels(i,4); foundLevels(i,3)], ones(2,1)*foundLevels(i,1), 'b')
                plot([foundLevels(i,4); foundLevels(i,3)], ones(2,1)*foundLevels(i,2), 'b')
            end
            
        end
        
        
        
        
        
        
    end
    
end





