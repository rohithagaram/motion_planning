% Robotics: Estimation and Learning 
% WEEK 3
% 
% Complete this function following the instruction. 
function myMap = occGridMapping(ranges, scanAngles, pose, param)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% Parameters 
% 
% % the number of grids for 1 meter.
r = param.resol;
%  the initial map size in pixels
myMap = zeros(param.size);
% % the origin of the map in pixels
myorigin = param.origin; 

% % 4. Log-odd parameters 
lo_occ = param.lo_occ;
lo_free = param.lo_free; 
lo_max = param.lo_max;
lo_min = param.lo_min;

N = size(pose,2);
n = size(scanAngles,1);

for j = 1:N % for each time,
      % Find grids hit by the rays (in the gird map coordinate)
      x_o = ranges(:,j) .* cos(scanAngles + pose(3,j)) + pose(1,j);
      y_o = -1*ranges(:,j) .* sin(scanAngles + pose(3,j)) + pose(2,j);
      car = [ceil(pose(1,j)*r) + myorigin(1)  ceil(pose(2,j)*r) + myorigin(2)];
      % Find occupied-measurement cells and free-measurement cells
      occ= [ceil(x_o*r)+myorigin(1)  ceil(y_o*r) + myorigin(2)];

      del_occ =  occ(:,2)<1 | occ(:,1)<1 |  occ(:,2) > param.size(1) |  occ(:,1) > param.size(2);
      occ(del_occ) =[] ;
      occ_index = sub2ind(size(myMap),occ(:,2),occ(:,1));
      myMap(occ_index) =  myMap(occ_index)  + lo_occ;
      
      [freex,freey]  = bresenham(car(1),car(2),occ(:,1),occ(:,2));  
      if size(freex,2)>0
        freex_ = freex';
        freey_ = freey';
        del_index = freex_<1 | freex_()> param.size(2) | freey_<1 | freey_>param.size(1);
        freex_(del_index) = [];
        freey_(del_index) = [];
        freex = freex_';
        freey = freey_';
        %freex(freex(:,1)<0)=[];
        %freex(freex(:,1)>param.size(2))=[];
        %freey(freex(:,1)<0)=[];
        %freey(freex(:,1)>param.size(2))=[];

        %freex(freey(:,1)<0)=[];
        %freex(freey(:,1)>param.size(1))=[];
        %freey(freey(:,1)<0)=[];
        %freey(freey(:,1)>param.size(1))=[];
        free = sub2ind(size(myMap),freey,freex);
        myMap(free) = myMap(free)-lo_free;
      
      end
    myMap = min(myMap,lo_max);
    myMap = max(myMap,lo_min);
end



