function element = computePlotElement(element, parentX, parentY, k)

global SimViewer_g

switch element.type
    case 'Primary Data'
        %Do nothing
        
    case 'Fitted Line'
        
        switch element.fitType
            
            case 'Smoothed Line'
                
                element.xData = parentX;
                element.yData = smooth(parentY, element.smoothedProperties.coeff, 'lowess');
                
                
            case 'Urbach Tail'
                
                %Determine valid data
                validData = ((parentX > element.urbachProperties.xMin) & (parentX < element.urbachProperties.xMax));
                
                %Get data from parent data
                element.xData = parentX(validData);
                element.yData = parentY(validData);
                
                %Compute exponential fit
                s = exp2fit(element.xData, element.yData, 1);
                fun = @(s,t) s(1)+s(2)*exp(-t/s(3));
                
                %Compute y points from fit
                element.yData = fun(s,element.xData);
               
                %Compute fitting parameters
                %alpha(E) = alpha0*exp((E-E1)/E0) + beta
                element.urbachProperties.E0 = -s(3);
                element.urbachProperties.alpha = s(2)/exp(-element.urbachProperties.E1/element.urbachProperties.E0);
                element.urbachProperties.beta = s(1);
                
                
            case 'Model'
                %Determine valid data
                validData = ((parentX > element.modelProperties.dataXmin) & (parentX < element.modelProperties.dataXmax));
               
                %Get data from parent data
                element.xData = parentX(validData);
                element.yData = parentY(validData);
                
                %Check to see if there is no data
                if(isempty(element.xData) || isempty(element.yData))
                    return;
                end
                
                %Get fit object
                fitobject = fit(element.xData, element.yData, element.modelProperties.modelType);
                
                %Get X values to use in display
                element.xData = linspace(element.modelProperties.displayXmin, element.modelProperties.displayXmax, 1000);
                
                %Compute Y values
                element.yData = feval(fitobject, element.xData);
                
                %Get model data
                element.modelProperties.formula = formula(fitobject);
                element.modelProperties.coeffNames = coeffnames(fitobject);
                element.modelProperties.coeffValues = coeffvalues(fitobject);
                
                
        end
                
                
                
        end
end

