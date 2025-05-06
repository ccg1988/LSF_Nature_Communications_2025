function [ tuning_area, tuning_vector_magnitude] = analyze_srf_half( rates, spon, plot_on)

% This program is initially programed by Evan Remington
% Please cite this paper (Remington and Wang, 2019) when using it.

Color2 = [185,141,62]/256; %brown
Color3 = [100,168,96]/256; %green
Color4 = [204,84,94]/256; %pink-red

if size(rates,1)>size(rates,2)
   rates = rates';
end
rates = rates - spon ;
[rate_max, ~] = max(rates);
threshold = rate_max/2 ;
srf = load('SRF_half_R_raw.mat');    
speaker_locations = srf.speakers;
speaker_number=size(speaker_locations,1);
spatial_resolution = 5;
longitude_limit = 180-spatial_resolution/2;
latitude_limit = 90-spatial_resolution/2;
nlongitude_cells = 360/spatial_resolution;
nlatitude_cells = 180/spatial_resolution;

longitude = repmat(-1*longitude_limit:spatial_resolution:longitude_limit,nlatitude_cells,1);
latitude = repmat(-1*latitude_limit:spatial_resolution:latitude_limit,nlongitude_cells,1)';

latitude_up = latitude(:,1) + spatial_resolution/2;
latitude_down = latitude(:,1) - spatial_resolution/2;
longitude_left = longitude(:,1) + spatial_resolution/2;
longitude_right = longitude(:,1) - spatial_resolution/2;

interp_cell_areas = areaquad(latitude_down,longitude_right,latitude_up,longitude_left);
interp_cell_areas = repmat(interp_cell_areas,1,nlongitude_cells);

distances = zeros(speaker_number, nlatitude_cells, nlongitude_cells);
for i = 1:speaker_number %faster to do it this way instead of element by element. Takes .01 - .3 seconds
    distances(i,:,:) = reshape(distance(speaker_locations(i,[2 1]), [latitude(:) longitude(:)]),nlatitude_cells,nlongitude_cells);
end

