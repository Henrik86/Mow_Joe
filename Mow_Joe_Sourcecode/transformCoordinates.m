function [cordTransformed]=transformCoordinates(points,centerMass,base)
    
               vTilde=[centerMass(1)-base(1),centerMass(2)-base(2)];
               l=(sqrt(sum(vTilde(1)^2+vTilde(2)^2)));
               v=vTilde/l;
               w=[-v(2),v(1)];
               cordTransformed=[]
               %%
               for t=1:nrows(points)
                pX=points(t,1);
                pY=points(t,2);
                newX=[pX-base(1),pY-base(2)]*(v'/l);
                newY=[pX-base(1),pY-base(2)]*[(w'/l)]
                cordTransformed=[cordTransformed;newX,newY]
              end
  end   

