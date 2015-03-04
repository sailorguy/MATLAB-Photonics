classdef StepFcnModifierObj
    %Class definition for StepFcnModifers
    
    %Possible conditions
    
    %'combine-step-funcs'; 'synchronized-magnetic'; 'when-true';
    %'when-false'; 'at-every'; 'after-time';  'before-time'; 'at-time'
    %'after-sources'; 'after-sources+ '; 'during-sources'; 'at-beginning';
    %'at-end'; 'in-volume'
    
    properties
        flag = false %flag to indicate condition is in use
        condition %condition for step function, i.e. at-every, at-time etc.
        data = ''; %data, if relevant for condition, i.e. T, dT
        volume = GeometryObj %Volume describing region to apply step function to
        
    end
    
    methods
        
        function [string] = ctlPrint(obj)
            
            switch obj.condition
                
                case 'in-volume'
                    string = sprintf('in-volume (volume(center %s)(size %s))',...
                        vecToStr(obj.volume.center),vecToStr(obj.volume.size));
                    
                case 'in-point'
                     string = sprintf('in-point (vector3 %s)',...
                        vecToStr(obj.volume.center));
                   
                case 'with-prefix'
                    string = sprintf('%s "%s"', obj.condition, obj.data);
                    
                case 'to-appended'
                    string = sprintf('%s "%s"', obj.condition, obj.data);

                otherwise
                    string = sprintf('%s %f', obj.condition, obj.data);

            end       
        end
        
        
        
    end
end