rate_interpolation = zeros(nlatitude_cells,nlongitude_cells);
for i = 1:nlatitude_cells
    for j = 1:nlongitude_cells
        [dist, index] = sort(distances(:,i,j));
        weights = (1./dist(1:2)).^2./(sum(1./dist(1:2).^2));
        rate_interpolation(i,j) = sum(weights'.*rates(index(1:2)));
    end
end

threshold_contour = contourc(rate_interpolation,[threshold threshold]);
index = 1;
final_contour = 0;
to_clear_index = [];
i = 1;
while final_contour == 0 && ~isempty(threshold_contour)
    contour_length = threshold_contour(2,index);
    if contour_length > 10
        threshold_contour(:,index) = NaN; 
        raw_contours{i} = threshold_contour(:,index+1:index+contour_length);
        if any(raw_contours{i}(1,:) == 1)
            [~,contour_index] = max(raw_contours{i}(1,:));
            rate_interp_index(2) = floor(raw_contours{i}(1,contour_index));
            rate_interp_index(1) = round(raw_contours{i}(2,contour_index));
        else
            [~, contour_index] = min(raw_contours{i}(1,:));
            rate_interp_index(2) = ceil(raw_contours{i}(1,contour_index));
            rate_interp_index(1) = round(raw_contours{i}(2,contour_index));
        end        
    else
        to_clear_index = [to_clear_index index:index + contour_length];
    end
    index = index + contour_length + 1;
    if index >= size(threshold_contour,2)
        final_contour = 1;
    end
    i = i + 1;
end
threshold_contour(:,to_clear_index) = [];
threshold_contour(1,:) = threshold_contour(1,:)*spatial_resolution-(180+spatial_resolution/2);
threshold_contour(2,:) = threshold_contour(2,:)*spatial_resolution-(90+spatial_resolution/2);
threshold_contour(1,threshold_contour(1,:) == max(max(longitude))) = 180;
threshold_contour(1,threshold_contour(1,:) == min(min(longitude))) = -180;
threshold_contour(2,threshold_contour(2,:) == max(max(latitude))) = 90;
threshold_contour(2,threshold_contour(2,:) == min(min(latitude))) = -90;

tuning_area = sum(interp_cell_areas(rate_interpolation > threshold));
%*********************************Tuning vector and angles*****************************************************
interp_vectors = zeros(nlatitude_cells*nlongitude_cells,3);
[interp_vectors(:,2), interp_vectors(:,1), interp_vectors(:,3)] = ...
    sph2cart(pi*longitude(:)/180,pi*latitude(:)/180, ...
    (rate_interpolation(:)+spon).*interp_cell_areas(:));
tuning_vector = 1.066*sum(interp_vectors)/sum((rate_interpolation(:)+spon).*interp_cell_areas(:));
%1.066 is an adjustment so that a response to only one location has a magnitude of 1;
[~,~,tuning_vector_magnitude] = cart2sph(tuning_vector(2),tuning_vector(1),tuning_vector(3));
tuning_vector_magnitude = min(tuning_vector_magnitude,1);

rate_interpolation (1:18, :) = [];  %remove the lower part of SRF
latlim_1 = [0 90] ;
latlim_2 = [0 90] ;
spatialR = georasterref('RasterSize', size(rate_interpolation), 'Latlim', latlim_1 , 'Lonlim', [-180 180]);
%spatialref.GeoRasterReference object
ax = axesm('MapProjection', 'mollweid', 'MapLatLimit',latlim_2);%fournier is used by Evan's paper
ax.Visible = 'off';

%**************************************************************Plot SRF******************************************
if plot_on==1
    %Show the inter-polated spike rates
    geoshow(rate_interpolation, spatialR,'DisplayType', 'texturemap');
    colormap(jet)
    absolute_maximum = max(abs(rates));
    set(gca,'Clim',[-1*absolute_maximum absolute_maximum]);
    %Show threshold contour/boundary
    geoshow(threshold_contour(2,:),threshold_contour(1,:),'color','k','linewidth',2);
end
%**************************************************************Plot SRF******************************************

%Show the white-circle hemisphere line
hemisphere_line = [-90*ones(181,1) (-90:90)'; 90*ones(181,1) (90:-1:-90)'];
geoshow(hemisphere_line(:,2), hemisphere_line(:,1),'color', 'white', 'linewidth', 1.5);

%Show speaker locations
location_numbers = 1:speaker_number;
passive_locations = ones(1,speaker_number);
number_of_passive = speaker_number;
locations = struct('Geometry','Point', ...
    'lat',mat2cell(speaker_locations(~~passive_locations,2),ones(1,number_of_passive)), ...
    'long',mat2cell(speaker_locations(~~passive_locations,1), ones(1,number_of_passive)), ...
    'Name',cellstr(num2str(location_numbers(~~passive_locations)')));
locations (17:end)=[]; %do not show the lower 8 speakers
if plot_on==1
    %Show the speakers in black colors
    geoshow(locations,'Marker','o', 'MarkerFaceColor','k', 'MarkerEdgeColor','k', 'MarkerSize', 5);
elseif plot_on==0    
    %Show the angles of Meridian(azimuth) & Parallel(elevation) lines; seems hard to adjust the positions
%     setm(ax, 'MeridianLabel', 'On', 'ParallelLabel','On', 'FontName','Arial', 'FontSize', 6, 'LabelFormat','none'); % 
%     ax.; ax.FontSize=16; ax.FontUnits='centimeters'; %not works here, as the figure will be shrinked
    %Show the speakers in three different colors
    geoshow(locations([6 10 11 14]-1), 'Marker','o', 'MarkerFaceColor', Color2, 'MarkerEdgeColor', Color2, 'MarkerSize', 5); hold on
    geoshow(locations([4 5 7 8 13]-1), 'Marker','o', 'MarkerFaceColor', Color3, 'MarkerEdgeColor', Color3, 'MarkerSize', 5); hold on
    geoshow(locations([9 2 3 12 15 16]-1), 'Marker','o', 'MarkerFaceColor', Color4, 'MarkerEdgeColor', Color4, 'MarkerSize', 5); hold on
end   
%Show the grids around different elevation&azimuth
setm(ax,'Grid','on','Frame','off','MlabelParallel',5,'LabelFormat','none'); axis off